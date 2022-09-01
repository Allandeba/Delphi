unit uFrameworkMessage;

interface

uses
  System.UITypes, System.Generics.Collections, uFrameworkEnums;

type
  TButtonAction = (baOk, baYesNo);

  TMessageViewResult = class
  private
    FTitle: String;
    FDetail: String;
  public
    property Title: String read FTitle write FTitle;
    property Detail: String read FDetail write FDetail;
  end;

  IMessageView = interface
  ['{D1E0111A-749C-4F06-A0C4-8F0D6862D885}']
    function Args(_AArgs: TArray<String>): IMessageView;
    function Buttons(_AButtonAction: TArray<TButtonAction>): IMessageView;
    function ShowResult: TModalResult;
    function Warning: IMessageView;
    function Success: IMessageView;
    function Error: IMessageView;
    function Dev: IMessageView;
    function Detail(_ADetail: String): IMessageView;
    function GetResult: TMessageViewResult;

    procedure Show;
    procedure ShowAndAbort;
  end;

  TMessageView = class(TInterfacedObject, IMessageView)
  strict private
    FMessage: String;
    FButtonAction: TArray<TButtonAction>;
    FMessageIconType: TMessageIconType;
    FDetail: String;
  public
    constructor Create(_AMessage: String);

    function Args(_AArgs: TArray<String>): IMessageView;
    function Buttons(_AButtonAction: TArray<TButtonAction>): IMessageView;
    function ShowResult: TModalResult;
    function Warning: IMessageView;
    function Success: IMessageView;
    function Error: IMessageView;
    function Dev: IMessageView;
    function Detail(_ADetail: String): IMessageView;
    function GetResult: TMessageViewResult;

    procedure Show;
    procedure ShowAndAbort;

    class function New(_AMessage: String): IMessageView;
  end;

implementation

uses
  SysUtils, uFrameworkMessageView;

{ TMessageView }

function TMessageView.Args(_AArgs: TArray<String>): IMessageView;
var
  I: Integer;
begin
  for I := Low(_AArgs) to High(_AArgs) do
    FMessage := StringReplace(FMessage, '%s', _AArgs[I], []);
  Result := Self;
end;

function TMessageView.Buttons(_AButtonAction: TArray<TButtonAction>): IMessageView;
begin
  FButtonAction := _AButtonAction;
  Result := Self;
end;

constructor TMessageView.Create(_AMessage: String);
begin
  inherited Create;
  FButtonAction := [baOk];
  FMessage := _AMessage;
  FMessageIconType := mitWarning;
end;

function TMessageView.Detail(_ADetail: String): IMessageView;
begin
  FDetail := _ADetail;
  Result := Self;
end;

function TMessageView.Dev: IMessageView;
begin
  FMessageIconType := mitDev;
  Result := Self;
end;

function TMessageView.Error: IMessageView;
begin
  FMessageIconType := mitError;
  Result := Self;
end;

function TMessageView.GetResult: TMessageViewResult;
var
  AFrameworkMessageView: TFrameworkMessageView;
begin
  AFrameworkMessageView := TFrameworkMessageView.CreateMsg(FMessage, FButtonAction, FMessageIconType, FDetail);
  try
    Result := AFrameworkMessageView.GetResult;
  finally
    AFrameworkMessageView.Free;
  end;
end;

class function TMessageView.New(_AMessage: String): IMessageView;
begin
  Result := Self.Create(_AMessage);
end;

procedure TMessageView.Show;
begin
  ShowResult;
end;

procedure TMessageView.ShowAndAbort;
begin
  Show;
  Abort;
end;

function TMessageView.ShowResult: TModalResult;
var
  AFrameworkMessageView: TFrameworkMessageView;
begin
  AFrameworkMessageView := TFrameworkMessageView.CreateMsg(FMessage, FButtonAction, FMessageIconType, FDetail);
  try
    Result := AFrameworkMessageView.ShowModal;
  finally
    AFrameworkMessageView.Free;
  end;
end;

function TMessageView.Success: IMessageView;
begin
  FMessageIconType := mitSuccess;
  Result := Self;
end;

function TMessageView.Warning: IMessageView;
begin
  FMessageIconType := mitWarning;
  Result := Self;
end;

end.
