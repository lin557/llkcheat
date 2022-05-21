object FrmQqGame: TFrmQqGame
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
    ActiveCard = CardLlk
    BevelOuter = bvNone
    Caption = 'CardPanel'
    TabOrder = 0
    ExplicitLeft = 128
    ExplicitTop = 56
    ExplicitWidth = 300
    ExplicitHeight = 200
    object CardLlk: TCard
      Left = 0
      Top = 0
      Width = 599
      Height = 436
      Caption = #36830#36830#30475
      CardIndex = 0
      TabOrder = 0
      ExplicitLeft = 1
      ExplicitTop = 1
      ExplicitWidth = 298
      ExplicitHeight = 198
      object PnlTopLlk: TPanel
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
          ExplicitHeight = 33
        end
      end
      object PnlMainLlk: TPanel
        AlignWithMargins = True
        Left = 3
        Top = 44
        Width = 593
        Height = 389
        Align = alClient
        BevelKind = bkFlat
        BevelOuter = bvNone
        TabOrder = 1
        ExplicitTop = 3
        ExplicitWidth = 579
        ExplicitHeight = 395
        object ImgLlk: TImage
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
    object CardMnzc: TCard
      Left = 0
      Top = 0
      Width = 599
      Height = 436
      Caption = #32654#22899#25214#33580
      CardIndex = 1
      TabOrder = 1
      ExplicitHeight = 439
    end
  end
end
