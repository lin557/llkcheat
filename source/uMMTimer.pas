unit uMMTimer;

interface

uses
  SysUtils, Classes, Types, Windows, MMSystem;

type
  TMMTimer = class(TObject)
  private
    FInterval: Cardinal;                // ��ʱ���ļ��ʱ�䣬��λΪ���룬Ĭ��Ϊ1000����
    FEnabled: Boolean;                  // ��ʱ���Ƿ������У�Ĭ��ΪFALSE
    FProcTimeCallback: TFnTimeCallback; // �ص�����ָ��
    FOnTimeProc: TNotifyEvent;          // ���ڻص�ʱ�����Ķ�ʱ���¼�
    FHTimerID: Integer;                 // ��ʱ��ID��ֹͣ��ʱ��ʹ��
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
  obj := TMMTimer(dwUser);  //dwUserʵ�����Ƕ�ʱ������ĵ�ַ
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
  FInterval := 1000;  // Ĭ��Ϊ1��
  FEnabled := False;  // ��������������ʱ��
  FOnTimeProc := nil;
  FLastTime := 0;
  // �����еĺ���ָ��ֻ��һ������Ҫ��������dwUser�����ֲ�ͬ�Ķ������ص�
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
    FHTimerID := TimeSetEvent(FInterval, 0, FProcTimeCallback, Integer(Self), 1 ); // ����Ѷ����ַ���룬�ص�ʱ���أ����һ��������ʾ���ڻص����ڶ�������0Ϊ��߾���
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
      // �����ʱ���Ѿ���������������ʱ������Ҫ��ֹͣ������������ʱ��
      Enabled := False;
      Enabled := True;
    end;
  end;
end;

end.

