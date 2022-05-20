unit uGame;

interface

uses
  Winapi.Windows, System.Classes, system.SysUtils;

const
  LLK_MAIN_WIDTH = 589;
  LLK_MAIN_HEIGHT = 385;
  LLK_MAIN_LEFT = 14;
  LLK_MAIN_TOP = 181;

  LLK_TILE_ROW = 11;
  LLK_TILE_COL = 19;
  LLK_TILE_WIDTH = 31;
  LLK_TILE_HEIGHT = 35;

//  // 开始标识
//  LLK_FLAG_START = 19432;
//
//  // 空白
//  LLK_TILE_00 = 39984;
//
//  // 红球
//  LLK_TILE_01 = 17192;
//  // 粉球
//  LLK_TILE_02 = 71192;
//  // 黑球
//  LLK_TILE_03 = 38640;
//  // 黄球
//  LLK_TILE_04 = 15184;
//  // 绿球
//  LLK_TILE_05 = 12408;
//  // 白球
//  LLK_TILE_06 = 66360;
//  // 蓝球
//  LLK_TILE_07 = 79576;
//
//  // 蓝方块
//  LLK_TILE_08 = 68392;
//  // 绿方块
//  LLK_TILE_09 = 34656;
//  // 天蓝方块
//  LLK_TILE_10 = 61984;
//  // 浅绿方块
//  LLK_TILE_11 = 41056;
//  // 棕方块
//  LLK_TILE_12 = 45736;
//  // 粉方块
//  LLK_TILE_13 = 63704;
//
//  // 石头
//  LLK_TILE_14 = 71176;
//  // 剪刀
//  LLK_TILE_15 = 66776;
//  // 布
//  LLK_TILE_16 = 69096;
//
//  // QQ男
//  LLK_TILE_17 = 26416;
//  // QQ女
//  LLK_TILE_18 = 40904;
//
//  // 鲨鱼
//  LLK_TILE_19 = 65600;
//  // 章鱼
//  LLK_TILE_20 = 55072;
//  // 鸡
//  LLK_TILE_21 = 58448;
//  // 羊
//  LLK_TILE_22 = 35856;
//
//  // 南瓜
//  LLK_TILE_23 = 29728;
//  // 星星
//  LLK_TILE_24 = 24288;
//
//  // 表情眼镜
//  LLK_TILE_25 = 11104;
//  // 表情哭
//  LLK_TILE_26 = 17848;
//  // 表情色
//  LLK_TILE_27 = 14768;
//  // 表情汗
//  LLK_TILE_28 = 18928;
//  // 表情惊
//  LLK_TILE_29 = 46768;
//
//  // 色子
//  LLK_TILE_30 = 69696;
//  // 手机
//  LLK_TILE_31 = 30904;
//  // 雷达
//  LLK_TILE_32 = 72496;
//  // 放大镜
//  LLK_TILE_33 = 42488;
//  // 黑桃
//  LLK_TILE_34 = 22296;
//  // 手柄
//  LLK_TILE_35 = 70536;
//  // 钻石
//  LLK_TILE_36 = 58784;
//
//  // 指南针
//  LLK_TILE_37 = 45512;
//  // 禁手
//  LLK_TILE_38 = 38640;
//  // 重列
//  LLK_TILE_39 = 1208;
//  // 镜子
//  LLK_TILE_40 = 3648;
//  // 炸弹
//  LLK_TILE_41 = 15304;
//  // 障碍
//  LLK_TILE_42 = 4072;
//  // 闹钟
//  LLK_TILE_43 = 30344;
//  // 蒙眼
//  LLK_TILE_44 = 31104;


  LLK_FLAG_START = 8740;
  LLK_TILE_00 = 8496;
  LLK_TILE_01 = 8348;
  LLK_TILE_02 = 15600;
  LLK_TILE_03 = 5312;
  LLK_TILE_04 = 15992;
  LLK_TILE_05 = 7636;
  LLK_TILE_06 = 16204;
  LLK_TILE_07 = 12736;
  LLK_TILE_08 = 15128;
  LLK_TILE_09 = 11368;
  LLK_TILE_10 = 18216;
  LLK_TILE_11 = 17840;
  LLK_TILE_12 = 12176;
  LLK_TILE_13 = 16432;
  LLK_TILE_14 = 15556;
  LLK_TILE_15 = 15856;
  LLK_TILE_16 = 18740;
  LLK_TILE_17 = 2884;
  LLK_TILE_18 = 10280;
  LLK_TILE_19 = 17036;
  LLK_TILE_20 = 18492;
  LLK_TILE_21 = 14984;
  LLK_TILE_22 = 17688;
  LLK_TILE_23 = 13168;
  LLK_TILE_24 = 14404;
  LLK_TILE_25 = 12268;
  LLK_TILE_26 = 19324;
  LLK_TILE_27 = 12520;
  LLK_TILE_28 = 17684;
  LLK_TILE_29 = 16132;
  LLK_TILE_30 = 21344;
  LLK_TILE_31 = 12924;
  LLK_TILE_32 = 14488;
  LLK_TILE_33 = 16168;
  LLK_TILE_34 = 0;
  LLK_TILE_35 = 18788;
  LLK_TILE_36 = 19740;
  LLK_TILE_37 = 12692;
  LLK_TILE_38 = 18720;
  LLK_TILE_39 = 14544;
  LLK_TILE_40 = 11136;
  LLK_TILE_41 = 6008;
  LLK_TILE_42 = 10320;
  LLK_TILE_43 = 20492;
  LLK_TILE_44 = 15400;



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

end.
