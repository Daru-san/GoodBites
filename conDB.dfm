object dmData: TdmData
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 480
  Width = 640
  object dbConnect: TADOConnection
    Left = 312
    Top = 208
  end
  object tblMeals: TADOTable
    Left = 416
    Top = 361
  end
  object tblFoods: TADOTable
    Left = 512
    Top = 289
  end
  object tblUsers: TADOTable
    Left = 488
    Top = 185
  end
  object dscFoods: TDataSource
    Left = 168
    Top = 192
  end
  object dscUsers: TDataSource
    Left = 184
    Top = 296
  end
  object timeBackup: TTimer
    Enabled = False
    OnTimer = timeBackupTimer
    Left = 296
    Top = 304
  end
  object tblGoals: TADOTable
    Left = 264
    Top = 112
  end
  object tblProgress: TADOTable
    Left = 432
    Top = 120
  end
end
