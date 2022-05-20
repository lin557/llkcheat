object FrmLlk: TFrmLlk
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'LLK'
  ClientHeight = 439
  ClientWidth = 599
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = #23435#20307
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object PnlMain: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 47
    Width = 593
    Height = 389
    Align = alClient
    BevelKind = bkFlat
    BevelOuter = bvNone
    TabOrder = 0
    object Image1: TImage
      Left = 0
      Top = 0
      Width = 589
      Height = 385
      Align = alClient
      ExplicitLeft = 8
      ExplicitTop = 240
      ExplicitWidth = 105
      ExplicitHeight = 105
    end
  end
  object PnlTop: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 593
    Height = 38
    Align = alTop
    BevelKind = bkFlat
    BevelOuter = bvNone
    TabOrder = 1
    object LblMatch: TLabel
      Left = 89
      Top = 9
      Width = 87
      Height = 18
      Caption = 'Match = 0'
      Font.Charset = ANSI_CHARSET
      Font.Color = clRed
      Font.Height = -16
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object BtnPlay: TButton
      Left = 8
      Top = 5
      Width = 75
      Height = 25
      Caption = #24320#22987
      TabOrder = 0
      OnClick = BtnPlayClick
    end
    object BtnSnap: TButton
      Left = 507
      Top = 5
      Width = 75
      Height = 25
      Caption = #25235#22270
      TabOrder = 1
      OnClick = BtnSnapClick
    end
  end
  object TimerMatch: TTimer
    Interval = 50
    OnTimer = TimerMatchTimer
    Left = 131
    Top = 215
  end
  object TimerCheckGame: TTimer
    Interval = 300
    OnTimer = TimerCheckGameTimer
    Left = 235
    Top = 215
  end
end
