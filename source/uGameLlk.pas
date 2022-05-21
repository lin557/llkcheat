unit uGameLlk;

interface

uses
  Winapi.Windows, System.Classes, system.SysUtils, Vcl.Graphics, Vcl.ExtCtrls;

const
  LLK_MAIN_WIDTH = 589;
  LLK_MAIN_HEIGHT = 385;
  LLK_MAIN_LEFT = 14;
  LLK_MAIN_TOP = 181;

  LLK_TILE_ROW = 11;
  LLK_TILE_COL = 19;
  LLK_TILE_WIDTH = 31;
  LLK_TILE_HEIGHT = 35;


  LLK_TILE_EMPTY = 0;

type
  TCoord = packed record
    Col: Integer;
    Row: Integer;
  end;

  TTile = packed record
    Index: Integer;
    Coord: TCoord;
    Rect: TRect;
  end;

  TTileTable = array[0..LLK_TILE_ROW - 1, 0..LLK_TILE_COL - 1] of TTile;


  {
    LeftTop     └
    RightTop    ┘
    LeftBottom  ┌
    RightBottom ┐
  }

  // 拐弯 先横向，后竖向
  TTurnRound = (
    trNone = 0,
    trHorizontal = 1,
    TrVertical = 2,
    trLeftTop = 3,
    trRightTop = 4,
    trLeftBottom = 5,
    trRightBottom = 6
  );

  TPathList = class(TObject)
  private
    FList: TList;
    FList_1: TList;     // 存属性
    function GetCount: Integer;
    function Get(Index: Integer): Integer;
    procedure Put(Index: Integer; const Value: Integer);
  public
    constructor Create;
    destructor Destroy; override;

    function Add(Col, Row: Byte; T: TTurnRound = trNone): Integer; overload;
    function Add(Value: Integer; T: TTurnRound = trNone): Integer; overload;
    procedure Clear;
    function Delete(Col, Row: Byte): Boolean;
    procedure Insert(Col, Row: Byte; T: TTurnRound = trNone);
    function IndexOf(Col, Row: Byte): Integer;

    function GetCol(Index: Integer): Byte;
    function GetRow(Index: Integer): Byte;
    function GetZ(Index: Integer): TTurnRound;
    procedure SetZ(Index: Integer; Z: Byte);

    property Count: Integer read GetCount;
    property Items[Index: Integer]: Integer read Get write Put; default;
  end;

  TMatchEvent = procedure(Sender: TObject; vBitmap: TBitmap; uMatch: Integer) of object;

  TGameLlk = class(TObject)
  private
    FTimerMatch: TTimer;
    FTimerCheck: TTimer;
    FBitmap: TBitmap;
    FCanvas: TCanvas;
    FTileTable: TTileTable;
    FProcHandle: THandle;
    FOnMatch: TMatchEvent;

    procedure TimerMatchTimer(Sender: TObject);
    procedure TimerCheckTimer(Sender: TObject);

    function CheckPath(Start, Target: TTile): Boolean;
    function FindTarget(vStart: TTile; var vTarget: TTile): Boolean;
    procedure GetGameData();
    function GetGameHandle(): THandle;
    procedure CheckGameProcess();
    function GetImgId(vRow, vCol: Integer): Integer;
    function GetTileToColor(vTarget: TTile): TColor;
    function Match(): Integer;

  public
    constructor Create();
    destructor Destroy; override;

    procedure Snap;

    property OnMatch: TMatchEvent read FOnMatch write FOnMatch;
  end;

  {**
   * 获取棋盘起点（左上角）地址
   *}
  function GetChessRoot(pHandle: THandle): Cardinal;
  procedure GetTiles(pHandle: THandle; var table: TTileTable);

implementation

function GetGameRootPath(): Cardinal;
begin
  asm
    PUSHAD
    // 00181044
    MOV     EAX, [$004941D0]
    // 00181044 + 0C44 = 00181C88
    ADD     EAX, $0C44
    // [00181C88 + 187F4] = 24D17D0
    ADD     EAX, $187F4
    MOV     EBX, [EAX]
    // [24D17D0 + 4] = 199F54
    ADD     EBX, $4
    MOV     EAX, [EBX]
    ADD     EAX, 8
    MOV     Result, EAX
    POPAD
  end;
end;

function GetChessRoot(pHandle: THandle): Cardinal;
var
  pOwner: DWORD;
  pAddr: DWORD;
  lpNumber: NativeUInt;
begin
  pAddr := $004941D0;
  ReadProcessMemory(pHandle, Pointer(pAddr), @pOwner, SizeOf(pOwner), lpNumber);
  pAddr := pOwner + $0C44 + $0187F4;
  ReadProcessMemory(pHandle, Pointer(pAddr), @pOwner, SizeOf(pOwner), lpNumber);
  pAddr := pOwner + $04;
  ReadProcessMemory(pHandle, Pointer(pAddr), @pOwner, SizeOf(pOwner), lpNumber);
  Result := pOwner + $08;
end;

procedure GetTiles(pHandle: THandle; var table: TTileTable);
var
  pAddr: DWORD;
  pOwner: Byte;
  lpNumber: NativeUInt;
  x, y: Integer;
  vRect: TRect;
begin
  pAddr := GetChessRoot(pHandle);
  for x := 0 to LLK_TILE_ROW - 1 do
  begin
    for y := 0 to LLK_TILE_COL - 1 do
    begin
      ReadProcessMemory(pHandle, Pointer(pAddr), @pOwner, SizeOf(pOwner), lpNumber);
      vRect := Rect(y * LLK_TILE_WIDTH, x * LLK_TILE_HEIGHT,  y * LLK_TILE_WIDTH + LLK_TILE_WIDTH, x * LLK_TILE_HEIGHT + LLK_TILE_HEIGHT);
      table[x, y].Rect := vRect;
      table[x, y].Coord.Col := y;
      table[x, y].Coord.Row := x;
      table[x, y].Index := pOwner;
      pAddr := pAddr + 1;
    end;
  end;
end;

{ TPathList }

function TPathList.Add(Col, Row: Byte; T: TTurnRound): Integer;
var
  n: Integer;
begin
  n := Col shl 8 + Row;
  Result := FList.Add(Pointer(n));
  FList_1.Add(Pointer(T));
end;

function TPathList.Add(Value: Integer; T: TTurnRound): Integer;
begin
  Result := FList.Add(Pointer(Value));
  FList_1.Add(Pointer(T));
end;

procedure TPathList.Clear;
begin
  FList.Clear;
  FList_1.Clear;
end;

constructor TPathList.Create;
begin
  FList := TList.Create;
  FList_1 := TList.Create;
end;

function TPathList.Delete(Col, Row: Byte): Boolean;
var
  n: Integer;
begin
  n := IndexOf(Col, Row);
  if n > -1 then
  begin
    FList.Delete(n);
    FList_1.Delete(n);
    Result := True;
  end else
    Result := False;
end;

destructor TPathList.Destroy;
begin
  FList.Free;
  FList_1.Free;
  inherited;
end;

function TPathList.Get(Index: Integer): Integer;
begin
  if (Index < 0) or (Index >= Count) then
    Result := -1
  else
    Result := Integer(FList[Index]);
end;

function TPathList.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TPathList.GetCol(Index: Integer): Byte;
var
  n: Integer;
begin
  n := Integer(FList[Index]);
  Result := n and $0000FF00 shr 8;
end;

function TPathList.GetRow(Index: Integer): Byte;
begin
  Result := (Integer(FList[Index]) and $000000FF);
end;

function TPathList.GetZ(Index: Integer): TTurnRound;
begin
  Result := TTurnRound(Integer(FList_1[Index]));
end;

function TPathList.IndexOf(Col, Row: Byte): Integer;
var
  n: Integer;
begin
  n := Col shl 8 + Row;
  Result := FList.IndexOf(Pointer(n));
end;

procedure TPathList.Insert(Col, Row: Byte; T: TTurnRound);
var
  n: Integer;
begin
  n := Col shl 8 + Row;
  FList.Insert(0, Pointer(n));
  FList_1.Insert(0, Pointer(T));
end;

procedure TPathList.Put(Index: Integer; const Value: Integer);
begin
  if (Index < 0) or (Index >= Count) then
    Exit;
  if Pointer(Value) <> FList[Index] then
    FList[Index] := Pointer(Value);
end;

procedure TPathList.SetZ(Index: Integer; Z: Byte);
begin
  FList_1[Index] := Pointer(Z);
end;

{ TGameLlk }

procedure TGameLlk.CheckGameProcess;
var
  hWnd: THandle;
  pid: Cardinal;
begin
  hWnd := GetGameHandle;
  if (hWnd <> 0) and IsWindow(hWnd) then
  begin
    //Caption := 'LLK (已启动)';
    // 窗口存在
    if FProcHandle = 0 then
    begin
      GetWindowThreadProcessId(hWnd, @pid);
      FProcHandle := OpenProcess(PROCESS_ALL_ACCESS, false, pid);
      FTimerMatch.Enabled := True;
    end;
  end else
  begin
    //Caption := 'LLK (未开始)';
    // 如果窗口不存在  但
    if FProcHandle > 0 then
    begin
      CloseHandle(FProcHandle);
      FProcHandle := 0;
    end;
    FTimerMatch.Enabled := False;
  end;
end;

function TGameLlk.CheckPath(Start, Target: TTile): Boolean;
var
  a, b, x, i, j: Integer;
  imgIdA, imgIdB: Integer;
  bClear, bCheck: Boolean;
  list1, list2, list3, list4, list5, list6: TPathList;
begin
  // 查换配对的方块算法
  Result := False;
  // 同一张方块 退出
  if (Start.Coord.Col = Target.Coord.Col) and (Start.Coord.Row = Target.Coord.Row) then
    Exit;
  // 选中无效  或 不同类型
  imgIdA := Start.Index;
  imgIdB := Target.Index;
  if (imgIdA = LLK_TILE_EMPTY) or (imgIdB = LLK_TILE_EMPTY) or (imgIdA <> imgIdB) then
    Exit;

  // 判断是否可以消除

  // 同一行
  if Start.Coord.Row = Target.Coord.Row then
  begin
    // 相临
    if abs(Start.Coord.Col - Target.Coord.Col) = 1 then
    begin
      bClear := True;
      Result := bClear;
      Exit;
    end;
  end;
  // 同一列
  if Start.Coord.Col = Target.Coord.Col then
  begin
    // 相临
    if abs(Start.Coord.Row - Target.Coord.Row) = 1 then
    begin
      bClear := True;
      Result := bClear;
      Exit;
    end;
  end;
  // 不同行或不同列，或中间有障碍

  list1 := TPathList.Create;
  list2 := TPathList.Create;
  list3 := TPathList.Create;
  list4 := TPathList.Create;
  list5 := nil;
  list6 := nil;
  try
    // 水平 -------- start --------中间空白

    // 开始点向右
    for i := Start.Coord.Col + 1 to LLK_TILE_COL - 1 do
    begin
      if GetImgId(Start.Coord.Row, i) = LLK_TILE_EMPTY then
      begin
        list1.Add(i, Start.Coord.Row);
      end else
        Break;
    end;
    // 开始点向左
    for i := Start.Coord.Col - 1 downto 0 do
    begin
      if GetImgId(Start.Coord.Row, i) = LLK_TILE_EMPTY then
      begin
        list1.Insert(i, Start.Coord.Row);
      end else
        Break;
    end;
    // 目标点向右
    for i := Target.Coord.Col + 1 to LLK_TILE_COL - 1 do
    begin
      if GetImgId(Target.Coord.Row, i) = LLK_TILE_EMPTY then
      begin
        list2.Add(i, Target.Coord.Row);
      end else
        Break;
    end;
    // 目标点向左
    for i := Target.Coord.Col - 1 downto 0 do
    begin
      if GetImgId(Target.Coord.Row, i) = LLK_TILE_EMPTY then
      begin
        list2.Insert(i, Target.Coord.Row);
      end else
        Break;
    end;
    // 有交点
    for i := 0 to List1.Count - 1 do
    begin
      for j := 0 to List2.Count - 1 do
      begin
        if list1[i] = list2[j] then
        begin
          bClear := True;
          Result := bClear;
          Exit;
        end;
      end;
    end;

    // 水平 -------- end ----------

    // 垂直 ------ start -------中间空白
    // 开始点向下
    for i := Start.Coord.Row + 1 to LLK_TILE_ROW - 1 do
    begin
      if GetImgId(i, Start.Coord.Col) = LLK_TILE_EMPTY then
      begin
        list3.Add(Start.Coord.Col, i);
      end else
        Break;
    end;
    // 开始点向上
    for i := Start.Coord.Row - 1 downto 0 do
    begin
      if GetImgId(i, Start.Coord.Col) = LLK_TILE_EMPTY then
      begin
        list3.Insert(Start.Coord.Col, i);
      end else
        Break;
    end;
    // 目标点向下
    for i := Target.Coord.Row + 1 to LLK_TILE_ROW - 1 do
    begin
      if GetImgId(i, Target.Coord.Col) = LLK_TILE_EMPTY then
      begin
        list4.Add(Target.Coord.Col, i);
      end else
        Break;
    end;
    // 目标点向下上
    for i := Target.Coord.Row - 1 downto 0 do
    begin
      if GetImgId(i, Target.Coord.Col) = LLK_TILE_EMPTY then
      begin
        list4.Insert(Target.Coord.Col, i);
      end else
        Break;
    end;
    // 有交点
    for i := 0 to List3.Count - 1 do
    begin
      for j := 0 to List4.Count - 1 do
      begin
        if list3[i] = list4[j] then
        begin
          bClear := True;
          Result := bClear;
          Exit;
        end;
      end;
    end;
    // 垂直 ------ end -------

    // 1 起点水平 2 终点水平 3 起点垂直 4 终点垂直

    // 起点的水平线与终点垂直线检查是否相交
    for i := 0 to List1.Count - 1 do
    begin
      for j := 0 to List4.Count - 1 do
      begin
        if list1[i] = list4[j] then
        begin
          // 有交点
          bClear := True;
          Result := bClear;
          Exit;
        end;
      end;
    end;

    // 起点的垂直线与终点的水平线检查是否相交
    for i := 0 to List3.Count - 1 do
    begin
      for j := 0 to List2.Count - 1 do
      begin
        if list3[i] = list2[j] then
        begin
          // 有交点
          bClear := True;
          Result := bClear;
          Exit;
        end;
      end;
    end;


    // 以下是两个折的判断
    list5 := TPathList.Create;
    list6 := TPathList.Create;

    // 取出水平共同点
    for i := 0 to list1.Count - 1 do
    begin
      for j := 0 to List2.Count - 1 do
      begin
        if list1.GetCol(i) = list2.GetCol(j) then    // col 相同 row 不同
        begin
          list5.Add(list1[i]);
          list6.Add(list2[j]);
        end;
      end;
    end;

    if list5.Count > 0 then
    begin
      for i := 0 to list5.Count - 1 do
      begin
        a := list5.GetRow(i);
        b := list6.GetRow(i);

        if a > b then
        begin
          x := a;    // 由小到大
          a := b;
          b := x;
        end;
        bCheck := False;
        x := list5.GetCol(i);
        for j := a to b do
        begin
          if GetImgId(j, x) <> LLK_TILE_EMPTY then
          begin
            bCheck := True;   // 说明中间有障碍
            Break;
          end;
        end;

        if not bCheck then
        begin
          bClear := True;     // 可连通
          Result := bClear;
          Exit;
        end;
      end;
    end;

    list5.Clear;
    list6.Clear;
    // 取出垂直共同点
    for i := 0 to list3.Count - 1 do
    begin
      for j := 0 to List4.Count - 1 do
      begin
        if list3.GetRow(i) = list4.GetRow(j) then    // row 相同 col 不同
        begin
          list5.Add(list3[i]);
          list6.Add(list4[j]);
        end;
      end;
    end;

    for i := 0 to list5.Count - 1 do
    begin
      a := list5.GetCol(i);
      b := list6.GetCol(i);

      if a > b then
      begin
        x := a;    // 由小到大
        a := b;
        b := x;
      end;
      bCheck := False;
      x := list5.GetRow(i);
      for j := a to b do
      begin
        if GetImgId(x, j) <> LLK_TILE_EMPTY then
        begin
          bCheck := True;   // 说明中间有障碍
          Break;
        end;
      end;

      if not bCheck then
      begin
        bClear := True;     // 可连通
        Result := bClear;
        Exit;
      end;
    end;
  finally
    list1.Free;
    list2.Free;
    list3.Free;
    list4.Free;
    list5.Free;
    list6.Free;
  end;
end;

constructor TGameLlk.Create;
begin
  FTimerMatch := TTimer.Create(nil);
  FTimerMatch.Interval := 85;
  FTimerMatch.OnTimer := TimerMatchTimer;
  FTimerMatch.Enabled := False;

  FTimerCheck := TTimer.Create(nil);
  FTimerCheck.OnTimer := TimerCheckTimer;
  FTimerCheck.Interval := 300;
  FTimerCheck.Enabled := True;

  FProcHandle := 0;
  FCanvas := TCanvas.Create;
  FBitmap := TBitmap.Create(LLK_MAIN_WIDTH, LLK_MAIN_HEIGHT);
  FBitmap.Canvas.Pen.Color := clLime;
  FBitmap.Canvas.Pen.Style := psInsideFrame;
  FBitmap.Canvas.Pen.Width := 3;
  FBitmap.Canvas.Brush.Color := clWhite;
  FBitmap.Canvas.Brush.Style := bsBDiagonal;
end;

destructor TGameLlk.Destroy;
begin
  FTimerMatch.Free;
  FTimerCheck.Free;
  FBitmap.Free;
  FCanvas.Free;
  CloseHandle(FProcHandle);
  inherited;
end;

function TGameLlk.FindTarget(vStart: TTile; var vTarget: TTile): Boolean;
var
  x, y: Integer;
begin
  Result := False;
  for x := 0 to LLK_TILE_ROW - 1 do
  begin
    for y := 0 to LLK_TILE_COL - 1 do
    begin
      vTarget := FTileTable[x, y];

      if CheckPath(vStart, vTarget) then
      begin
        Result := True;
        Break;
      end;
    end;
    if Result then
      Break;
  end;
end;

procedure TGameLlk.GetGameData;
var
  hWnd: Winapi.Windows.HWND;
  hDc: Winapi.Windows.HDC;
//  vRect: TRect;
begin
  hWnd := GetGameHandle();
  if (hWnd = 0) or (FProcHandle = 0) or (not IsWindow(hWnd))  then
    Exit;
  hDc := GetDC(hWnd);
  try
    FCanvas.Handle := hDc;

//    GetWindowRect(hWnd, vRect);
    FBitmap.Canvas.CopyRect(Rect(0, 0, LLK_MAIN_WIDTH, LLK_MAIN_HEIGHT), FCanvas, Rect(LLK_MAIN_LEFT, LLK_MAIN_TOP, LLK_MAIN_LEFT + LLK_MAIN_WIDTH, LLK_MAIN_TOP + LLK_MAIN_HEIGHT));
//    Image1.Picture.Bitmap := FBitmap;
  finally
    ReleaseDC(hWnd, hDc);
  end;
  GetTiles(FProcHandle, FTileTable);
end;

function TGameLlk.GetGameHandle: THandle;
begin
  Result := FindWindow(nil, 'QQ游戏 - 连连看角色版');
end;

function TGameLlk.GetImgId(vRow, vCol: Integer): Integer;
begin
  Result := FTileTable[vRow, vCol].Index;
end;

function TGameLlk.GetTileToColor(vTarget: TTile): TColor;

  function RgbToColor(R,G,B: byte): TColor;
  begin
    Result := B Shl 16 or G  shl 8 or R;
  end;

begin
  case vTarget.Index of
    2: Result := clOlive;
    3: Result := RgbToColor(39, 215, 31);
    4: Result := RgbToColor(218, 112, 214);
    5: Result := RgbToColor(100, 149, 237);
    6: Result := RgbToColor(215, 87, 247);
    7: Result := RgbToColor(151, 79, 95);
    8: Result := clRed;
    9: Result := clBlue;
    10: Result := clGreen;
    11: Result := clAqua;
    12: Result := clMaroon;
    13: Result := RgbToColor(255, 20, 147);
    14: Result := RgbToColor(25, 25, 122);
    15: Result := clTeal;
    16: Result := clLime;
    17: Result := RgbToColor(39, 247, 239);
    18: Result := clNavy;
    19: Result := clPurple;
    20: Result := clFuchsia;
    21: Result := RgbToColor(25, 25, 122);
    22: Result := RgbToColor(0, 255, 127);
    23: Result := RgbToColor(218, 112, 214);
    24: Result := RgbToColor(244, 164, 96);
    25: Result := RgbToColor(188, 143, 143);
    26: Result := RgbToColor(255, 125, 64);
    27: Result := RgbToColor(156, 102, 31);
    28: Result := RgbToColor(255, 127, 80);
    29: Result := RgbToColor(50, 205, 50);
    30: Result := RgbToColor(189, 252, 201);
    31: Result := RgbToColor(255, 192, 203);
    32: Result := RgbToColor(255, 69, 0);
    33: Result := RgbToColor(255, 99, 71);
    34: Result := RgbToColor(0, 199, 144);
    35: Result := RgbToColor(25, 25, 112);
    36: Result := RgbToColor(51, 161, 201);
    37: Result := RgbToColor(30, 144, 255);

    240: Result := RgbToColor(61, 89, 171);
    241: Result := RgbToColor(173, 48, 96);
    242: Result := RgbToColor(208, 32, 144);
    243: Result := RgbToColor(72, 61, 139);
    244: Result := RgbToColor(165, 42, 42);
    245: Result := RgbToColor($6B, $8E, $23);
    246: Result := RgbToColor($9A, $CD, $32);
    247: Result := RgbToColor($98, $FB, $98);
  else
    Result := clBlack;
  end;
end;

function TGameLlk.Match: Integer;
var
  x, y, i, c: Integer;
  vStart, vTarget: TTile;
  bUsed: Boolean;
  usedTiles: array of TTile;
begin
  c := 0;
  for x := 0 to LLK_TILE_ROW - 1 do
  begin
    for y := 0 to LLK_TILE_COL - 1 do
    begin
      vStart := FTileTable[x, y];
      if vStart.Index = LLK_TILE_EMPTY then
        Continue;

      // 已用的点不检测
      bUsed := False;
      for i := 0 to Length(usedTiles) - 1 do
      begin
        if (vStart.Coord.Col = usedTiles[i].Coord.Col) and (vStart.Coord.Row = usedTiles[i].Coord.Row) then
        begin
          bUsed := True;
          Break;
        end;
      end;

      if bUsed then
        Continue;

      if FindTarget(vStart, vTarget) then
      begin
        // 判断结果是否被用
        bUsed := False;
        for i := 0 to Length(usedTiles) - 1 do
        begin
          if (vTarget.Coord.Col = usedTiles[i].Coord.Col) and (vTarget.Coord.Row = usedTiles[i].Coord.Row) then
          begin
            bUsed := True;
            Break;
          end;
        end;

        if bUsed then
          Continue;

        Inc(c);
            // 画出来
//        case c of
//         1: FBitmap.Canvas.Pen.Color := clRed;
//         2: FBitmap.Canvas.Pen.Color := clBlue;
//         3: FBitmap.Canvas.Pen.Color := clFuchsia;
//         4: FBitmap.Canvas.Pen.Color := clLime;
//         5: FBitmap.Canvas.Pen.Color := clOlive;
//         6: FBitmap.Canvas.Pen.Color := clPurple;
//         7: FBitmap.Canvas.Pen.Color := clTeal;
//         8: FBitmap.Canvas.Pen.Color := clGreen;
//         9: FBitmap.Canvas.Pen.Color := clMoneyGreen;
//         10: FBitmap.Canvas.Pen.Color := clSkyBlue;
//         11: FBitmap.Canvas.Pen.Color := clCream;
//         12: FBitmap.Canvas.Pen.Color := clAqua;
//         13: FBitmap.Canvas.Pen.Color := clMaroon;
//         14: FBitmap.Canvas.Pen.Color := clGray;
//         15: FBitmap.Canvas.Pen.Color := clWhite;
//         16: FBitmap.Canvas.Pen.Color := clYellow;
//        else
          FBitmap.Canvas.Pen.Color := GetTileToColor(vTarget);
//        end;
        FBitmap.Canvas.Pen.Width := 3;
        FBitmap.Canvas.Rectangle(vStart.Rect);
        FBitmap.Canvas.Rectangle(vTarget.Rect);
        FBitmap.Canvas.Pen.Width := 2;
        FBitmap.Canvas.MoveTo(vStart.Rect.Left + 15, vStart.Rect.Top + 16);
        FBitmap.Canvas.LineTo(vTarget.Rect.Left + 15, vTarget.Rect.Top + 16);
        SetLength(usedTiles, Length(usedTiles) + 2);
        usedTiles[Length(usedTiles) - 2] := vStart;
        usedTiles[Length(usedTiles) - 1] := vTarget;
      end;
    end;
  end;
  //Image1.Picture.Bitmap := FBitmap;
  Result := c;
end;

procedure TGameLlk.Snap;
var
  hWnd: Winapi.Windows.HWND;
  hDc: Winapi.Windows.HDC;
  vRect: TRect;
  vBmp: TBitmap;
begin
  hWnd := GetGameHandle();
  if (hWnd = 0) then
    Exit;
  hDc := GetDC(hWnd);
  try
    FCanvas.Handle := hDc;

    GetWindowRect(hWnd, vRect);
    vBmp := TBitmap.Create(vRect.Width, vRect.Height);
//    vBmp.Canvas.CopyRect(Rect(0, 0, vRect.Width, vRect.Height), FCanvas, Rect(0, 0, vRect.Width, vRect.Height));
//    vBmp.SaveToFile('c:/main.bmp');


    vBmp.Width := LLK_MAIN_WIDTH;
    vBmp.Height := LLK_MAIN_HEIGHT;
    vBmp.Canvas.CopyRect(Rect(0, 0, LLK_MAIN_WIDTH, LLK_MAIN_HEIGHT), FCanvas, Rect(LLK_MAIN_LEFT, LLK_MAIN_TOP, LLK_MAIN_LEFT + LLK_MAIN_WIDTH, LLK_MAIN_TOP + LLK_MAIN_HEIGHT));
    vBmp.SaveToFile('c:/' + FormatDateTime('/hhnnsszzz', now) + '.bmp');

//    vBmp.Width := LLK_TILE_WIDTH;
//    vBmp.Height := LLK_TILE_HEIGHT;
//    vBmp.Canvas.CopyRect(Rect(0, 0, LLK_MAIN_WIDTH, LLK_MAIN_HEIGHT), FCanvas, Rect(18, 565, 18 + LLK_MAIN_WIDTH, 565 + LLK_MAIN_HEIGHT));
//    vBmp.SaveToFile('c:/flag.bmp');

    vBmp.Free;
  finally
    ReleaseDC(hWnd, hDc);
  end;
end;

procedure TGameLlk.TimerCheckTimer(Sender: TObject);
begin
  CheckGameProcess();
end;

procedure TGameLlk.TimerMatchTimer(Sender: TObject);
var
  c: Integer;
begin
  GetGameData();
  c := Match();
  if Assigned(OnMatch) then
    OnMatch(Self, FBitmap, c);
end;

end.
