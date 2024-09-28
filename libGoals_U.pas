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
    public
      property GoalID : Integer read FGoalID write FGoalID;
      property UserID : String read FUserID write FUserID;
      property GoalUnit : String read FGoalUnit write FGoalUnit;
      property Item : String read FItem write FItem;
      property StartDate : TDate read FStartDate write FStartDate;
      property Target : Real read FTarget write FTarget;

      constructor Create(U,I : String);
      destructor Destroy; override;

      function GetDesc : String;
      // Progress
      procedure SetProgress(rAmount : Real);
      function GetProgress(RecDate : TDate) : Real;

      function CalcAverage : Real;
      function CalcDaysAchieved : Integer;
      function GetTotalDays : Integer;
      procedure SetGoalTarget;
      procedure AddGoal;
      procedure GetGoalTarget;
      procedure EditDesc(S: String);
  end;

implementation

constructor TGoal.Create;
begin
  UserID := U;
  Item := I;
  GetGoalTarget;
  GetGoalID;
end;

destructor TGoal.Destroy;
begin

end;
{ Goals }

{$REGION Goals }
procedure TGoal.SetProgress(rAmount: Real);
var
  dDate : TDate;
  iGoalID : Integer;
  isFound,isProgFound : Boolean;
begin
  isFound := False;
  isProgFound := False;
  with dmData.tblGoals do
  begin
    Open;
    First;
    repeat
      if FieldValues['UserID'] = UserID then
      begin
        if Item = FieldValues['Valuename'] then
        begin
          iGoalID := FieldValues['GoalID'];
          with dmData.tblProgress do
          begin
            Open;
            First;
            repeat
              if iGoalID = FieldValues['GoalID'] then
              begin
                isProgFound := true;
                Edit;
                FieldValues['Amount'] := FieldValues['Amount'] + rAmount;
                Post;
              end  else Next;
            until EOF or isProgFound;
            if not isProgFound then
            begin
              Append;
              FieldValues['Amount'] := rAmount;
              FieldValues['DateRecorded'] := Date;
              Post;
            end;
            Close;
          end;    // End tblProgress
        end;  // End if sItem
      end;    // End if UserID
    until EOF or isFound;
    Close;
  end;  //End tblGoals
end;

procedure TGoal.AddGoal;
begin
end;

procedure TGoal.SetGoalTarget;
var isFound : Boolean;
begin
  with dmData.tblGoals do
  begin
    Open;
    First;
    repeat
      if UserID = FieldValues['UserID'] and (GoalID = FieldValues['GoalID']) then
      begin
        isFound := true;
        Edit;
        FieldValues['Target'] := Target;
        Post;
      end;
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
  with dmData.tblGoals do
  begin
    Open;
    First;
    repeat
      if (UserID = FieldValues['UserID']) and (Item = FieldValues['Item']) then
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
      if (FieldValues['UserID'] = UserID) and (Item = FieldValues['Valuename']) then
      begin
        isFound := true;
        iGoalID := FieldValues['GoalID'];
      end else Next;
    until EOF or isFound;
    Close;
  end;
  GoalID := iGoalID;
end;

function TGoal.GetProgress;
var
  iGoalID : Integer;
  isFound : Boolean;
  rValue : Real;
begin
  rValue := 0;
  iGoalID := GetGoalID;
  with dmData.tblProgress do
  begin
    Open;
    First;
    repeat
      if (FieldValues['GoalID'] = iGoalID) and (RecDate = FieldValues['DateRecorded']) then
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
      end;
    until EOF or isFound;
    Close;
  end;
  Result := sDesc;
end;
procedure TGoal.EditDesc(S: string);
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
        FieldValues['Desc'] := S;
        Post;
      end;
    until EOF or isFound;
    Close;
  end;
end;
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
        rTotalVal := rTotalVal + FieldValues['Value'];
      end;
      Next;
    until Eof;
    Close;
  end;
  Result := rTotalVal/iNumDays;
end;
function TGoal.CalcDaysAchieved: Integer;
var
  rTarget, rAmount : Real;
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
        if rAmount >= rTarget then
          inc(iDays);
      end;
      Next;
    until EOF;
    Close;
  end;
  Result := iDays;
end;
end.
