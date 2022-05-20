unit uFrmLlk;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,

  uGame;

type
  TFrmLlk = class(TForm)
    BtnPlay: TButton;
    BtnAnalyse: TButton;
    PnlMain: TPanel;
    Image1: TImage;
    PnlTop: TPanel;
    BtnMatch: TButton;
    BtnSnap: TButton;
    LblMatch: TLabel;
    TimerMatch: TTimer;
    TimerCheckGame: TTimer;
    Button1: TButton;
    procedure BtnPlayClick(Sender: TObject);
    procedure BtnAnalyseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure BtnSnapClick(Sender: TObject);
    procedure BtnMatchClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure TimerCheckGameTimer(Sender: TObject);
    procedure TimerMatchTimer(Sender: TObject);
  private
    { Private declarations }
    FBitmap: TBitmap;
    FBmpTile: TBitmap;
    FCanvas: TCanvas;
    FTileTable: TTileTable;
    FArrayTile: array[0..44] of Integer;
    FProcHandle: THandle;

    function BmpToFlag(vBmp: TBitmap): Integer;
    procedure CatchGameImage();
    function CheckTileFlag(uFlag: Integer; var no: Boolean): Integer;
    procedure GetGameData(vBmp: TBitmap; bSave: Boolean = False);
    function GetGameHandle(): THandle;
    function GetImgId(vRow, vCol: Integer): Integer;
    function CheckPath(Start, Target: TTile): Boolean;
    function FindTarget(vStart: TTile; var vTarget: TTile): Boolean;
    procedure InitTiles();
    function Match(): Integer;
    function GetTileToColor(vTarget: TTile): TColor;

    procedure CheckGameProcess();
  public
    { Public declarations }
  end;

var
  FrmLlk: TFrmLlk;

implementation

{$R *.dfm}

function TFrmLlk.BmpToFlag(vBmp: TBitmap): Integer;
var
  vP: PByteArray;
  x, y, z: Integer;
begin
  z := 0;
  vBmp.PixelFormat := pf24bit;
  for y := 14 to vBmp.Height - 15 - 1 do
  begin
    vP := vBmp.ScanLine[y];
    for x := 12 to vBmp.Width - 13 - 1 do
    begin
      z := z + vP[x * 3] + vP[x * 3 + 1]  + vP[x * 3 + 2];
    end;
  end;
  Result := z;
end;

procedure TFrmLlk.BtnPlayClick(Sender: TObject);
begin
  CatchGameImage();
  LblMatch.Caption := 'LLK Match = ' + IntToStr( Match() );
end;

procedure TFrmLlk.BtnAnalyseClick(Sender: TObject);
var
  vBmp: TBitmap;
begin
  vBmp := TBitmap.Create;
  vBmp.LoadFromFile('c:\llk02.bmp');
  GetGameData(vBmp, True);
  vBmp.Free;
end;

procedure TFrmLlk.BtnMatchClick(Sender: TObject);
var
  vBmp: TBitmap;
  vList, vList2: TStringList;
  i: Integer;
begin
  vBmp := TBitmap.Create(LLK_TILE_WIDTH, LLK_TILE_HEIGHT);
  vList := TStringList.Create;
  vList2 := TStringList.Create;
  vBmp.LoadFromFile('icon/flag.bmp');
  vList.Add(Format('LLK_FLAG_START = %d;', [BmpToFlag(vBmp)]));
  vList2.Add(IntToStr(BmpToFlag(vBmp)));
  for i := 0 to 44 do
  begin
    vBmp.LoadFromFile(Format('icon/%0.2d.bmp', [i]));
    vList.Add( Format('LLK_TILE_%0.2d = %d;', [i, BmpToFlag(vBmp)]) );
    vList2.Add(IntToStr(BmpToFlag(vBmp)));
  end;

  vList2.Sort;
  vList.AddStrings(vList2);
  vList.SaveToFile('c:/list.txt');

  vList.Free;
  vList2.Free;
  vBmp.Free;
end;

procedure TFrmLlk.BtnSnapClick(Sender: TObject);
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

procedure TFrmLlk.Button1Click(Sender: TObject);
begin
  GetTiles(FProcHandle, FTileTable);
end;

procedure TFrmLlk.CatchGameImage;
var
  hWnd: Winapi.Windows.HWND;
  hDc: Winapi.Windows.HDC;
  vRect: TRect;
begin
  hWnd := GetGameHandle();
  if (hWnd = 0) then
    Exit;
  hDc := GetDC(hWnd);
  try
    FCanvas.Handle := hDc;

    GetWindowRect(hWnd, vRect);
    FBmpTile.Canvas.CopyRect(Rect(0, 0, LLK_TILE_WIDTH, LLK_TILE_HEIGHT), FCanvas, Rect(18, 565, 18 + LLK_TILE_WIDTH, 565 + LLK_TILE_HEIGHT));
    if BmpToFlag(FBmpTile) <> LLK_FLAG_START then
    begin
      Caption := 'LLK (未开始)';
      Exit;
    end;
    Caption := 'LLK (游戏中)';

    FBitmap.Canvas.CopyRect(Rect(0, 0, LLK_MAIN_WIDTH, LLK_MAIN_HEIGHT), FCanvas, Rect(LLK_MAIN_LEFT, LLK_MAIN_TOP, LLK_MAIN_LEFT + LLK_MAIN_WIDTH, LLK_MAIN_TOP + LLK_MAIN_HEIGHT));

    // FBitmap.SaveToFile('c:/' + FormatDateTime('/hhnnss', now) + '.bmp');

    GetGameData(FBitmap);
  finally
    ReleaseDC(hWnd, hDc);
  end;
end;

function TFrmLlk.FindTarget(vStart: TTile; var vTarget: TTile): Boolean;
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

procedure TFrmLlk.FormCreate(Sender: TObject);
begin
  FProcHandle := 0;
  FCanvas := TCanvas.Create;
  FBitmap := TBitmap.Create(LLK_MAIN_WIDTH, LLK_MAIN_HEIGHT);
  FBitmap.Canvas.Pen.Color := clLime;
  FBitmap.Canvas.Pen.Style := psInsideFrame;
  FBitmap.Canvas.Pen.Width := 2;
  FBitmap.Canvas.Brush.Color := clWhite;
  FBitmap.Canvas.Brush.Style := bsBDiagonal;

  FBmpTile := TBitmap.Create(LLK_TILE_WIDTH, LLK_TILE_HEIGHT);

  InitTiles;
end;

procedure TFrmLlk.FormDestroy(Sender: TObject);
begin
  FBitmap.Free;
  FBmpTile.Free;
  FCanvas.Free;
  CloseHandle(FProcHandle);
end;

procedure TFrmLlk.GetGameData(vBmp: TBitmap; bSave: Boolean = False);
var
  x, y, uFlag: Integer;
  vRect: TRect;
  vList: TStringList;
  no: Boolean;
begin
  vList := nil;
  try
    if bSave then
      vList := TStringList.Create;
    for x := 0 to LLK_TILE_ROW - 1 do
    begin
      for y := 0 to LLK_TILE_COL - 1 do
      begin
        vRect := Rect(y * LLK_TILE_WIDTH, x * LLK_TILE_HEIGHT,  y * LLK_TILE_WIDTH + LLK_TILE_WIDTH, x * LLK_TILE_HEIGHT + LLK_TILE_HEIGHT);
        FBmpTile.Canvas.CopyRect(Rect(0, 0, LLK_TILE_WIDTH, LLK_TILE_HEIGHT), vBmp.Canvas, vRect);

        FTileTable[x, y].Rect := vRect;
        FTileTable[x, y].Coord.Col := y;
        FTileTable[x, y].Coord.Row := x;
        no := False;
        uFlag := BmpToFlag(FBmpTile);
        FTileTable[x, y].Index := CheckTileFlag( uFlag, no);
        if no then
        begin
          FBmpTile.SaveToFile(Format('c:/%d.bmp', [uFlag]));
        end;
        if bSave then
        begin
          FBmpTile.SaveToFile(Format('c:/%0.2d%0.2d.bmp', [x, y]));
          vList.Add(Format('%0.2d%0.2d - %d', [x, y, uFlag]));
        end;

//        FBitmap.Canvas.Draw(y * LLK_TILE_WIDTH, x * LLK_TILE_HEIGHT, bmp0);
      end;
    end;

    Image1.Picture.Bitmap := vBmp;
    if bSave then
      vList.SaveToFile('c:/xx.txt');
  finally
    vList.Free;
  end;
end;

function TFrmLlk.GetGameHandle: THandle;
begin
  Result := FindWindow(nil, 'QQ游戏 - 连连看角色版');
end;

function TFrmLlk.GetImgId(vRow, vCol: Integer): Integer;
begin
  Result := FTileTable[vRow, vCol].Index;
end;

function TFrmLlk.GetTileToColor(vTarget: TTile): TColor;

  function RgbToColor(R,G,B: byte): TColor;
  begin
    Result := B Shl 16 or G  shl 8 or R;
  end;

var
  i: Integer;
begin
  Result := clBlack;
  for i := 0 to Length(FArrayTile) - 1 do
  begin
    if vTarget.Index = FArrayTile[i] then
    begin
      case i of
        1: Result := RgbToColor(39, 247, 239);
        2: Result := RgbToColor(39, 215, 31);
        3: Result := RgbToColor(32, 40, 104);
        4: Result := RgbToColor(7, 51, 255);
        5: Result := RgbToColor(215, 87, 247);
        6: Result := RgbToColor(151, 79, 95);
        7: Result := clRed;
        8: Result := clBlue;
        9: Result := clGreen;
        10: Result := clAqua;
        11: Result := clMaroon;
        12: Result := clSkyBlue;
        13: Result := clMoneyGreen;
        14: Result := clTeal;
        15: Result := clLime;
        16: Result := clOlive;
        17: Result := clNavy;
        18: Result := clPurple;
        19: Result := clFuchsia;
        20: Result := clSilver;
        21: Result := RgbToColor(218, 112, 214);
        22: Result := RgbToColor(0, 255, 127);
        23: Result := RgbToColor(244, 164, 96);
        24: Result := RgbToColor(188, 143, 143);
        25: Result := RgbToColor(255, 125, 64);
        26: Result := RgbToColor(156, 102, 31);
        27: Result := RgbToColor(255, 127, 80);
        28: Result := RgbToColor(50, 205, 50);
        29: Result := RgbToColor(189, 252, 201);
        30: Result := RgbToColor(255, 192, 203);
        31: Result := RgbToColor(255, 69, 0);
        32: Result := RgbToColor(255, 99, 71);
        33: Result := RgbToColor(0, 199, 144);
        34: Result := RgbToColor(25, 25, 112);
        35: Result := RgbToColor(51, 161, 201);
        36: Result := RgbToColor(30, 144, 255);
        37: Result := RgbToColor(61, 89, 171);
        38: Result := RgbToColor(173, 48, 96);
        39: Result := RgbToColor($FF, $45, $00);
        40: Result := RgbToColor($B2, $22, $22);
        41: Result := RgbToColor($FF, $7F, $50);
        42: Result := RgbToColor($6B, $8E, $23);
        43: Result := RgbToColor($9A, $CD, $32);
        44: Result := RgbToColor($98, $FB, $98);
      else
        Result := clBlack;
      end;

      Break;
    end;
  end;

end;

procedure TFrmLlk.InitTiles;
begin
  FArrayTile[0] := LLK_TILE_00;
  FArrayTile[1] := LLK_TILE_01;
  FArrayTile[2] := LLK_TILE_02;
  FArrayTile[3] := LLK_TILE_03;
  FArrayTile[4] := LLK_TILE_04;
  FArrayTile[5] := LLK_TILE_05;
  FArrayTile[6] := LLK_TILE_06;
  FArrayTile[7] := LLK_TILE_07;
  FArrayTile[8] := LLK_TILE_08;
  FArrayTile[9] := LLK_TILE_09;
  FArrayTile[10] := LLK_TILE_10;
  FArrayTile[11] := LLK_TILE_11;
  FArrayTile[12] := LLK_TILE_12;
  FArrayTile[13] := LLK_TILE_13;
  FArrayTile[14] := LLK_TILE_14;
  FArrayTile[15] := LLK_TILE_15;
  FArrayTile[16] := LLK_TILE_16;
  FArrayTile[17] := LLK_TILE_17;
  FArrayTile[18] := LLK_TILE_18;
  FArrayTile[19] := LLK_TILE_19;
  FArrayTile[20] := LLK_TILE_20;
  FArrayTile[21] := LLK_TILE_21;
  FArrayTile[22] := LLK_TILE_22;
  FArrayTile[23] := LLK_TILE_23;
  FArrayTile[24] := LLK_TILE_24;
  FArrayTile[25] := LLK_TILE_25;
  FArrayTile[26] := LLK_TILE_26;
  FArrayTile[27] := LLK_TILE_27;
  FArrayTile[28] := LLK_TILE_28;
  FArrayTile[29] := LLK_TILE_29;
  FArrayTile[30] := LLK_TILE_30;
  FArrayTile[31] := LLK_TILE_31;
  FArrayTile[32] := LLK_TILE_32;
  FArrayTile[33] := LLK_TILE_33;
  FArrayTile[34] := LLK_TILE_34;
  FArrayTile[35] := LLK_TILE_35;
  FArrayTile[36] := LLK_TILE_36;
  FArrayTile[37] := LLK_TILE_37;
  FArrayTile[38] := LLK_TILE_38;
  FArrayTile[39] := LLK_TILE_39;
  FArrayTile[40] := LLK_TILE_40;
  FArrayTile[41] := LLK_TILE_41;
  FArrayTile[42] := LLK_TILE_42;
  FArrayTile[43] := LLK_TILE_43;
  FArrayTile[44] := LLK_TILE_44;
end;

function TFrmLlk.Match: Integer;
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
        FBitmap.Canvas.Rectangle(vStart.Rect);
        FBitmap.Canvas.Rectangle(vTarget.Rect);
        FBitmap.Canvas.MoveTo(vStart.Rect.Left + 15, vStart.Rect.Top + 16);
        FBitmap.Canvas.LineTo(vTarget.Rect.Left + 15, vTarget.Rect.Top + 16);
        SetLength(usedTiles, Length(usedTiles) + 2);
        usedTiles[Length(usedTiles) - 2] := vStart;
        usedTiles[Length(usedTiles) - 1] := vTarget;
      end;
    end;
  end;
  Image1.Picture.Bitmap := FBitmap;
  Result := c;
end;

procedure TFrmLlk.TimerCheckGameTimer(Sender: TObject);
begin
  CheckGameProcess
end;

procedure TFrmLlk.TimerMatchTimer(Sender: TObject);
begin
  BtnPlay.Click;
end;

procedure TFrmLlk.CheckGameProcess;
var
  hWnd: THandle;
  pid: Cardinal;
begin
  hWnd := GetGameHandle;
  if (hWnd <> 0) and IsWindow(hWnd) then
  begin
    // 窗口存在
    if FProcHandle = 0 then
    begin
      GetWindowThreadProcessId(hWnd, @pid);
      FProcHandle := OpenProcess(PROCESS_ALL_ACCESS, false, pid);
    end;
  end else
  begin
    // 如果窗口不存在  但
    if FProcHandle > 0 then
    begin
      CloseHandle(FProcHandle);
      FProcHandle := 0;
    end;
  end;
end;


function TFrmLlk.CheckPath(Start, Target: TTile): Boolean;
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
  if (imgIdA = LLK_TILE_00) or (imgIdB = LLK_TILE_00) or (imgIdA <> imgIdB) then
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
      if GetImgId(Start.Coord.Row, i) = LLK_TILE_00 then
      begin
        list1.Add(i, Start.Coord.Row);
      end else
        Break;
    end;
    // 开始点向左
    for i := Start.Coord.Col - 1 downto 0 do
    begin
      if GetImgId(Start.Coord.Row, i) = LLK_TILE_00 then
      begin
        list1.Insert(i, Start.Coord.Row);
      end else
        Break;
    end;
    // 目标点向右
    for i := Target.Coord.Col + 1 to LLK_TILE_COL - 1 do
    begin
      if GetImgId(Target.Coord.Row, i) = LLK_TILE_00 then
      begin
        list2.Add(i, Target.Coord.Row);
      end else
        Break;
    end;
    // 目标点向左
    for i := Target.Coord.Col - 1 downto 0 do
    begin
      if GetImgId(Target.Coord.Row, i) = LLK_TILE_00 then
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
      if GetImgId(i, Start.Coord.Col) = LLK_TILE_00 then
      begin
        list3.Add(Start.Coord.Col, i);
      end else
        Break;
    end;
    // 开始点向上
    for i := Start.Coord.Row - 1 downto 0 do
    begin
      if GetImgId(i, Start.Coord.Col) = LLK_TILE_00 then
      begin
        list3.Insert(Start.Coord.Col, i);
      end else
        Break;
    end;
    // 目标点向下
    for i := Target.Coord.Row + 1 to LLK_TILE_ROW - 1 do
    begin
      if GetImgId(i, Target.Coord.Col) = LLK_TILE_00 then
      begin
        list4.Add(Target.Coord.Col, i);
      end else
        Break;
    end;
    // 目标点向下上
    for i := Target.Coord.Row - 1 downto 0 do
    begin
      if GetImgId(i, Target.Coord.Col) = LLK_TILE_00 then
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
          if GetImgId(j, x) <> LLK_TILE_00 then
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
        if GetImgId(x, j) <> LLK_TILE_00 then
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

function TFrmLlk.CheckTileFlag(uFlag: Integer; var no: Boolean): Integer;
var
  i: Integer;
begin
  Result := LLK_TILE_00;
  no := True;
  for i := 0 to Length(FArrayTile) - 1 do
  begin
    if FArrayTile[i] = uFlag then
    begin
      no := False;
      Result := uFlag;
      Exit;
    end;
  end;
end;

end.
