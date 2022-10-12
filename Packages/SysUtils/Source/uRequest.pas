unit uRequest;

interface

uses
  Generics.Collections, IdHTTP, NetEncoding, IdSSLOpenSSL, System.Classes;

type
  TRequestOperation = ({roHead, }roGet, roPost, {roOptions, roTrace, roPut, }roDelete{, roConnect, roPatch});
  TContentType = (ctNone, ctJSON);

  IRequest<T> = interface(IInterface)
    ['{50AED51B-146A-4D93-81E4-A2E04C8B93CF}']
    function New(_UrlRequest: String): IRequest<T>;
    function AddParams(_Parametros: TStringList): IRequest<T>;
    function Authorization(_Token: String): IRequest<T>;
    function ContentType(_ContentType: TContentType): IRequest<T>;
    function RequestType(_RequestType: TRequestOperation): IRequest<T>;
    function DoRequest(_Stream: TStream = nil): String;
  end;

  TRequest<T> = class(TInterfacedObject, IRequest<T>)
  strict private const
    USER_AGENT = 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.60 Mobile Safari/537.36';
  strict private
    FIdHTTP: TIdHTTP;
    FIdSSLIOHandlerSocketOpenSSL: TIdSSLIOHandlerSocketOpenSSL;
    FUrlRequest: String;
    FParametros: TStringList;
    FRequestType: TRequestOperation;
    FContentType: TContentType;

    procedure ValidarRequest;
    procedure SetContentType;

    function GetRequest(_Stream: TStream = nil): String;
    function PostRequest: String;
    function DeleteRequest: String;
  public
    constructor Create;
    destructor Destroy; override;

    function New(_UrlRequest: String): IRequest<T>;
    function AddParams(_Parametros: TStringList): IRequest<T>;
    function Authorization(_Token: String): IRequest<T>;
    function ContentType(_ContentType: TContentType): IRequest<T>;
    function RequestType(_RequestType: TRequestOperation): IRequest<T>;
    function DoRequest(_Stream: TStream = nil): String;
  end;

implementation

uses
  System.SysUtils, JSON, uClassUtils;

{ TRequest }

function TRequest<T>.AddParams(_Parametros: TStringList): IRequest<T>;
begin
  FParametros := _Parametros.Clone as TStringList;
  Result := Self;
end;

function TRequest<T>.Authorization(_Token: String): IRequest<T>;
begin
  FIdHTTP.Request.CustomHeaders.AddValue('Authorization', _Token);
  Result := Self;
end;

function TRequest<T>.PostRequest: String;
begin
  if (FParametros = nil) or (FParametros.Count = 0) then
    raise Exception.Create('FParametros = nil or FParametros.Count = 0');

  try
    Result := FIdHTTP.Post(FUrlRequest, FParametros);
  except
    raise;
  end;
end;

function TRequest<T>.RequestType(_RequestType: TRequestOperation): IRequest<T>;
begin
  FRequestType := _RequestType;
  Result := Self;
end;

procedure TRequest<T>.SetContentType;
begin
  case FContentType of
    ctNone: ;

    ctJSON:
      FIdHTTP.Request.CustomHeaders.AddValue('Content-Type', 'application/json');
  else
    raise Exception.Create('Not implemented');
  end;
end;

procedure TRequest<T>.ValidarRequest;
begin
  if FUrlRequest = '' then
    raise Exception.Create('URL is empty: TRequest.Get');
end;

function TRequest<T>.ContentType(_ContentType: TContentType): IRequest<T>;
begin
  FContentType := _ContentType;
  Result := Self;
end;

constructor TRequest<T>.Create;
begin
  FIdHTTP := TIdHTTP.Create;

  FIdSSLIOHandlerSocketOpenSSL := TIdSSLIOHandlerSocketOpenSSL.Create;
  FIdSSLIOHandlerSocketOpenSSL.SSLOptions.Method := sslvSSLv23;
  FIdSSLIOHandlerSocketOpenSSL.SSLOptions.SSLVersions := [sslvTLSv1_2, sslvTLSv1_1, sslvTLSv1];

  FRequestType := roGet;
  FUrlRequest := EmptyStr;
  FParametros := nil;
  FContentType := ctNone;
end;

function TRequest<T>.DeleteRequest: String;
begin
  try
    if (FParametros <> nil) and (FParametros.Count > 0) then
      raise Exception.Create('Para Delete com Parametros, utilizar TRequest<T>.Post');

    Result := FIdHTTP.Delete(FUrlRequest);
  except
    raise;
  end;
end;

destructor TRequest<T>.Destroy;
begin
  FIdSSLIOHandlerSocketOpenSSL.Free;
  FIdHTTP.Free;
  FParametros.Free;
  inherited;
end;

function TRequest<T>.DoRequest(_Stream: TStream): String;
begin
  ValidarRequest;
  SetContentType;

  case FRequestType of
    roGet:
      Result := GetRequest(_Stream);

    roPost:
      Result := PostRequest;

    roDelete:
      Result := DeleteRequest;
  end;
end;

function TRequest<T>.GetRequest(_Stream: TStream): String;
begin
  Result := EmptyStr;
  try
    if _Stream = nil then
    begin
      if (FParametros <> nil) and (FParametros.Count > 0) then
        Result := FIdHTTP.Post(FUrlRequest, FParametros)
      else
        Result := FIdHTTP.Get(FUrlRequest)
    end
    else
    begin
      FIdHTTP.HandleRedirects := True;
      FIdHTTP.Get(FUrlRequest, _Stream);
    end;
  except
    raise;
  end;
end;

function TRequest<T>.New(_UrlRequest: String): IRequest<T>;
begin
  Result := inherited Create;

  FIdHTTP.Request.ContentEncoding := 'utf-8';
  FIdHTTP.Request.UserAgent := USER_AGENT;

  FIdHTTP.IOHandler := FIdSSLIOHandlerSocketOpenSSL;

  FUrlRequest := _UrlRequest;
end;

end.
