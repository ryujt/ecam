object frSetup: TfrSetup
  Left = 0
  Top = 0
  Width = 310
  Height = 230
  HelpType = htKeyword
  HelpKeyword = 'Setup'
  TabOrder = 0
  object Label1: TLabel
    Left = 12
    Top = 45
    Width = 47
    Height = 13
    Caption = #49828#53944#47548' '#53412
  end
  object Bevel1: TBevel
    Left = 12
    Top = 96
    Width = 285
    Height = 9
    Shape = bsTopLine
  end
  object cbYouTube: TCheckBox
    Left = 12
    Top = 12
    Width = 185
    Height = 17
    Caption = '  '#46972#51060#48652' '#48169#49569#54616#44592
    Checked = True
    State = cbChecked
    TabOrder = 0
    OnClick = cbYouTubeClick
  end
  object edStreamKey: TEdit
    Left = 12
    Top = 59
    Width = 285
    Height = 21
    TabOrder = 1
    OnKeyUp = edStreamKeyKeyUp
  end
  object cbMinimize: TCheckBox
    Left = 12
    Top = 116
    Width = 185
    Height = 17
    Caption = '  '#45433#54868' '#49884#51089#54624' '#46412' '#52572#49548#54868#54616#44592
    TabOrder = 2
    OnClick = cbMinimizeClick
  end
end
