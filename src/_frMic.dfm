object frMic: TfrMic
  Left = 0
  Top = 0
  Width = 310
  Height = 230
  HelpType = htKeyword
  HelpKeyword = 'Mic'
  TabOrder = 0
  object Label1: TLabel
    Left = 12
    Top = 45
    Width = 58
    Height = 13
    Caption = #47560#51060#53356' '#49440#53469
  end
  object cbSystemAudio: TCheckBox
    Left = 12
    Top = 12
    Width = 185
    Height = 17
    Caption = '  '#49884#49828#53596' '#50724#46356#50724' '#52897#52432
    TabOrder = 0
    OnClick = cbSystemAudioClick
  end
  object cbMic: TComboBox
    Left = 12
    Top = 60
    Width = 285
    Height = 21
    TabOrder = 1
    Text = #44592#48376' '#51109#52824
    OnChange = cbMicChange
    OnDropDown = cbMicDropDown
    OnKeyDown = cbMicKeyDown
    OnKeyPress = cbMicKeyPress
  end
end
