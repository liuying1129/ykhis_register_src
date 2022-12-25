object frmMain: TfrmMain
  Left = 192
  Top = 123
  Width = 870
  Height = 524
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
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object StatusBar1: TStatusBar
    Left = 0
    Top = 466
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
        OnClick = SpeedButton1Click
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
    Width = 385
    Height = 429
    Align = alLeft
    TabOrder = 2
    object Label1: TLabel
      Left = 160
      Top = 224
      Width = 52
      Height = 13
      Caption = #30475#35786#26085#26399
    end
    object LabeledEdit2: TLabeledEdit
      Left = 24
      Top = 288
      Width = 121
      Height = 21
      EditLabel.Width = 26
      EditLabel.Height = 13
      EditLabel.Caption = #21320#21035
      TabOrder = 0
    end
    object LabeledEdit3: TLabeledEdit
      Left = 240
      Top = 288
      Width = 121
      Height = 21
      EditLabel.Width = 26
      EditLabel.Height = 13
      EditLabel.Caption = #21495#21035
      TabOrder = 1
    end
    object LabeledEdit4: TLabeledEdit
      Left = 24
      Top = 344
      Width = 121
      Height = 21
      EditLabel.Width = 26
      EditLabel.Height = 13
      EditLabel.Caption = #31185#23460
      TabOrder = 2
    end
    object LabeledEdit5: TLabeledEdit
      Left = 240
      Top = 344
      Width = 121
      Height = 21
      EditLabel.Width = 26
      EditLabel.Height = 13
      EditLabel.Caption = #21307#29983
      TabOrder = 3
    end
    object DBGrid1: TDBGrid
      Left = 1
      Top = 1
      Width = 383
      Height = 120
      Align = alTop
      DataSource = DataSource1
      ReadOnly = True
      TabOrder = 4
      TitleFont.Charset = ANSI_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -13
      TitleFont.Name = #23435#20307
      TitleFont.Style = []
    end
    object BitBtn1: TBitBtn
      Left = 168
      Top = 392
      Width = 75
      Height = 25
      Caption = #25346#21495
      TabOrder = 5
      OnClick = BitBtn1Click
    end
    object DateTimePicker1: TDateTimePicker
      Left = 160
      Top = 240
      Width = 100
      Height = 21
      Date = 44920.826685208330000000
      Time = 44920.826685208330000000
      TabOrder = 6
    end
  end
  object DBGrid2: TDBGrid
    Left = 432
    Top = 72
    Width = 401
    Height = 313
    DataSource = DataSource2
    ReadOnly = True
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
  object MyQuery1: TMyQuery
    Left = 144
    Top = 53
  end
  object DataSource1: TDataSource
    DataSet = MyQuery1
    Left = 112
    Top = 53
  end
  object DataSource2: TDataSource
    DataSet = MyQuery2
    Left = 456
    Top = 120
  end
  object MyQuery2: TMyQuery
    Left = 488
    Top = 120
  end
end
