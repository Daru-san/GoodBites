object dmData: TdmData
  Height = 269
  Width = 464
  object conDB: TADOConnection
    Connected = True
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=D:\documents\Comput' +
      'er Science\School\PATS\G11\Bitten\src\dbBites.mdb;Persist Securi' +
      'ty Info=False'
    LoginPrompt = False
    Mode = cmShareDenyNone
    Provider = 'Microsoft.Jet.OLEDB.4.0'
    Left = 96
    Top = 64
  end
  object tblUsers: TADOTable
    Active = True
    Connection = conDB
    CursorType = ctStatic
    TableName = 'tblUsers'
    Left = 240
    Top = 96
  end
  object dscUsers: TDataSource
    DataSet = tblUsers
    Left = 336
    Top = 104
  end
end
