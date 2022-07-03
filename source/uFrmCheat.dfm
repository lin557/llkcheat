object FrmCheat: TFrmCheat
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'QQ Game Cheat'
  ClientHeight = 436
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
  object CardPanel: TCardPanel
    Left = 0
    Top = 0
    Width = 599
    Height = 436
    Align = alClient
    ActiveCard = CardTownship
    BevelOuter = bvNone
    Caption = 'CardPanel'
    TabOrder = 0
    object CardKyordai: TCard
      Left = 0
      Top = 0
      Width = 599
      Height = 436
      Caption = #36830#36830#30475
      CardIndex = 0
      TabOrder = 0
      object PnlTopKyordai: TPanel
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 593
        Height = 35
        Align = alTop
        BevelKind = bkFlat
        BevelOuter = bvNone
        TabOrder = 0
        object LblMatch: TLabel
          Left = 0
          Top = 0
          Width = 589
          Height = 31
          Align = alClient
          Alignment = taCenter
          Caption = 'Match = 0'
          Font.Charset = ANSI_CHARSET
          Font.Color = clRed
          Font.Height = -16
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
          Layout = tlCenter
          ExplicitWidth = 87
          ExplicitHeight = 18
        end
      end
      object PnlMainKyordai: TPanel
        AlignWithMargins = True
        Left = 3
        Top = 44
        Width = 593
        Height = 389
        Align = alClient
        BevelKind = bkFlat
        BevelOuter = bvNone
        TabOrder = 1
        object ImgKyordai: TImage
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
    end
    object CardTownship: TCard
      Left = 0
      Top = 0
      Width = 599
      Height = 436
      Caption = #26790#24819#22478#38215
      CardIndex = 1
      TabOrder = 1
      object PnlTopTownship: TPanel
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 593
        Height = 35
        Align = alTop
        BevelKind = bkFlat
        BevelOuter = bvNone
        TabOrder = 0
        DesignSize = (
          589
          31)
        object Label1: TLabel
          Left = 0
          Top = 0
          Width = 589
          Height = 31
          Align = alClient
          Alignment = taCenter
          Caption = #26790#24819#22478#38215
          Font.Charset = ANSI_CHARSET
          Font.Color = clRed
          Font.Height = -16
          Font.Name = #23435#20307
          Font.Style = []
          ParentFont = False
          Layout = tlCenter
          ExplicitWidth = 64
          ExplicitHeight = 16
        end
        object BtnKill: TButton
          Left = 510
          Top = 4
          Width = 75
          Height = 25
          Anchors = [akTop, akRight]
          Caption = #24378#36864
          TabOrder = 0
          OnClick = BtnKillClick
        end
        object BtnReset: TButton
          Left = 5
          Top = 4
          Width = 75
          Height = 25
          Caption = #37325#32622
          TabOrder = 1
          OnClick = BtnResetClick
        end
      end
      object PnlTownshipMain: TPanel
        AlignWithMargins = True
        Left = 3
        Top = 44
        Width = 593
        Height = 389
        Align = alClient
        BevelKind = bkFlat
        BevelOuter = bvNone
        TabOrder = 1
      end
      object PageTownship: TPageControl
        AlignWithMargins = True
        Left = 3
        Top = 44
        Width = 593
        Height = 389
        ActivePage = TabWheat
        Align = alClient
        TabOrder = 2
        object TabWheat: TTabSheet
          Caption = #23567#40614
          object Label3: TLabel
            Left = 10
            Top = 33
            Width = 59
            Height = 13
            Caption = #24490#29615#27425#25968':'
          end
          object Label2: TLabel
            Left = 10
            Top = 63
            Width = 59
            Height = 13
            Caption = #20316#29289#36873#25321':'
          end
          object Label4: TLabel
            Left = 160
            Top = 33
            Width = 59
            Height = 13
            Caption = #31181#20540#25968#37327':'
          end
          object Label5: TLabel
            Left = 0
            Top = 0
            Width = 585
            Height = 25
            Align = alTop
            Alignment = taCenter
            AutoSize = False
            Caption = #21551#21160': CTRL+HOME  '#20572#27490': CTRL+END'
            Font.Charset = ANSI_CHARSET
            Font.Color = clRed
            Font.Height = -13
            Font.Name = #23435#20307
            Font.Style = []
            ParentFont = False
            Layout = tlCenter
          end
          object BtnWheatStart: TButton
            Left = 45
            Top = 92
            Width = 75
            Height = 25
            Caption = #21551#21160
            TabOrder = 0
            OnClick = BtnWheatStartClick
          end
          object BtnWheatStop: TButton
            Left = 175
            Top = 92
            Width = 75
            Height = 25
            Caption = #20572#27490
            TabOrder = 1
            OnClick = BtnWheatStopClick
          end
          object EdtWheatLoop: TSpinEdit
            Left = 70
            Top = 30
            Width = 80
            Height = 22
            MaxValue = 65535
            MinValue = 1
            TabOrder = 2
            Value = 1
          end
          object ComCrops: TComboBox
            Left = 70
            Top = 60
            Width = 80
            Height = 21
            Style = csDropDownList
            ItemIndex = 0
            TabOrder = 3
            Text = #23567#40614
            Items.Strings = (
              #23567#40614
              #29577#31859
              #33821#21340
              #29976#34071
              #26825#33457
              #33609#33683
              #30058#33540)
          end
          object CheckCropsFast: TCheckBox
            Left = 160
            Top = 62
            Width = 70
            Height = 17
            Caption = #24320#21551#21152#36895
            Checked = True
            State = cbChecked
            TabOrder = 4
            OnClick = CheckCropsFastClick
          end
          object ComCropsCount: TComboBox
            Left = 220
            Top = 30
            Width = 80
            Height = 21
            Style = csDropDownList
            ItemIndex = 6
            TabOrder = 5
            Text = '70'
            Items.Strings = (
              '10'
              '20'
              '30'
              '40'
              '50'
              '60'
              '70'
              '80')
          end
        end
        object TabSheet2: TTabSheet
          Caption = #27604#36187
          ImageIndex = 1
          object GbRollerCoaster: TGroupBox
            AlignWithMargins = True
            Left = 3
            Top = 3
            Width = 579
            Height = 50
            Align = alTop
            Caption = #36807#23665#36710
            TabOrder = 0
            object CheckKeyboard: TCheckBox
              Left = 10
              Top = 20
              Width = 110
              Height = 17
              Caption = #38190#30424#26041#21521#38190#36741#21161
              TabOrder = 0
              OnClick = CheckKeyboardClick
            end
          end
          object GroupBox1: TGroupBox
            AlignWithMargins = True
            Left = 3
            Top = 59
            Width = 579
            Height = 52
            Align = alTop
            Caption = #32650#32650#36187
            TabOrder = 1
            object Button2: TButton
              Left = 5
              Top = 17
              Width = 75
              Height = 25
              Caption = 'Button2'
              TabOrder = 0
              OnClick = Button2Click
            end
            object Button3: TButton
              Left = 86
              Top = 17
              Width = 75
              Height = 25
              Caption = 'Button3'
              TabOrder = 1
              OnClick = Button3Click
            end
          end
        end
        object TabOther: TTabSheet
          Caption = #20854#20182
          ImageIndex = 2
          object Label6: TLabel
            Left = 15
            Top = 64
            Width = 42
            Height = 13
            Caption = 'Label6'
          end
          object Button1: TButton
            Left = 15
            Top = 21
            Width = 75
            Height = 25
            Caption = #25235#22270
            TabOrder = 0
            OnClick = Button1Click
          end
        end
      end
    end
  end
  object TimerWindow: TTimer
    Interval = 630
    OnTimer = TimerWindowTimer
    Left = 259
    Top = 212
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 100
    OnTimer = Timer1Timer
    Left = 227
    Top = 316
  end
  object Timer2: TTimer
    Interval = 100
    OnTimer = Timer2Timer
    Left = 363
    Top = 68
  end
end
