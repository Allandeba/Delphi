unit uCriptographyTest;

interface

uses
  DUnitX.TestFramework, System.Classes, System.SysUtils;

const
  TOKEN = '6lF36$F!2*&2';
  MESSAGE_TO_ENCRYPT_DECRYPT = 'This is my secret password, nobody must know.';
  PASSWORD = '@nyCompetentPasswordT0Us3';

type
  [TestFixture]
  TCriptographyTest = class
  private
    procedure SaveTokenToFile(_AEncryptedMessage: String);
    procedure EncryptFile;
    procedure DeleteTokenFile;
    function DecryptFile: String;
    function GetTokenFilePath: String;
    function LoadTokenFromFile: String;
  public
    [Test]
    procedure ProcessCriptographyTest;

  end;

implementation

uses
  VCL.Forms, uFrameworkConsts, uCryptography, uCryptographer;

{ TCriptographyTest }

function TCriptographyTest.GetTokenFilePath: String;
begin
  Result := ExtractFilePath(Application.ExeName) + '/token.txt';
end;

function TCriptographyTest.LoadTokenFromFile: String;
var
  AStringList: TStringList;
begin
  AStringList := TStringList.Create;
  try
    AStringList.LoadFromFile(GetTokenFilePath);
    Result := AStringList.Values[TOKEN_PARAM];
    Result := Result;
  finally
    AStringList.Free;
  end;
end;

procedure TCriptographyTest.ProcessCriptographyTest;
begin
  Assert.WillNotRaise(
    procedure
    begin
      EncryptFile;
      DecryptFile;
      DeleteTokenFile;
    end
  );
end;

procedure TCriptographyTest.SaveTokenToFile(_AEncryptedMessage: String);
var
  AStringList: TStringList;
begin
  AStringList := TStringList.Create;
  try
    AStringList.AddPair(TOKEN_PARAM, _AEncryptedMessage);
    AStringList.SaveToFile(GetTokenFilePath);
  finally
    AStringList.Free;
  end;
end;

procedure TCriptographyTest.DeleteTokenFile;
begin
  DeleteFile(GetTokenFilePath);
end;

procedure TCriptographyTest.EncryptFile;
var
  ACryptography: TCryptography;
  AEncryptedMessage: String;
begin
  ACryptography := TCryptography.Create;
  try
    ACryptography.Token := TOKEN;
    ACryptography.Password := PASSWORD;
    ACryptography.Message := MESSAGE_TO_ENCRYPT_DECRYPT;

    AEncryptedMessage := TCryptographer.New(ACryptography).Encrypt;
    SaveTokenToFile(AEncryptedMessage);
  finally
    ACryptography.Free;
  end;
end;

function TCriptographyTest.DecryptFile: String;
var
  ACryptography: TCryptography;
begin
  ACryptography := TCryptography.Create;
  try
    ACryptography.Token := TOKEN;
    ACryptography.Password := PASSWORD;
    ACryptography.Message := LoadTokenFromFile;

    try
      Result := TCryptographer.New(ACryptography).Decrypt;
    except
      on E: Exception do
        raise Exception.Create('Can not decryptograph file.' + sLineBreak + 'DecryptFile' + sLineBreak + E.Message);
    end;
  finally
    ACryptography.Free;
  end;
end;

initialization
  TDUnitX.RegisterTestFixture(TCriptographyTest);

end.
