object frmMain: TfrmMain
  Left = 192
  Top = 123
  Width = 870
  Height = 450
  Caption = #25346#21495
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  WindowState = wsMaximized
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object StatusBar1: TStatusBar
    Left = 0
    Top = 392
    Width = 854
    Height = 19
    Panels = <
      item
        Width = 65
      end
      item
        Text = #25805#20316#20154#21592#24037#21495':'
        Width = 80
      end
      item
        Width = 50
      end
      item
        Text = #25805#20316#20154#21592#22995#21517':'
        Width = 80
      end
      item
        Width = 50
      end
      item
        Text = #25480#26435#20351#29992#21333#20301':'
        Width = 80
      end
      item
        Width = 150
      end
      item
        Text = #26381#21153#22120':'
        Width = 45
      end
      item
        Width = 75
      end
      item
        Text = #25968#25454#24211':'
        Width = 45
      end
      item
        Width = 50
      end
      item
        Text = #37096#38376':'
        Width = 35
      end
      item
        Width = 50
      end
      item
        Width = 50
      end>
  end
  object CoolBar1: TCoolBar
    Left = 0
    Top = 0
    Width = 854
    Height = 37
    Bands = <
      item
        Control = ToolBar1
        ImageIndex = -1
        MinHeight = 33
        Width = 850
      end>
    object ToolBar1: TToolBar
      Left = 9
      Top = 0
      Width = 837
      Height = 33
      Caption = 'ToolBar1'
      TabOrder = 0
      object SpeedButton1: TSpeedButton
        Left = 0
        Top = 2
        Width = 95
        Height = 22
        Caption = #36873#25321#24739#32773
      end
      object ToolButton1: TToolButton
        Left = 95
        Top = 2
        Width = 8
        Caption = 'ToolButton1'
        Style = tbsSeparator
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 37
    Width = 185
    Height = 355
    Align = alLeft
    TabOrder = 2
    object LabeledEdit1: TLabeledEdit
      Left = 48
      Top = 40
      Width = 121
      Height = 21
      EditLabel.Width = 52
      EditLabel.Height = 13
      EditLabel.Caption = #30475#35786#26085#26399
      TabOrder = 0
    end
    object LabeledEdit2: TLabeledEdit
      Left = 48
      Top = 88
      Width = 121
      Height = 21
      EditLabel.Width = 26
      EditLabel.Height = 13
      EditLabel.Caption = #21320#21035
      TabOrder = 1
    end
    object LabeledEdit3: TLabeledEdit
      Left = 48
      Top = 144
      Width = 121
      Height = 21
      EditLabel.Width = 26
      EditLabel.Height = 13
      EditLabel.Caption = #21495#21035
      TabOrder = 2
    end
    object LabeledEdit4: TLabeledEdit
      Left = 48
      Top = 192
      Width = 121
      Height = 21
      EditLabel.Width = 26
      EditLabel.Height = 13
      EditLabel.Caption = #31185#23460
      TabOrder = 3
    end
    object LabeledEdit5: TLabeledEdit
      Left = 48
      Top = 248
      Width = 121
      Height = 21
      EditLabel.Width = 26
      EditLabel.Height = 13
      EditLabel.Caption = #21307#29983
      TabOrder = 4
    end
  end
  object DBGrid1: TDBGrid
    Left = 200
    Top = 64
    Width = 409
    Height = 233
    TabOrder = 3
    TitleFont.Charset = ANSI_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -13
    TitleFont.Name = #23435#20307
    TitleFont.Style = []
  end
  object TimerIdleTracker: TTimer
    Enabled = False
    Interval = 2000
    Left = 553
    Top = 8
  end
end
