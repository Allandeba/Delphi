unit uInfraMensagem;

interface

uses
  System.UITypes, System.Generics.Collections, uFrameworkEnums;

type
  IInfraMensagemView = interface
  ['{D1E0111A-749C-4F06-A0C4-8F0D6862D885}']
    function Args(_AArgs: TArray<String>): IInfraMensagemView;
    function Botoes(_ABotoes: TDictionary<String, TModalResult>): IInfraMensagemView;
    function ShowResult: TModalResult;
    function Warning: IInfraMensagemView;
    function Success: IInfraMensagemView;
    function Error: IInfraMensagemView;
    function Dev: IInfraMensagemView;
    function Detail(_ADetail: String): IInfraMensagemView;

    procedure Show;
    procedure ShowAndAbort;
  end;

  TMensagemView = class(TInterfacedObject, IInfraMensagemView)
  strict private
    FMensagem: String;
    FBotoes: TDictionary<String, TModalResult>;
    FTipoIconeMensagem: TMessageIconType;
    FDetail: String;
  public
    constructor Create(_AMensagem: String);
    destructor Destroy; override;

    function Args(_AArgs: TArray<String>): IInfraMensagemView;
    function Botoes(_ABotoes: TDictionary<String, TModalResult>): IInfraMensagemView;
    function ShowResult: TModalResult;
    function Warning: IInfraMensagemView;
    function Success: IInfraMensagemView;
    function Error: IInfraMensagemView;
    function Dev: IInfraMensagemView;
    function Detail(_ADetail: String): IInfraMensagemView;

    procedure Show;
    procedure ShowAndAbort;

    class function New(_AMensagem: String): IInfraMensagemView;
  end;

implementation

uses
  uFrameworkMessageView, SysUtils;

{ TMensagemView }

function TMensagemView.Args(_AArgs: TArray<String>): IInfraMensagemView;
var
  I: Integer;
begin
  for I := Low(_AArgs) to High(_AArgs) do
    FMensagem := FMensagem.Replace('%s', _AArgs[I]);

  Result := Self;
end;

function TMensagemView.Botoes(_ABotoes: TDictionary<String, TModalResult>): IInfraMensagemView;
var
  I: Integer;
  AButton: TArray<String>;
  APair: TPair<String, TModalResult>;
begin
  AButton := _ABotoes.Keys.ToArray;

  for I := 0 to _ABotoes.Count - 1 do
  begin
    APair := _ABotoes.ExtractPair(AButton[I]);
    FBotoes.Add(APair.Key, APair.Value);
  end;

  Result := Self;
end;

constructor TMensagemView.Create(_AMensagem: String);
begin
  inherited Create;
  FBotoes := TDictionary<String, TModalResult>.Create;
  FMensagem := _AMensagem;
  FTipoIconeMensagem := timWarning;
end;

destructor TMensagemView.Destroy;
begin
  FBotoes.Free;
  inherited;
end;

function TMensagemView.Detail(_ADetail: String): IInfraMensagemView;
begin
  FDetail := _ADetail;
  Result := Self;
end;

function TMensagemView.Dev: IInfraMensagemView;
begin
  FTipoIconeMensagem := timDev;
  Result := Self;
end;

function TMensagemView.Error: IInfraMensagemView;
begin
  FTipoIconeMensagem := timError;
  Result := Self;
end;

class function TMensagemView.New(_AMensagem: String): IInfraMensagemView;
begin
  Result := Self.Create(_AMensagem);
end;

procedure TMensagemView.Show;
begin
  ShowResult;
end;

procedure TMensagemView.ShowAndAbort;
begin
  Show;
  Abort;
end;

function TMensagemView.ShowResult: TModalResult;
var
  AFrameworkMessageView: TFrameworkMessageView;
begin
  AFrameworkMessageView := TFrameworkMessageView.CreateMsg(FMensagem, FBotoes, FTipoIconeMensagem, FDetail);
  try
    Result := AFrameworkMessageView.ShowModal;
  finally
    AFrameworkMessageView.Free;
  end;
end;

function TMensagemView.Success: IInfraMensagemView;
begin
  FTipoIconeMensagem := timSuccess;
  Result := Self;
end;

function TMensagemView.Warning: IInfraMensagemView;
begin
  FTipoIconeMensagem := timWarning;
  Result := Self;
end;

end.
