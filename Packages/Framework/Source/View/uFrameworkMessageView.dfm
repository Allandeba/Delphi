inherited FrameworkMessageView: TFrameworkMessageView
  Caption = 'Message'
  ClientHeight = 140
  ClientWidth = 448
  Font.Height = -11
  Font.Name = 'Tahoma'
  Scaled = False
  OnShow = FormShow
  ExplicitWidth = 464
  ExplicitHeight = 179
  PixelsPerInch = 96
  TextHeight = 13
  object PanelBackground: TPanel
    Left = 0
    Top = 0
    Width = 448
    Height = 140
    Align = alClient
    Caption = 'PanelBackground'
    ShowCaption = False
    TabOrder = 0
    object PanelMessages: TPanel
      Left = 1
      Top = 1
      Width = 446
      Height = 138
      Align = alClient
      BevelOuter = bvNone
      Caption = 'PanelMessages'
      ShowCaption = False
      TabOrder = 0
      object PanelImage: TPanel
        Left = 0
        Top = 0
        Width = 83
        Height = 138
        Align = alLeft
        BevelOuter = bvNone
        Caption = 'PanelImage'
        ShowCaption = False
        TabOrder = 0
        object ImageError: TImage
          Left = 9
          Top = 28
          Width = 68
          Height = 68
        end
      end
      object PanelContent: TPanel
        Left = 83
        Top = 0
        Width = 363
        Height = 138
        Align = alClient
        BevelOuter = bvNone
        Caption = 'PanelButtons'
        ShowCaption = False
        TabOrder = 1
        object PanelMessageTitle: TPanel
          Left = 0
          Top = 0
          Width = 363
          Height = 33
          Align = alTop
          BevelOuter = bvNone
          Caption = 'PanelMessages'
          ShowCaption = False
          TabOrder = 0
          object LabelTitle: TLabel
            AlignWithMargins = True
            Left = 6
            Top = 20
            Width = 45
            Height = 13
            Caption = 'LabelTitle'
          end
        end
        object PanelButtons: TPanel
          Left = 0
          Top = 109
          Width = 363
          Height = 29
          Align = alBottom
          BevelOuter = bvNone
          Caption = 'PanelButtons'
          ShowCaption = False
          TabOrder = 1
        end
        object PanelMessageDetail: TPanel
          Left = 0
          Top = 32
          Width = 363
          Height = 77
          Align = alBottom
          BevelOuter = bvNone
          Caption = 'PanelMessages'
          ShowCaption = False
          TabOrder = 2
          object MemoMessage: TMemo
            Left = 0
            Top = 0
            Width = 363
            Height = 77
            Align = alClient
            TabOrder = 0
          end
        end
      end
    end
  end
end
