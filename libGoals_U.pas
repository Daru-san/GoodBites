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

      // Progress
      procedure SetProgress(rAmount : Real);
      function GetProgress(RecDate : TDate) : Real;

      procedure SetGoalTarget;
      procedure AddGoal;
      procedure GetGoalTarget;
  end;

implementation

constructor TGoal.Create;
begin
  UserID := U;
  Item := I;
  GetGoalTarget;
  GetGoalID;
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

end.
