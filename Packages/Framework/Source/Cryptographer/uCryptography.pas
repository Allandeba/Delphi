unit uCryptography;

interface

type
  TCryptography = class
  private
    FToken: String;
    FPassword: String;
    FMessage: String;
  public
    property Token: String read FToken write FToken;
    property Password: String read FPassword write FPassword;
    property &Message: String read FMessage write FMessage;
  end;

implementation

end.
