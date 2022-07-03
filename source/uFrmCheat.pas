unit uFrmCheat;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.WinXPanels,

  uGameKyordai, uGameTownship, Vcl.Samples.Spin, Vcl.ComCtrls;

type
  TFrmCheat = class(TForm)
    PnlMainKyordai: TPanel;
    ImgKyordai: TImage;
    PnlTopKyordai: TPanel;
    LblMatch: TLabel;
    CardPanel: TCardPanel;
    CardKyordai: TCard;
    CardTownship: TCard;
    PnlTopTownship: TPanel;
    PnlTownshipMain: TPanel;
    GbRollerCoaster: TGroupBox;
    CheckKeyboard: TCheckBox;
    TimerWindow: TTimer;
    Label1: TLabel;
    BtnKill: TButton;
    BtnReset: TButton;
    Button1: TButton;
    Timer1: TTimer;
    Button2: TButton;
    Button3: TButton;
    GroupBox1: TGroupBox;
    BtnWheatStart: TButton;
    Timer2: TTimer;
    PageTownship: TPageControl;
    TabWheat: TTabSheet;
    TabSheet2: TTabSheet;
    EdtWheatLoop: TSpinEdit;
    Label3: TLabel;
    TabOther: TTabSheet;
    BtnWheatStop: TButton;
    ComCrops: TComboBox;
    Label2: TLabel;
    CheckCropsFast: TCheckBox;
    Label4: TLabel;
    ComCropsCount: TComboBox;
    Label5: TLabel;
    Label6: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure TimerWindowTimer(Sender: TObject);
    procedure BtnKillClick(Sender: TObject);
    procedure CheckKeyboardClick(Sender: TObject);
    procedure BtnResetClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure BtnWheatStartClick(Sender: TObject);
    procedure BtnWheatStopClick(Sender: TObject);
    procedure CheckCropsFastClick(Sender: TObject);
  private
    { Private declarations }
    FGameKyordai: TGameKyordai;
    FGameTownship: TGameTownship;

    mHotKey01, mHotKey02: Integer;
    procedure DoMatch(Sender: TObject; vBitmap: TBitmap; uMatch: Integer);
    procedure RegisterMyHotKey();
    procedure UnRegisterMyHotKey();
  protected
    procedure HotKeyDown(var Msg: Tmessage); message WM_HOTKEY;
  public
    { Public declarations }
  end;

var
  FrmCheat: TFrmCheat;

implementation

{$R *.dfm}

procedure TFrmCheat.BtnKillClick(Sender: TObject);
begin
  FGameTownship.Kill;
end;

procedure TFrmCheat.BtnResetClick(Sender: TObject);
begin
  FGameTownship.Reset;
end;

procedure TFrmCheat.BtnWheatStartClick(Sender: TObject);
var
  vParams: TInputParams;
begin
  SetLength(vParams, 2);
  vParams[0].key := '$0';
  vParams[1].key := '$1';
//  vParams[2].key := '$2';
//  vParams[1].value := '727';
  vParams[0].value := IntToStr(ComCrops.ItemIndex);
  if CheckCropsFast.Checked then
    vParams[1].value := '1'
  else
    vParams[1].value := '0';
//  case ComCrops.ItemIndex of
//    0:
//      begin
//        vParams[0].value := '410';
//        vParams[2].value := '300';
//      end;
//    1:
//      begin
//        vParams[0].value := '507';
//        vParams[2].value := '800';
//      end;
//    2:
//      begin
//        vParams[0].value := '595';
//        vParams[2].value := '1800';
//      end;
//    3:
//      begin
//        vParams[0].value := '688';
//        vParams[2].value := '2800';
//      end;
//    4:
//      begin
//        // 棉花
//        vParams[0].value := '773';
//        vParams[2].value := '3800';
//      end;
//  end;


  FGameTownship.PlayScript(EdtWheatLoop.Value, vParams);
end;

procedure TFrmCheat.BtnWheatStopClick(Sender: TObject);
begin
  FGameTownship.StopScript();
end;

var
  bmp: TBitmap;

procedure TFrmCheat.Button1Click(Sender: TObject);
var
  canvas: TCanvas;
  hDc, hWnd: THandle;
  vRect: TRect;
begin
  hWnd := GetDesktopWindow;
  hDc := GetDC(hWnd);
  canvas := TCanvas.Create;
  canvas.Handle := hDc;
  GetWindowRect(FGameTownship.GetGameHandle, vRect);
  if bmp = nil then
    bmp := TBitmap.Create;
  bmp.Canvas.FillRect(Rect(0, 0, bmp.Width, bmp.Height));
  bmp.Width := vRect.Width;
  bmp.Height := vRect.Height;
  // Rect(vRect.Left, vRect.Top, vRect.Width, vRect.Height)
  bmp.Canvas.CopyRect(Rect(0, 0, bmp.Width, bmp.Height), canvas, vRect);

  bmp.SaveToFile('c:\' + FormatDateTime('hhnnsszzz', now) + '.bmp');
  ReleaseDC(hWnd, hDc);
end;

procedure TFrmCheat.Button2Click(Sender: TObject);
begin
  FGameTownship.SheepRace := True;
end;

procedure TFrmCheat.Button3Click(Sender: TObject);
begin
  FGameTownship.SheepRace := False;
end;

procedure TFrmCheat.CheckCropsFastClick(Sender: TObject);
begin
  with Sender as TCheckBox do
  begin
    if Checked then
    begin
      ComCrops.Enabled := True;
    end else
    begin
      ComCrops.ItemIndex := 0;
      ComCrops.Enabled := False;
    end;
  end;
end;

procedure TFrmCheat.CheckKeyboardClick(Sender: TObject);
begin
  with Sender as TCheckBox do
  begin
    FGameTownship.Keyboard := Checked;
  end;
end;

procedure TFrmCheat.DoMatch(Sender: TObject; vBitmap: TBitmap; uMatch: Integer);
begin
  ImgKyordai.Picture.Bitmap := vBitmap;
  LblMatch.Caption := Format('Match = %d', [uMatch]);
end;

procedure TFrmCheat.FormCreate(Sender: TObject);
begin
  FGameKyordai := TGameKyordai.Create;
  FGameKyordai.OnMatch := DoMatch;
  // llk 436 599

  FGameTownship := TGameTownship.Create;

  PageTownship.ActivePageIndex := 0;
  CardPanel.ActiveCard := CardKyordai;

  RegisterMyHotKey;
end;

procedure TFrmCheat.FormDestroy(Sender: TObject);
begin
  FGameKyordai.Free;
  FGameTownship.Free;
  UnRegisterMyHotKey;
end;

procedure TFrmCheat.HotKeyDown(var Msg: Tmessage);
begin
  // 如果 热键值对上了
  if (Msg.LparamLo = MOD_CONTROL) and (Msg.LParamHi = VK_HOME) then
  begin
    // ShowMessage('Ctrl + HOME 调用成功');
    BtnWheatStart.Click;
  end;

  if (Msg.LparamLo = MOD_CONTROL) and (Msg.LParamHi = VK_END) then
  begin
    // ShowMessage('Ctrl + END 调用成功');
    BtnWheatStop.Click;
  end;
end;

procedure TFrmCheat.RegisterMyHotKey;
begin
  // 原子【mHotKey01】
  mHotKey01 := GlobalAddAtom('xiaoyin_HotKey_CTRL_HOME') - $C000;
  //注册热键【Ctrl + F1】
  RegisterHotKey(Handle, mHotKey01, MOD_CONTROL, VK_HOME);
  // 原子【mHotKey02】
  mHotKey02 := GlobalAddAtom('xiaoyin_HotKey_CTRL_END') - $C000;
  //注册热键【Ctrl + Shift + F1】
  RegisterHotKey(Handle, mHotKey02, MOD_CONTROL, VK_END);
  // 如有更多需求，以此类推即可
end;

procedure TFrmCheat.Timer1Timer(Sender: TObject);
begin
  Button1.Click;
end;

procedure TFrmCheat.Timer2Timer(Sender: TObject);
var
  vRect: TRect;
  vPt: TPoint;
begin
  GetWindowRect(FGameTownship.GetGameHandle, vRect);
  GetCursorPos(vPt);
  Label6.Caption := Format('x=%d, y=%d, rect(%d,%d,%d,%d)', [vPt.X - vRect.Left, vPt.Y - vRect.Top, vRect.Left, vRect.Top, vRect.Right, vRect.Bottom]);
end;

procedure TFrmCheat.TimerWindowTimer(Sender: TObject);
var
  hWnd, hKyordai, hTownship: THandle;
begin
  hKyordai := FGameKyordai.GetGameHandle;
  hTownship := FGameTownship.GetGameHandle;

  if (hKyordai = 0) and (hTownship = 0) then
  begin
    Exit;
  end;
  if (hKyordai > 0) and (hTownship > 0) then
  begin
    hWnd := GetForegroundWindow;
    if hWnd = hKyordai then
    begin
      CardPanel.ActiveCard := CardKyordai;
      Self.ClientHeight := 436;
      self.ClientWidth := 599;
    end;
    if hWnd = hTownship then
    begin
      CardPanel.ActiveCard := CardTownship;
      Self.ClientHeight := 200;
      self.ClientWidth := 320;
    end;
  end else
  begin
    if hKyordai > 0 then
    begin
      CardPanel.ActiveCard := CardKyordai;
      Self.ClientHeight := 436;
      self.ClientWidth := 599;
    end else
    begin
      CardPanel.ActiveCard := CardTownship;
      Self.ClientHeight := 200;
      self.ClientWidth := 320;
    end;
  end;

end;

procedure TFrmCheat.UnRegisterMyHotKey;
begin
  // 释放热键【Ctrl + F1】
  UnRegisterHotKey(handle, mHotKey01);
  // 删除原子【mHotKey01】
  GlobalDeleteAtom(mHotKey01);
  // 释放热键【Ctrl + Shift + F1】
  UnRegisterHotKey(handle, mHotKey02);
  // 删除原子【mHotKey02】
  GlobalDeleteAtom(mHotKey02);
end;

end.
