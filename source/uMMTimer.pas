unit uMMTimer;

interface

uses
  SysUtils, Classes, Types, Windows, MMSystem;

type
  TMMTimer = class(TObject)
  private
    FInterval: Cardinal;                // 定时器的间隔时间，单位为毫秒，默认为1000毫秒
    FEnabled: Boolean;                  // 定时器是否在运行，默认为FALSE
    FProcTimeCallback: TFnTimeCallback; // 回调函数指针
    FOnTimeProc: TNotifyEvent;          // 周期回调时触发的定时器事件
    FHTimerID: Integer;                 // 定时器ID，停止定时器使用
    FLastTime: Cardinal;
    procedure SetInterval(const Value: Cardinal);
    procedure SetEnabled(const Value: Boolean);
  public
    constructor Create;
    destructor Destroy; override;

    property Enabled: Boolean read FEnabled write SetEnabled default FALSE;
    property Interval: Cardinal read FInterval write SetInterval default 1000;
    property LastTime: Cardinal read FLastTime write FLastTime;
    property OnTimer: TNotifyEvent read FOnTimeProc write FOnTimeProc;
  end;

implementation

procedure DoTimer(uTimerID, uMessage: UINT; dwUser, dw1, dw2: DWORD_PTR) stdcall;
var
  obj : TMMTimer;
begin
  obj := TMMTimer(dwUser);  //dwUser实际上是定时器对象的地址
  if (GetTickCount - obj.LastTime + 10) >= obj.Interval then
    if Assigned(obj.OnTimer)then
    begin
      obj.OnTimer(obj);
      obj.LastTime := GetTickCount;
    end;
end;

{ TMMTimer }

constructor TMMTimer.Create;
begin
  inherited;
  FInterval := 1000;  // 默认为1秒
  FEnabled := False;  // 创建并不启动定时器
  FOnTimeProc := nil;
  FLastTime := 0;
  // 对象中的函数指针只有一个，需要考虑利用dwUser来区分不同的对象函数回调
  FProcTimeCallback := DoTimer;
end;

destructor TMMTimer.Destroy;
begin
  Enabled := False;
  inherited;
end;

procedure TMMTimer.SetEnabled(const Value: Boolean);
begin
  if Value = FEnabled then
    Exit;
  FEnabled := Value;
  if FEnabled then
  begin
    FHTimerID := TimeSetEvent(FInterval, 0, FProcTimeCallback, Integer(Self), 1 ); // 这里把对象地址传入，回调时传回，最后一个参数表示周期回调，第二个参数0为最高精度
  end else
  begin
    TimeKillEvent( FHTimerID );
  end;
end;

procedure TMMTimer.SetInterval(const Value: Cardinal);
begin
  if FInterval <> Value then
  begin
    FInterval := Value;
    if FEnabled then
    begin
      // 如果定时器已经启动并更改周期时长则需要先停止再重新启动定时器
      Enabled := False;
      Enabled := True;
    end;
  end;
end;

end.

