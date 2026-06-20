object Form1: TForm1
  Left = 365
  Height = 469
  Top = 204
  Width = 755
  Caption = '3 Joint Passive'
  ClientHeight = 469
  ClientWidth = 755
  Color = clHighlightText
  OnCreate = FormCreate
  LCLVersion = '6.3'
  object Button1: TButton
    Left = 360
    Height = 79
    Top = 376
    Width = 120
    Caption = 'RUN'
    OnClick = Button1Click
    TabOrder = 0
  end
  object Button2: TButton
    Left = 504
    Height = 79
    Top = 377
    Width = 112
    Caption = 'STOP'
    OnClick = Button2Click
    TabOrder = 1
  end
  object Edit1: TEdit
    Left = 172
    Height = 23
    Top = 384
    Width = 80
    TabOrder = 2
    Text = '40'
  end
  object Edit2: TEdit
    Left = 268
    Height = 23
    Top = 433
    Width = 80
    TabOrder = 3
    Text = '20'
  end
  object Edit3: TEdit
    Left = 268
    Height = 23
    Top = 384
    Width = 80
    TabOrder = 4
    Text = '-5'
  end
  object Chart1: TChart
    Left = 360
    Height = 112
    Top = 24
    Width = 380
    AxisList = <    
      item
        Minors = <>
        Title.LabelFont.Orientation = 900
        Title.Visible = True
        Title.Caption = 'Angle'
      end    
      item
        Alignment = calBottom
        Minors = <>
        Title.Visible = True
        Title.Caption = 'Iteration'
      end>
    Foot.Brush.Color = clBtnFace
    Foot.Font.Color = clBlue
    Title.Brush.Color = clBtnFace
    Title.Font.Color = clBlue
    Title.Text.Strings = (
      'Hip Angle'
    )
    Title.Visible = True
    object Chart1LineSeries1: TLineSeries
    end
    object Chart1LineSeries2: TLineSeries
    end
  end
  object Chart2: TChart
    Left = 360
    Height = 120
    Top = 136
    Width = 380
    AxisList = <    
      item
        Minors = <>
        Title.LabelFont.Orientation = 900
        Title.Visible = True
        Title.Caption = 'Angle'
      end    
      item
        Alignment = calBottom
        Minors = <>
        Title.Visible = True
        Title.Caption = 'Iteration'
      end>
    Foot.Brush.Color = clBtnFace
    Foot.Font.Color = clBlue
    Title.Brush.Color = clBtnFace
    Title.Font.Color = clBlue
    Title.Text.Strings = (
      'Knee Angle'
    )
    Title.Visible = True
    object Chart2LineSeries1: TLineSeries
    end
    object Chart2LineSeries2: TLineSeries
    end
  end
  object Chart3: TChart
    Left = 360
    Height = 112
    Top = 256
    Width = 380
    AxisList = <    
      item
        Minors = <>
        Title.LabelFont.Orientation = 900
        Title.Visible = True
        Title.Caption = 'Angle'
      end    
      item
        Alignment = calBottom
        Minors = <>
        Title.Visible = True
        Title.Caption = 'Iteration'
      end>
    Foot.Brush.Color = clBtnFace
    Foot.Font.Color = clBlue
    Title.Brush.Color = clBtnFace
    Title.Font.Color = clBlue
    Title.Text.Strings = (
      'Ankle Angle'
    )
    Title.Visible = True
    object Chart3LineSeries1: TLineSeries
    end
    object Chart3LineSeries2: TLineSeries
    end
  end
  object Chart4: TChart
    Left = 8
    Height = 344
    Top = 24
    Width = 340
    AxisList = <    
      item
        Minors = <>
        Title.LabelFont.Orientation = 900
      end    
      item
        Alignment = calBottom
        Minors = <>
      end>
    AxisVisible = False
    BackColor = clBtnHighlight
    Extent.UseXMax = True
    Extent.UseXMin = True
    Extent.UseYMax = True
    Extent.UseYMin = True
    Extent.XMax = 200
    Extent.XMin = -200
    Extent.YMax = 30
    Extent.YMin = -250
    Foot.Brush.Color = clBtnFace
    Foot.Font.Color = clBlue
    Title.Brush.Color = clBtnFace
    Title.Font.Color = clBlue
    Title.Text.Strings = (
      'TAChart'
    )
    object Chart4LineSeries1: TLineSeries
      LinePen.Color = clBlue
      LinePen.Width = 4
    end
    object Chart4LineSeries2: TLineSeries
      LinePen.Color = clBlue
      LinePen.Width = 4
    end
  end
  object Label1: TLabel
    Left = 172
    Height = 15
    Top = 368
    Width = 19
    Caption = 'HIP'
    ParentColor = False
  end
  object Label2: TLabel
    Left = 268
    Height = 15
    Top = 417
    Width = 28
    Caption = 'KNEE'
    ParentColor = False
  end
  object Label3: TLabel
    Left = 268
    Height = 15
    Top = 368
    Width = 36
    Caption = 'ANKLE'
    ParentColor = False
  end
  object GroupBox1: TGroupBox
    Left = 8
    Height = 84
    Top = 372
    Width = 152
    Caption = 'Choose Position'
    ClientHeight = 64
    ClientWidth = 148
    TabOrder = 9
    object RadioButton1: TRadioButton
      Left = 8
      Height = 19
      Top = 0
      Width = 67
      Caption = 'Standing'
      OnChange = RadioButton1Change
      TabOrder = 0
    end
    object RadioButton2: TRadioButton
      Left = 8
      Height = 19
      Top = 32
      Width = 54
      Caption = 'Sitting'
      OnChange = RadioButton2Change
      TabOrder = 1
    end
  end
  object Button3: TButton
    Left = 632
    Height = 79
    Top = 376
    Width = 108
    Caption = 'Save File'
    OnClick = Button3Click
    TabOrder = 10
  end
  object Edit4: TEdit
    Left = 172
    Height = 23
    Top = 432
    Width = 80
    TabOrder = 11
  end
  object Label4: TLabel
    Left = 172
    Height = 15
    Top = 416
    Width = 44
    Caption = 'Iteration'
    ParentColor = False
  end
  object Timer1: TTimer
    Interval = 1
    OnTimer = Timer1Timer
    Left = 32
    Top = 328
  end
  object SaveDialog1: TSaveDialog
    Left = 72
    Top = 328
  end
end
