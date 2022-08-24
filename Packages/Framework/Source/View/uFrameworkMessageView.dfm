inherited FrameworkMessageView: TFrameworkMessageView
  Caption = 'Mensagem'
  ClientHeight = 125
  ClientWidth = 432
  Font.Height = -11
  Font.Name = 'Tahoma'
  OldCreateOrder = False
  Scaled = False
  OnShow = FormShow
  ExplicitWidth = 448
  ExplicitHeight = 164
  PixelsPerInch = 96
  TextHeight = 13
  object PanelBackground: TPanel
    Left = 0
    Top = 0
    Width = 432
    Height = 125
    Align = alClient
    Caption = 'PanelBackground'
    ShowCaption = False
    TabOrder = 0
    object PanelMessages: TPanel
      Left = 84
      Top = 1
      Width = 347
      Height = 123
      Align = alClient
      BevelOuter = bvNone
      Caption = 'PanelMessages'
      ShowCaption = False
      TabOrder = 0
      object PanelButtons: TPanel
        Left = 0
        Top = 94
        Width = 347
        Height = 29
        Align = alBottom
        BevelOuter = bvNone
        Caption = 'PanelButtons'
        ShowCaption = False
        TabOrder = 0
      end
      object PanelMessageDetail: TPanel
        Left = 0
        Top = 17
        Width = 347
        Height = 77
        Align = alBottom
        BevelOuter = bvNone
        Caption = 'PanelMessages'
        ShowCaption = False
        TabOrder = 1
        object MemoMessage: TMemo
          Left = 0
          Top = 0
          Width = 347
          Height = 77
          Align = alClient
          TabOrder = 0
        end
      end
      object PanelMessageTitle: TPanel
        Left = 0
        Top = 0
        Width = 347
        Height = 33
        Align = alTop
        BevelOuter = bvNone
        Caption = 'PanelMessages'
        ShowCaption = False
        TabOrder = 2
        object LabelTitle: TLabel
          AlignWithMargins = True
          Left = 0
          Top = 17
          Width = 45
          Height = 13
          Caption = 'LabelTitle'
        end
      end
    end
    object PanelImage: TPanel
      Left = 1
      Top = 1
      Width = 83
      Height = 123
      Align = alLeft
      BevelOuter = bvNone
      Caption = 'PanelImage'
      ShowCaption = False
      TabOrder = 1
      object ImageError: TImage
        Left = 8
        Top = 15
        Width = 68
        Height = 68
      end
    end
  end
end
