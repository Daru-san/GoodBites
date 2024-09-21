object frmFetcher: TfrmFetcher
  Left = 0
  Top = 0
  Caption = 'frmFetcher'
  ClientHeight = 441
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object NetHTTPClient1: TNetHTTPClient
    UserAgent = 'Embarcadero URI Client/1.0'
    Left = 264
    Top = 208
  end
  object NetHTTPRequest1: TNetHTTPRequest
    ConnectionTimeout = 0
    SendTimeout = 0
    ResponseTimeout = 0
    Left = 168
    Top = 256
  end
end
