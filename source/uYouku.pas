unit uYouku;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes;

type
  TYouku = class(TObject)
  private
  public
    constructor Create();
    destructor Destroy; override;
  end;

implementation

{ TYouku }

var
  _Hook: THandle;

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
  //if _Self.FKeyboard and (code = HC_ACTION) then
//  begin
//    //如果CallHandle，则查找TestMain窗体句柄
//    hWnd := _Self.FGameHandle;
//    //获取按键状态 小于0表示按下，如果不做判断，按键按下或抬起都会执行SendMessage
//    if (hWnd > 0) and ((lParam and _KeyUp) = _KeyUp) then
//    begin
//      uLeft := 100;
//      case wParam of
//        VK_UP:
//          begin
//            GetWindowRect(hWnd, vRect);
//            SetCursorPos(vRect.Left + uLeft, vRect.Top + 230);
//            mouse_event(MOUSEEVENTF_LEFTDOWN, 0, 0, 0, 0);
//            SetCursorPos(vRect.Left + uLeft, vRect.Top + 200);
//            //mouse_event(MOUSEEVENTF_MOVE, 0, 100, 0, 0);
//            mouse_event(MOUSEEVENTF_LEFTUP, 0, 0, 0, 0);
//          end;
//        VK_DOWN:
//          begin
//            GetWindowRect(hWnd, vRect);
//            SetCursorPos(vRect.Left + uLeft, vRect.Top + 200);
//            mouse_event(MOUSEEVENTF_LEFTDOWN, 0, 0, 0, 0);
//            SetCursorPos(vRect.Left + uLeft, vRect.Top + 230);
//            //mouse_event(MOUSEEVENTF_MOVE, 0, 100, 0, 0);
//            mouse_event(MOUSEEVENTF_LEFTUP, 0, 0, 0, 0);
//          end;
//      end;
//    end;
//  end;
  Result := CallNextHookEx(_Hook, code,wParam,lParam);
end;

constructor TYouku.Create;
begin
  _Hook := SetWindowsHookEx(WH_GETMESSAGE, @HookProc, LoadLibrary('user32.dll'), 0);
  OutputDebugString(PChar(IntToStr(_Hook)));
end;

destructor TYouku.Destroy;
begin

  inherited;
end;

end.
