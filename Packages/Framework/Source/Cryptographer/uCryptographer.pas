unit uCryptographer;

interface

uses
  uCryptography;

type
  ICryptographer = interface(IInterface)
  ['{8445B9AC-306F-4BB1-9224-C5287261410D}']
    function Encrypt: String;
    function Decrypt: String;
  end;

  TCryptographer = class(TInterfacedObject, ICryptographer)
  strict private
    FToken: String;
    FPassword: String;
    FMessage: String;

    function GetPassword: String;
  public
    constructor Create(_Cryptography: TCryptography);
    class function New(_Cryptography: TCryptography): ICryptographer;

    function Encrypt: String;
    function Decrypt: String;
  end;

implementation

uses
  System.SysUtils, uTPLb_CryptographicLibrary, uTPLb_Codec, uFrameworkConsts;

{ TCryptography }

class function TCryptographer.New(_Cryptography: TCryptography): ICryptographer;
begin
  Result := Self.Create(_Cryptography);
end;

constructor TCryptographer.Create(_Cryptography: TCryptography);
begin
  FToken := _Cryptography.Token;
  FPassword := _Cryptography.Password;
  FMessage := _Cryptography.Message;
end;

function TCryptographer.Decrypt: String;
var
  CryptoLib: TCryptographicLibrary;
  Codec: TCodec;
begin
  Result := '';

  CryptoLib := TCryptographicLibrary.Create(nil);
  try
    Codec := TCodec.Create(nil);
    try
      Codec.CryptoLibrary := CryptoLib;
      Codec.StreamCipherId := STREAMCIPHERID;
      Codec.BlockCipherId := BLOCKCIPHERID; // Encrypt with AES 256 bits
      Codec.ChainModeId := CHAINMODEID;

      Codec.Reset;
      Codec.Password := GetPassword; // Attachment key to decrypt
      Codec.DecryptString(Result, Trim(FMessage), TEncoding.UTF8);
    finally
      FreeAndNil(Codec);
    end;
  finally
    FreeAndNil(CryptoLib);
  end;
end;

function TCryptographer.Encrypt: String;
var
  CryptoLib: TCryptographicLibrary;
  Codec: TCodec;
begin
  CryptoLib := TCryptographicLibrary.Create(nil);
  try
    Codec := TCodec.Create(nil);
    try
      Codec.CryptoLibrary := CryptoLib;
      Codec.StreamCipherId := STREAMCIPHERID;
      Codec.BlockCipherId := BLOCKCIPHERID; // Encrypt with AES 256 bits
      Codec.ChainModeId := CHAINMODEID;

      Codec.Reset;
      Codec.Password := GetPassword; // Attachment key to decrypt
      Codec.EncryptString(FMessage, Result, TEncoding.UTF8);
    finally
      FreeAndNil(Codec);
    end;
  finally
    FreeAndNil(CryptoLib);
  end;
end;

function TCryptographer.GetPassword: String;
var
  AMiddlePOSToken: Integer;
begin
  AMiddlePOSToken := Trunc(Length(FToken) / 2);
  Insert(FPassword, FToken, AMiddlePOSToken);

  Result := FToken;
end;

end.

