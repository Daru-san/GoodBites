unit user;

interface

type
  TUser = class(TObject)
    private
      userName : string;
      userIsAdmin : boolean;
      LoggedIn : boolean;
    public
      constructor Create(userString : string;isAdmin,loginSuccessful:boolean);
      function GetAdmin : boolean;
      function GetUser : string;
      function CheckLogIn : boolean;
  end;

implementation

constructor TUser.Create;
begin
  userName := userString;
  userIsAdmin := isAdmin;
  LoggedIn := loginSuccessful;
end;

function TUser.GetAdmin;
begin
  result := userIsAdmin;
end;

function TUser.GetUser;
begin
  result := userName;
end;

function TUser.CheckLogin;
begin
  result := LoggedIn;
end;

end.
