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

// �ص�����
function HookProc(code: Integer; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall;

const
  _KeyUp = $80000000; // ���̵���
  _KeyDown = $00000000; // ���̰���

var
  hWnd: THandle;
  vRect: TRect;
  uLeft: Integer;
begin
  //����м��̶���
  //if _Self.FKeyboard and (code = HC_ACTION) then
//  begin
//    //���CallHandle�������TestMain������
//    hWnd := _Self.FGameHandle;
//    //��ȡ����״̬ С��0��ʾ���£���������жϣ��������»�̧�𶼻�ִ��SendMessage
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
