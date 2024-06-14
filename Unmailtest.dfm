object Form1: TForm1
  Left = 274
  Top = 285
  Width = 483
  Height = 353
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object SpeedButton1: TSpeedButton
    Left = 80
    Top = 264
    Width = 113
    Height = 22
    Caption = 'Connect'
    OnClick = SpeedButton1Click
  end
  object Memo1: TMemo
    Left = 80
    Top = 32
    Width = 337
    Height = 193
    Lines.Strings = (
      'Memo1')
    TabOrder = 0
  end
  object IdPOP31: TIdPOP3
    Left = 200
    Top = 96
  end
  object IdSMTP1: TIdSMTP
    OnDisconnected = IdSMTP1Disconnected
    Host = 'MAEXCH04'
    OnConnected = IdSMTP1Connected
    AuthenticationType = atLogin
    Password = 'havsyn'
    UserId = 'n11150'
    Left = 112
    Top = 88
  end
  object IdMessage1: TIdMessage
    BccList = <>
    CharSet = 'ISO-8859-1'
    CCList = <>
    From.Address = 'nordiskteksttv@nrk.no'
    From.Text = 'nordiskteksttv@nrk.no'
    NoDecode = True
    Recipients = <
      item
      end>
    ReplyTo = <
      item
        Address = 'kjell.norberg@nrk.no'
        Name = 'Kjell Norberg'
        Text = 'Kjell Norberg <kjell.norberg@nrk.no>'
      end>
    Subject = 'Test1'
    Sender.Address = 'nordiskteksttv@nrk.no'
    Sender.Text = 'nordiskteksttv@nrk.no'
    Left = 280
    Top = 104
  end
end
