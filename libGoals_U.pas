unit libGoals_U;

interface

uses conDB,SysUtils;

type
  TGoal = class(TObject)
    FGoalID : Integer;
    FUserID : string;
    FGoalUnit : String;
    FItem : String;
    FStartDate : TDate;
    FTarget : Real;

    private
      procedure GetGoalID;
      procedure GetGoalTarget;
      procedure GetGoalDate;
      procedure ResetProgress;
      procedure LogProgress(pGoalID : Integer;pAmount : Real);
    public
      property GoalID : Integer read FGoalID write FGoalID;
      property UserID : String read FUserID write FUserID;
      property GoalUnit : String read FGoalUnit write FGoalUnit;
      property Item : String read FItem write FItem;
      property StartDate : TDate read FStartDate write FStartDate;
      property Target : Real read FTarget write FTarget;

      constructor Create(pUserID,pItem : String);
      destructor Destroy; override;

      function GetDesc : String;
      // Progress
      procedure SaveProgress(pAmount : Real);

      function GetProgress(pRecDate : TDate) : Real;

      function CalcAverage : Real;
      function CalcDaysAchieved : Integer;
      function GetTotalDays : Integer;

      procedure SetGoalTarget;
      procedure AddGoal;
      procedure EditDesc(pDesc: String);
      procedure DeleteGoal;
  end;

implementation

constructor TGoal.Create;
begin
  UserID := pUserID;
  Item := pItem;

  GetGoalID;
  GetGoalTarget;
  GetGoalDate;
end;

destructor TGoal.Destroy;
begin

end;
{ Goals }

{$REGION Goals }
procedure TGoal.SaveProgress(pAmount: Real);
var
  dDate : TDate;
  iGoalID : Integer;
  isFound : Boolean;
begin
  isFound := False;

  with dmData.tblGoals do
  begin
    Open;
    First;
    repeat
      if (GoalID = FieldValues['GoalID']) then
      begin
        isFound := true;
        iGoalID := FieldValues['GoalID'];
        LogProgress(iGoalID,pAmount);
      end else Next;
    until EOF or isFound;
    Close;
  end;
end;

procedure TGoal.LogProgress;
var
  isFound : Boolean;
begin
  isFound := false;
  with dmData.tblProgress do
  begin
    Open;
    First;
    repeat
      if (pGoalID = FieldValues['GoalID']) and (Date = FieldValues['DateRecorded']) then
      begin
        isFound := true;
        Edit;
        FieldValues['Amount'] := FieldValues['Amount'] + pAmount;
        Post;
      end else Next;
    until EOF or isFound;

    if not isFound then
    begin
      Append;
      FieldValues['GoalID'] := pGoalID;
      FieldValues['Amount'] := pAmount;
      FieldValues['DateRecorded'] := Date;
      Post;
    end;
    Close;
  end;
end;

procedure TGoal.ResetProgress;
begin
  with dmData.tblProgress do
  begin
    Open;
    First;
    repeat
      if (GoalID = FieldValues['GoalID']) then
      Delete
      else next;
    until EOF;
    Close;
  end;
end;

procedure TGoal.AddGoal;
begin
  DeleteGoal;
  with dmData.tblGoals do
  begin
    Open;
    Append;
    FieldValues['Item'] := Item;
    FieldValues['Target'] := Target;
    FieldValues['StartDate'] := Date;
    FieldValues['Unit'] := GoalUnit;
    FieldValues['UserID'] := UserID;
    FieldValues['Desc'] := Item + ' in ' + GoalUnit;
    Post;
    Close;
  end;
end;

procedure TGoal.DeleteGoal;
var isFound : Boolean;
begin
  ResetProgress;
  isFound := false;
  with dmData.tblGoals do
  begin
    Open;
    First;
    repeat
      if (UserID = FieldValues['UserID']) and (GoalID = FieldValues['GoalID']) then
      begin
        isFound := true;
        Delete;
      end
      else next;
    until EOF or isFound;
    Close;
  end;
end;

procedure TGoal.SetGoalTarget;
var isFound : Boolean;
begin
  with dmData.tblGoals do
  begin
    Open;
    First;
    repeat
      if (UserID = FieldValues['UserID']) and (GoalID = FieldValues['GoalID']) then
      begin
        isFound := true;
        ResetProgress;
        Edit;
        FieldValues['Target'] := Target;
        Post;
      end else next;
    until EOF or isFound;
    Close;
  end;
end;

procedure TGoal.GetGoalTarget;
var
  isFound : Boolean;
  rTarget : Real;
begin
  rTarget := 0;
  isFound := false;
  with dmData.tblGoals do
  begin
    Open;
    First;
    repeat
      if (GoalID = FieldValues['GoalID']) and (UserID = FieldValues['UserID']) then
      begin
        isFound := true;
        rTarget := FieldValues['Target'];
      end else Next;
    until EOF or isFound;
    Close;
  end;
  Target := rTarget;
end;

procedure TGoal.GetGoalID;
var
  isFound : Boolean;
  iGoalID : Integer;
begin
  isFound := False;
  iGoalID := 0;
  with dmData.tblGoals do
  begin
    Open;
    First;
    repeat
      if (FieldValues['UserID'] = UserID) and (Item = FieldValues['Item']) then
      begin
        isFound := true;
        iGoalID := FieldValues['GoalID'];
      end else Next;
    until EOF or isFound;
    Close;
  end;
  GoalID := iGoalID;
end;

procedure TGoal.GetGoalDate;
var isFound : Boolean;
begin
  isFound := False;
  with dmData.tblGoals do
  begin
    Open;
    First;
    repeat
      if (GoalID = FieldValues['GoalID']) then
      begin
        isFound := true;
      end else next;
    until EOF or isFound;
    if isFound then
      StartDate := FieldValues['StartDate'];
    Close;
  end;
end;

function TGoal.GetProgress;
var
  iGoalID : Integer;
  isFound : Boolean;
  rValue : Real;
begin
  rValue := 0;
  iGoalID := GoalID;
  isFound := false;
  with dmData.tblProgress do
  begin
    Open;
    First;
    repeat
      if (FieldValues['GoalID'] = iGoalID) and (pRecDate = FieldValues['DateRecorded']) then
      begin
        isFound := True;
        rValue := FieldValues['Amount'];
      end else Next;
    until EOF or isFound;
    Close;
  end;
  Result := rValue;
end;

function TGoal.GetDesc: string;
var
  sDesc : String;
  isFound : Boolean;
begin
  sDesc := '';
  isFound := False;
  with dmData.tblGoals do
  begin
    Open;
    First;
    repeat
      if (UserID = FieldValues['UserID']) and (GoalID = FieldValues['GoalID']) then
      begin
        isFound := true;
        sDesc := FieldValues['Desc'];
      end else Next;
    until EOF or isFound;
    Close;
  end;
  Result := sDesc;
end;

procedure TGoal.EditDesc(pDesc: string);
var isFound : Boolean;
begin
  isFound := False;
  with dmData.tblGoals do
  begin
    Open;
    First;
    repeat
      if (UserID = FieldValues['UserID']) and (GoalID = FieldValues['GoalID']) then
      begin
        isFound := true;
        Edit;
        FieldValues['Desc'] := pDesc;
        Post;
      end else Next;
    until EOF or isFound;
    Close;
  end;
end;
{$ENDREGION}

{ Calculations }
{$REGION Calculations}
function TGoal.GetTotalDays: Integer;
begin
  Result := Round(Date - StartDate);
end;

function TGoal.CalcAverage: Real;
var
  rTotalVal : real;
  iNumDays : Integer;
begin
  iNumDays := GetTotalDays;
  rTotalVal := 0;
  with dmData.tblProgress do
  begin
    Open;
    First;
    repeat
      if (GoalID = FieldValues['GoalID']) then
      begin
        rTotalVal := rTotalVal + FieldValues['Amount'];
      end;
      Next;
    until Eof;
    Close;
  end;

  //Avoid dividing by zero on first day goals
  if iNumDays = 0 then
    Result := rTotalVal
  else
    Result := rTotalVal/iNumDays;
end;

function TGoal.CalcDaysAchieved: Integer;
var
  rAmount : Real;
  iDays : Integer;
begin
  iDays := 0;
  with dmData.tblProgress do
  begin
    Open;
    First;
    repeat
      if (GoalID = FieldValues['GoalID']) then
      begin
        rAmount := FieldValues['Amount'];
        if rAmount >= Target then
          inc(iDays);
      end;
      Next;
    until EOF;
    Close;
  end;
  Result := iDays;
end;
{$ENDREGION}

end.
