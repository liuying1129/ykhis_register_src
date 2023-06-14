object frmMain: TfrmMain
  Left = 192
  Top = 110
  Width = 870
  Height = 555
  Caption = #25346#21495
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = #23435#20307
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  WindowState = wsMaximized
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object StatusBar1: TStatusBar
    Left = 0
    Top = 497
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
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 37
    Width = 161
    Height = 460
    Align = alLeft
    TabOrder = 2
    object Label1: TLabel
      Left = 16
      Top = 208
      Width = 52
      Height = 13
      Caption = #30475#35786#26085#26399
    end
    object Label2: TLabel
      Left = 16
      Top = 250
      Width = 26
      Height = 13
      Caption = #21320#21035
    end
    object Label3: TLabel
      Left = 16
      Top = 290
      Width = 26
      Height = 13
      Caption = #21495#21035
    end
    object Label4: TLabel
      Left = 16
      Top = 330
      Width = 26
      Height = 13
      Caption = #31185#23460
    end
    object Label5: TLabel
      Left = 16
      Top = 370
      Width = 26
      Height = 13
      Caption = #21307#29983
    end
    object BitBtn1: TBitBtn
      Left = 16
      Top = 424
      Width = 121
      Height = 25
      Caption = #25346#21495
      TabOrder = 0
      OnClick = BitBtn1Click
    end
    object DateTimePicker1: TDateTimePicker
      Left = 16
      Top = 224
      Width = 100
      Height = 21
      Date = 44920.826685208330000000
      Time = 44920.826685208330000000
      TabOrder = 1
    end
    object LabeledEdit1: TLabeledEdit
      Left = 16
      Top = 96
      Width = 121
      Height = 21
      EditLabel.Width = 26
      EditLabel.Height = 13
      EditLabel.Caption = #22995#21517
      Enabled = False
      TabOrder = 2
    end
    object LabeledEdit6: TLabeledEdit
      Left = 16
      Top = 136
      Width = 121
      Height = 21
      EditLabel.Width = 26
      EditLabel.Height = 13
      EditLabel.Caption = #24615#21035
      Enabled = False
      TabOrder = 3
    end
    object LabeledEdit7: TLabeledEdit
      Left = 16
      Top = 180
      Width = 121
      Height = 21
      EditLabel.Width = 52
      EditLabel.Height = 13
      EditLabel.Caption = #20986#29983#26085#26399
      Enabled = False
      TabOrder = 4
    end
    object LabeledEdit8: TLabeledEdit
      Left = 16
      Top = 56
      Width = 121
      Height = 21
      EditLabel.Width = 80
      EditLabel.Height = 13
      EditLabel.Caption = #24739#32773#20449#24687'UNID'
      Enabled = False
      TabOrder = 5
    end
    object BitBtn2: TBitBtn
      Left = 16
      Top = 8
      Width = 121
      Height = 25
      Caption = #36873#25321#24739#32773
      TabOrder = 6
      OnClick = BitBtn2Click
    end
    object ComboBox1: TComboBox
      Left = 16
      Top = 264
      Width = 121
      Height = 21
      ItemHeight = 13
      TabOrder = 7
    end
    object ComboBox2: TComboBox
      Left = 16
      Top = 305
      Width = 121
      Height = 21
      ItemHeight = 13
      TabOrder = 8
    end
    object ComboBox3: TComboBox
      Left = 16
      Top = 345
      Width = 121
      Height = 21
      DropDownCount = 15
      ItemHeight = 13
      TabOrder = 9
      OnChange = ComboBox3Change
    end
    object ComboBox4: TComboBox
      Left = 16
      Top = 385
      Width = 121
      Height = 21
      DropDownCount = 20
      ItemHeight = 13
      TabOrder = 10
    end
  end
  object DBGrid2: TDBGrid
    Left = 161
    Top = 37
    Width = 693
    Height = 460
    Align = alClient
    DataSource = DataSource2
    PopupMenu = PopupMenu1
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
  object DataSource2: TDataSource
    DataSet = MyQuery2
    Left = 456
    Top = 120
  end
  object MyQuery2: TUniQuery
    AfterOpen = MyQuery2AfterOpen
    Left = 488
    Top = 120
  end
  object DosMove1: TDosMove
    Active = True
    Left = 585
    Top = 8
  end
  object PopupMenu1: TPopupMenu
    AutoHotkeys = maManual
    Left = 520
    Top = 120
    object N1: TMenuItem
      Caption = #21024#21495
      OnClick = N1Click
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object N3: TMenuItem
      Caption = #21047#26032
      OnClick = N3Click
    end
  end
end
