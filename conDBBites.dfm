object dbmData: TdbmData
  Height = 488
  Width = 788
  object conDB: TADOConnection
    Connected = True
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=D:\documents\Comput' +
      'er Science\School\PATS\G11\Bitten\src\dbBites.mdb;Persist Securi' +
      'ty Info=False'
    LoginPrompt = False
    Mode = cmShareDenyNone
    Provider = 'Microsoft.Jet.OLEDB.4.0'
    Left = 336
    Top = 224
  end
  object tblUsers: TADOTable
    Active = True
    Connection = conDB
    CursorType = ctStatic
    TableName = 'tblUsers'
    Left = 232
    Top = 128
  end
  object dscUsers: TDataSource
    DataSet = tblUsers
    Left = 96
    Top = 56
  end
  object tblData: TADOTable
    Active = True
    Connection = conDB
    CursorType = ctStatic
    TableName = 'tblData'
    Left = 200
    Top = 288
  end
  object dscData: TDataSource
    DataSet = tblData
    Left = 96
    Top = 344
  end
  object tblFoods: TADOTable
    Active = True
    Connection = conDB
    CursorType = ctStatic
    TableName = 'tblFoods'
    Left = 448
    Top = 280
  end
  object tblNutrients: TADOTable
    Connection = conDB
    TableName = 'tblNutrients'
    Left = 520
    Top = 104
  end
  object dscNutrients: TDataSource
    DataSet = tblNutrients
    Left = 656
    Top = 48
  end
  object dscFoods: TDataSource
    DataSet = tblFoods
    Left = 576
    Top = 345
  end
end
