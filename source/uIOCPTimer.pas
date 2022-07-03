unit uIOCPTimer;

interface

uses
  Windows, Classes, System.SysUtils;

type
  // 回收线程
  TIOCPTimer = class(TThread)
  private
    FOnTimer: TNotifyEvent;
    FEnabled: Boolean;
    FInterval: Cardinal;

    procedure DoTimer;
  protected
    procedure Execute; override;
  public
    constructor Create;
    destructor Destroy; override;

    property Enabled: Boolean read FEnabled write FEnabled default True;
    property Interval: Cardinal read FInterval write FInterval default 1000; 
    property OnTimer: TNotifyEvent read FOnTimer write FOnTimer;
  end;

implementation

{ TIOCPTimer }

constructor TIOCPTimer.Create;
begin
  inherited Create(True);
  Priority := tpNormal;
  FOnTimer := nil;
  FEnabled := True;
  FInterval := 1000;
  Resume;
end;

destructor TIOCPTimer.Destroy;
begin
  Terminate;
  WaitForSingleObject(Handle, 5000);
  inherited;
end;

procedure TIOCPTimer.DoTimer;
begin
  if Assigned(FOnTimer) then
    FOnTimer(Self);
end;

procedure TIOCPTimer.Execute;
var
  uCur, uLast: Int64;
begin
  inherited;
  uLast := 0;
  while not Terminated do
  begin
    QueryPerformanceCounter(uCur);
    WaitForSingleObject(Handle, 1);
   
//    MsgWaitForMultipleObjects(0, pHandle, False, 1, QS_ALLINPUT);
//    MsgWaitForMultipleObjectsEx(0, pHandle, FInterval, QS_TIMER,
//									MWMO_WAITALL);
    if FEnabled then
    begin
      if uCur - uLast >= FInterval * 10000 then
      begin
        DoTimer;
      end;
    end;
  end;
end;

end.
