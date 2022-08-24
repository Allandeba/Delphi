unit uCriptografador;

interface

uses
  uCriptografia;

type
  ICriptografador = interface(IInterface)
  ['{8445B9AC-306F-4BB1-9224-C5287261410D}']
    function Encrypt: String;
    function Decrypt: String;
  end;

  TCriptografador = class(TInterfacedObject, ICriptografador)
  strict private
    FToken: String;
    FPassword: String;
    FMessage: String;

    function GetPassword: String;
  public
    constructor Create(_ACriptografia: TCriptografia);
    class function New(_ACriptografia: TCriptografia): ICriptografador;

    function Encrypt: String;
    function Decrypt: String;
  end;

implementation

uses
  System.SysUtils, uTPLb_CryptographicLibrary, uTPLb_Codec, uFrameworkConsts;

{ TCriptografia }

class function TCriptografador.New(_ACriptografia: TCriptografia): ICriptografador;
begin
  Result := Self.Create(_ACriptografia);
end;

constructor TCriptografador.Create(_ACriptografia: TCriptografia);
begin
  FToken := _ACriptografia.Token;
  FPassword := _ACriptografia.Password;
  FMessage := _ACriptografia.Message;
end;

function TCriptografador.Decrypt: String;
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
      Codec.BlockCipherId := BLOCKCIPHERID; //Encriptação AES 256 bits
      Codec.ChainModeId := CHAINMODEID;

      Codec.Reset;
      Codec.Password := GetPassword; //Atribuindo a chave para Decriptografia
      Codec.DecryptString(Result, Trim(FMessage), TEncoding.UTF8);
    finally
      FreeAndNil(Codec);
    end;
  finally
    FreeAndNil(CryptoLib);
  end;
end;

function TCriptografador.Encrypt: String;
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
      Codec.BlockCipherId := BLOCKCIPHERID; //Encriptação AES 256 bits
      Codec.ChainModeId := CHAINMODEID;

      Codec.Reset;
      Codec.Password := GetPassword; //Atribuindo a chave para a Criptografia
      Codec.EncryptString(FMessage, Result, TEncoding.UTF8);
    finally
      FreeAndNil(Codec);
    end;
  finally
    FreeAndNil(CryptoLib);
  end;
end;

function TCriptografador.GetPassword: String;
var
  AMiddlePOSToken: Integer;
begin
  AMiddlePOSToken := Trunc(Length(FToken) / 2);
  Insert(FPassword, FToken, AMiddlePOSToken);

  Result := FToken;
end;

end.

