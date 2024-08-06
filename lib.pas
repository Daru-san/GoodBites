unit lib;

interface

uses system.SysUtils,dmBase, Vcl.Dialogs;

type
  TLib = class(Tobject);
  procedure CheckFile(filename:string);
  function CheckPass(userString: string; passString: string; filename: string): boolean;
  function ValidPass(userString,passString:string): boolean;

implementation

procedure CheckFile(filename: string);
begin
  if not FileExists(filename) then
  begin
    ShowMessage('The passwords file does not exist');
    exit;
  end;
end;

function ValidPass(userString,passString: string):boolean;
var
  isValid : boolean;
begin
  {TODO: Do other validation checks,
  i.e username length and password length, also password characters}

  if (userString = '') then
  begin
    ShowMessage('Please enter a username');
    isValid := false;
  end
    else
  if (passString = '') then
  begin
    ShowMessage('Please enter a valid password');
    isValid := false;
  end
   else
    isValid := true;
end;

function CheckPass(userString: string; passString: string; filename: string): boolean;
var
  passFile : textfile;
  fileString, userFileString, userPassString, userInDatabase : string;
  isCorrect, isInDB, isFound : boolean;
  delPos : integer;
begin
  AssignFile(passFile,filename);
  CheckFile(filename);
  Reset(passFile);

  isCorrect := false;
  isInDB := false;
  isFound := false;

  repeat
    ReadLn(passFile,fileString);
    delPos := pos(',',fileString);
    userFileString := copy(fileString,0,delPos);
    delete(fileString,0,delPos);
    userPassString := fileString;
    if ((userFileString = userString) and (userPassString = passString)) then
      isCorrect := true
      else isCorrect := false;
  until EOF(passFile);

  if isCorrect then
  with dmBase.dmData do
  begin
    tblUsers.Append;
    tblUsers.First;
    Repeat
      if tblUsers['Username'] = userString then
      begin
        isInDB := true;
        isFound := true;
      end;
      tblUsers.Next;
    Until tblUsers.eof or isFound;
  end;
  if not isInDB then
  begin
    ShowMessage(
          'The user ' + userString
          + ' has a password but is not present in the database'
          + #13 + 'Are you sure they are registered?'
    );
    ShowMessage(IsInDB.ToString + uSERsTRING + passString);
    isCorrect := false;
  end;
  CheckPass := isCorrect;
end;

end.
