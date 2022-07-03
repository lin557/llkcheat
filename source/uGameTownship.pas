{ QQ梦想城镇 }
unit uGameTownship;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, Vcl.ExtCtrls, Vcl.Graphics,
  uIOCPTimer, uScriptEngine;

type
  TInputParams = uScriptEngine.TInputParams;

  TGameTownship = class(TObject)
  private
    FTimer: TTimer;
    FTimerSheep: TIOCPTimer;
    FKeyboard: Boolean;
    FStepId: Integer;
    FCanvas: TCanvas;
    FBitmap: TBitmap;
    FDc: THandle;
    FGameHandle: THandle;
    FSheepRace: Boolean;
    FSheepTimeout: Cardinal;
    FSheepTimeOver: Cardinal;
    FScript: TScriptEngine;

    procedure SetHook;
    procedure UnHook;


    procedure DoTimer(Sender: TObject);
    procedure DoTimerSheep(Sender: TObject);

    function CheckSheepArraw(): Integer;
    function CompareColor(vBmp: TBitmap; r, g, b: Byte): Integer;
    procedure SetSheepRace(const Value: Boolean);
  public
    constructor Create();
    destructor Destroy; override;

    function GetGameHandle: THandle;

    procedure PlayScript(uLoop: Integer; vParams: TInputParams);
    procedure StopScript();

    procedure Kill;
    procedure Reset;
    property Keyboard: Boolean read FKeyboard write FKeyboard default False;
    property SheepRace: Boolean read FSheepRace write SetSheepRace;

  end;

implementation

{ TGameTownship }


const
  PLAY_BUTTON_LEFT = 630;
  PLAY_BUTTON_TOP = 520;

var
  _Hook: Cardinal = 0;
  _Self: TGameTownship;
  _Left: Integer = 616;
  _Top: Integer = 445;

// 回调过程
function HookProc(code: Integer; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall;

const
  _KeyUp = $80000000; // 键盘弹起
  _KeyDown = $00000000; // 键盘按下

var
  hWnd: THandle;
  vRect: TRect;
  uLeft: Integer;
begin
  //如果有键盘动作
  if _Self.FKeyboard and (code = HC_ACTION) then
  begin
    //如果CallHandle，则查找TestMain窗体句柄
    hWnd := _Self.FGameHandle;
    //获取按键状态 小于0表示按下，如果不做判断，按键按下或抬起都会执行SendMessage
    if (hWnd > 0) and ((lParam and _KeyUp) = _KeyUp) then
    begin
      uLeft := 100;
      case wParam of
        VK_UP:
          begin
            GetWindowRect(hWnd, vRect);
            SetCursorPos(vRect.Left + uLeft, vRect.Top + 230);
            mouse_event(MOUSEEVENTF_LEFTDOWN, 0, 0, 0, 0);
            SetCursorPos(vRect.Left + uLeft, vRect.Top + 200);
            //mouse_event(MOUSEEVENTF_MOVE, 0, 100, 0, 0);
            mouse_event(MOUSEEVENTF_LEFTUP, 0, 0, 0, 0);
          end;
        VK_DOWN:
          begin
            GetWindowRect(hWnd, vRect);
            SetCursorPos(vRect.Left + uLeft, vRect.Top + 200);
            mouse_event(MOUSEEVENTF_LEFTDOWN, 0, 0, 0, 0);
            SetCursorPos(vRect.Left + uLeft, vRect.Top + 230);
            //mouse_event(MOUSEEVENTF_MOVE, 0, 100, 0, 0);
            mouse_event(MOUSEEVENTF_LEFTUP, 0, 0, 0, 0);
          end;
      end;
    end;
  end;
  Result := CallNextHookEx(_Hook, code,wParam,lParam);
end;

function TGameTownship.CheckSheepArraw: Integer;
begin
  FBitmap.Canvas.CopyRect(Rect(0, 0, FBitmap.Width, FBitmap.Height), FCanvas, Rect(625, 398, 625 + FBitmap.Width, 398 + FBitmap.Height));
  //FBitmap.SaveToFile('c:/' + FormatDateTime('hhnnsszzz-', now) + '0-.bmp');
  //ms := TMemoryStream.Create;
  //FBitmap.SaveToStream(ms);
  //FList.Add(ms);
  Result := CompareColor(FBitmap, 100, 187, 72);
end;

function TGameTownship.CompareColor(vBmp: TBitmap; r, g, b: Byte): Integer;

  function RgbToColor(R,G,B: byte): Tcolor;
  begin
    Result := B Shl 16 or G  shl 8 or R;
  end;

  function GetB(c: TColor): Integer;
  begin
    Result := (c and $FF0000) shr 16;
  end;

  function GetG(c: TColor): Integer;
  begin
    Result := (c and $00FF00) shr 8;
  end;

  function GetR(c: TColor): Integer;
  begin
    Result := c and $0000FF;
  end;

var
  x, y, c: Integer;
  uCur: TColor;
begin
  c := 0;
  for y := 0 to vBmp.Height - 1 do
  begin
    for x := 0 to vBmp.Width - 1 do
    begin
      uCur := vBmp.Canvas.Pixels[x, y];
      if (Abs(GetB(uCur) - b) < 22) and (Abs(GetG(uCur) - g) < 50) and (Abs(GetR(uCur) - r) < 40) then
      begin
        Inc(c);
        if c > 10 then
        begin
          Result := c;
          Exit;
        end;
      end;
    end;
  end;
  Result := c;
end ;

constructor TGameTownship.Create();
begin
  inherited;
  FCanvas := TCanvas.Create;
  FBitmap := TBitmap.Create;
  FBitmap.Width := 108;
  FBitmap.Height := 52;

  FTimer := TTimer.Create(nil);
  FTimer.Interval := 655;
  FTimer.Enabled := True;
  FTimer.OnTimer := DoTimer;

  FTimerSheep := TIOCPTimer.Create();
  FTimerSheep.Interval := 5;
  FTimerSheep.Enabled := False;
  FTimerSheep.OnTimer := DoTimerSheep;

  FScript := TScriptEngine.Create;

  FKeyboard := False;
  _Self := Self;
  FDc := 0;
end;

destructor TGameTownship.Destroy;
begin
  FTimer.Free;
  FTimerSheep.Free;
  FScript.Free;
  UnHook;
  FCanvas.Free;
  FBitmap.Free;
  inherited;
end;

procedure TGameTownship.DoTimer(Sender: TObject);
begin
  if _Hook = 0 then
  begin
    UnHook;
    SetHook;
  end;
end;

var
  lt: Int64 = 0;

procedure TGameTownship.DoTimerSheep(Sender: TObject);
var
  vRect: TRect;
  c: Integer;
  t1, cc: Int64;
  uCur: Cardinal;
begin
  if (_Hook > 0) and (FDc > 0) then
  begin
    //CheckSheepArraw();
    QueryPerformanceCounter(t1);
    if lt = 0 then
    begin
      cc := 0;
    end else
    begin
      cc := t1 - lt;
    end;
    lt := t1;
    OutputDebugString(PChar(IntToStr(FStepId)));

    uCur := GetTickCount;
    case FStepId of
      10:
        begin
          // 点"玩"开始
          GetWindowRect(FGameHandle, vRect);
          SetCursorPos(vRect.Left + PLAY_BUTTON_LEFT, vRect.Top + PLAY_BUTTON_TOP);
          mouse_event(MOUSEEVENTF_LEFTDOWN, 0, 0, 0, 0);
          mouse_event(MOUSEEVENTF_LEFTUP, 0, 0, 0, 0);
          FStepId := 11;
          FSheepTimeout := uCur;
        end;
      11:
        begin
          // 等3秒
          if uCur - FSheepTimeout > 3000 then
          begin
            FSheepTimeout := 0;
            FStepId := 12;
          end;
        end;
      12:
        begin
          // 屏幕点一下开始游戏
          FSheepTimeout := uCur;
          GetWindowRect(FGameHandle, vRect);
          SetCursorPos(vRect.Left + 100, vRect.Top + 230);
          mouse_event(MOUSEEVENTF_LEFTDOWN, 0, 0, 0, 0);
          mouse_event(MOUSEEVENTF_LEFTUP, 0, 0, 0, 0);
          FStepId := 20;
        end;
      20:
        begin
          // 40ms查一次
          if uCur - FSheepTimeout < 40 then
            Exit;
          FSheepTimeout := uCur;
          c := CheckSheepArraw();
          if c > 3 then
          begin
            FStepId := 21;
          end;
        end;
      21:
        begin
          // 第一个 等 250
          if uCur - FSheepTimeout < 250 then
            Exit;
          FSheepTimeout := uCur;
          FSheepTimeOver := uCur;
          GetWindowRect(FGameHandle, vRect);
          SetCursorPos(vRect.Left + 100, vRect.Top + 230);
          mouse_event(MOUSEEVENTF_LEFTDOWN, 0, 0, 0, 0);
          mouse_event(MOUSEEVENTF_LEFTUP, 0, 0, 0, 0);
          FStepId := 22;
        end;
      22:
        begin
          // 等 250 防重复点
          if uCur - FSheepTimeout < 220 then
            Exit;
          FSheepTimeout := uCur;
          FStepId := 23;
        end;
      23:
        begin
          // 第二个 - 第n个
          if uCur - FSheepTimeout < 30 then
            Exit;
          FSheepTimeout := uCur;
          c := CheckSheepArraw();
          if c > 3 then
          begin
            FStepId := 24;
            FSheepTimeOver := uCur;
          end;

          if uCur - FSheepTimeOver > 6000 then
          begin
            FStepId := 30;
          end;
        end;
      24:
        begin
          // 第二个开始 只需要 50
          if uCur - FSheepTimeout < 60 then
            Exit;
          FSheepTimeout := uCur;
          GetWindowRect(FGameHandle, vRect);
          SetCursorPos(vRect.Left + 100, vRect.Top + 230);
          mouse_event(MOUSEEVENTF_LEFTDOWN, 0, 0, 0, 0);
          mouse_event(MOUSEEVENTF_LEFTUP, 0, 0, 0, 0);
          FStepId := 22;
        end;
      30:
        begin
          // 等星星数完点下点 重新开始
          GetWindowRect(FGameHandle, vRect);
          SetCursorPos(vRect.Left + 330, vRect.Top + 350);
          mouse_event(MOUSEEVENTF_LEFTDOWN, 0, 0, 0, 0);
          mouse_event(MOUSEEVENTF_LEFTUP, 0, 0, 0, 0);
          FStepId := 31;
          FSheepTimeout := uCur;
        end;
      31:
        begin
          // 等5秒  有时出现奖励要多点时间
          if uCur - FSheepTimeout > 4000 then
          begin
            FStepId := 32;
            FSheepTimeout := uCur;
          end;
        end;
      32:
        begin
          if uCur - FSheepTimeout > 1000 then
          begin
            GetWindowRect(FGameHandle, vRect);
            SetCursorPos(vRect.Left + PLAY_BUTTON_LEFT - 50, vRect.Top + PLAY_BUTTON_TOP - 100);
            mouse_event(MOUSEEVENTF_LEFTDOWN, 0, 0, 0, 0);
            mouse_event(MOUSEEVENTF_LEFTUP, 0, 0, 0, 0);
            FStepId := 33;
            FSheepTimeout := uCur;
          end;
        end;
      33:
        begin
          if uCur - FSheepTimeout > 1000 then
          begin
            GetWindowRect(FGameHandle, vRect);
            SetCursorPos(vRect.Left + PLAY_BUTTON_LEFT - 50, vRect.Top + PLAY_BUTTON_TOP - 100);
            mouse_event(MOUSEEVENTF_LEFTDOWN, 0, 0, 0, 0);
            mouse_event(MOUSEEVENTF_LEFTUP, 0, 0, 0, 0);
            FStepId := 34;
            FSheepTimeout := uCur;
          end;
        end;
      34:
        begin
          if uCur - FSheepTimeout > 1000 then
          begin
            GetWindowRect(FGameHandle, vRect);
            SetCursorPos(vRect.Left + PLAY_BUTTON_LEFT - 50, vRect.Top + PLAY_BUTTON_TOP - 100);
            mouse_event(MOUSEEVENTF_LEFTDOWN, 0, 0, 0, 0);
            mouse_event(MOUSEEVENTF_LEFTUP, 0, 0, 0, 0);
            FStepId := 35;
            FSheepTimeout := uCur;
          end;
        end;
      35:
        begin
          if uCur - FSheepTimeout > 1000 then
          begin
            GetWindowRect(FGameHandle, vRect);
            SetCursorPos(vRect.Left + PLAY_BUTTON_LEFT - 50, vRect.Top + PLAY_BUTTON_TOP - 100);
            mouse_event(MOUSEEVENTF_LEFTDOWN, 0, 0, 0, 0);
            mouse_event(MOUSEEVENTF_LEFTUP, 0, 0, 0, 0);
            FStepId := 36;
            FSheepTimeout := uCur;
          end;
        end;
      36:
        begin
          if uCur - FSheepTimeout > 1000 then
          begin
            GetWindowRect(FGameHandle, vRect);
            SetCursorPos(vRect.Left + PLAY_BUTTON_LEFT - 50, vRect.Top + PLAY_BUTTON_TOP - 100);
            mouse_event(MOUSEEVENTF_LEFTDOWN, 0, 0, 0, 0);
            mouse_event(MOUSEEVENTF_LEFTUP, 0, 0, 0, 0);
            FStepId := 37;
            FSheepTimeout := uCur;
          end;
        end;
      37:
        begin
          if uCur - FSheepTimeout > 1000 then
          begin
            FStepId := 10;
            FSheepTimeout := uCur;
          end;
        end;
    end;


    //FBitmap.SaveToFile('c:\' + FormatDateTime('hhnnsszzz-', now) + IntToStr(c) + '.bmp');
  end;
end;


function TGameTownship.GetGameHandle: THandle;
begin
  Result := FindWindow('MainWindow', '梦想城镇');
end;

procedure TGameTownship.Kill;
var
  hWnd: THandle;
  pid, KillHandle: Cardinal;
begin
  UnHook;
  // 必须先获得关闭进程的权限
  hWnd := GetGameHandle;
  GetWindowThreadProcessId(hWnd, pid);
  KillHandle := OpenProcess(PROCESS_TERMINATE, False, pid);
  //强制关闭进程
  TerminateProcess(KillHandle, 0);
  CloseHandle(KillHandle);
end;

procedure TGameTownship.PlayScript(uLoop: Integer; vParams: TInputParams);
begin
  FScript.GameHandle := FGameHandle;
  FScript.Play(uLoop, vParams);
end;

procedure TGameTownship.Reset;
begin
  UnHook;
  SetHook;
end;

procedure TGameTownship.SetHook;
var
  pid, tid: Cardinal;
begin
  // 挂钩
  FGameHandle := GetGameHandle;
  tid := GetWindowThreadProcessId(FGameHandle, pid);
  _Hook := SetWindowsHookEx(WH_KEYBOARD, @HookProc, LoadLibrary('user32.dll'), tid);

  FDc := GetDC(FGameHandle);
  FCanvas.Handle := FDc;
end;

procedure TGameTownship.SetSheepRace(const Value: Boolean);
begin
  FSheepRace := Value;
  FTimerSheep.Enabled := Value;
  FStepId := 10;
end;

procedure TGameTownship.StopScript;
begin
  FScript.Stop;
end;

procedure TGameTownship.UnHook;
begin
  ReleaseDC(FGameHandle, FDc);
  FDc := 0;
  // 摘钩
  if _Hook <> 0 then
  begin
    UnhookWindowsHookEx(_Hook);
    _Hook := 0;
  end;
end;

end.
