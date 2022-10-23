unit uFrameworkView;

interface

uses
  Winapi.Windows, System.SysUtils, System.Classes, Vcl.Controls, Vcl.Forms,
  Generics.Collections, uProcessParameters;

type
  TFrameworkView = class(TForm)
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  strict private
    FProcessParameters: TProcessParameters;
    FCanClose: Boolean;

    procedure DoOnClose(_Sender: TObject; var _Action: TCloseAction);
    procedure DoOnExceptionApplication(_Sender: TObject; _E: Exception);

    procedure DefaultInitialization;
  protected
    property ParametrosProcesso: TProcessParameters read FProcessParameters;
    property CanClose: Boolean read FCanClose write FCanClose;

    procedure PrepareComponents; virtual;
    procedure PrepareEvents; virtual;
    procedure AddNamesValues<T>(_ComboBoxItems: TStrings); overload;
    procedure AddNamesValues(_ComboBoxItems: TStrings; _ListaValores: TArray<String>); overload;
  public
    constructor Create(_Owner: TComponent); reintroduce; overload; override;
    constructor Create(_Owner: TComponent; _ParametrosProcesso: TProcessParameters); reintroduce; overload;
  end;

implementation

uses
  TypInfo, uFrameworkMessages, uFrameworkMessage;

{$R *.dfm}

{ TFrameworkView }

procedure TFrameworkView.AddNamesValues(_ComboBoxItems: TStrings; _ListaValores: TArray<String>);
var
  AValor: String;
begin
  _ComboBoxItems.BeginUpdate;
  try
    _ComboBoxItems.Clear;

    for AValor in _ListaValores do
      _ComboBoxItems.Add(AValor);

  finally
    _ComboBoxItems.EndUpdate;
  end;
end;

procedure TFrameworkView.AddNamesValues<T>(_ComboBoxItems: TStrings);
var
  I: Integer;
  AEnumName: String;
  AEnumValue: Integer;
begin
  I := 0;
  _ComboBoxItems.BeginUpdate;
  try
    _ComboBoxItems.Clear;

    repeat
      AEnumName := GetEnumName(TypeInfo(T), I);
      AEnumValue := GetEnumValue(TypeInfo(T), AEnumName);

      if AEnumValue <> -1 then
        _ComboBoxItems.Add(AEnumName);

      Inc(I);

    until AEnumValue < 0;
  finally
    _ComboBoxItems.EndUpdate;
  end;
end;

constructor TFrameworkView.Create(_Owner: TComponent; _ParametrosProcesso: TProcessParameters);
begin
  inherited Create(_Owner);
  FProcessParameters := _ParametrosProcesso;

  DefaultInitialization;
end;

constructor TFrameworkView.Create(_Owner: TComponent);
begin
  inherited Create(_Owner);

  DefaultInitialization;
end;

procedure TFrameworkView.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    Close;

  {$IFDEF DEBUG}
  if Key = VK_F1 then
    TMessageView.New(Format(FMSG_0001, [Name])).Dev.Show;
  {$ENDIF}
end;

procedure TFrameworkView.DefaultInitialization;
begin
  Position := poMainFormCenter;
  FormStyle := fsNormal;
  PrepareComponents;
  PrepareEvents;
end;

procedure TFrameworkView.DoOnClose(_Sender: TObject; var _Action: TCloseAction);
begin
  if not FCanClose then
    Abort;

  inherited;
end;

procedure TFrameworkView.DoOnExceptionApplication(_Sender: TObject; _E: Exception);
begin
  TMessageView.New(FMSG_0002).Detail(_E.Message).Error.Show;
  inherited;
end;

procedure TFrameworkView.PrepareComponents;
begin
  KeyPreview := True;
  FCanClose := True;
end;

procedure TFrameworkView.PrepareEvents;
begin
  OnClose := DoOnClose;
  Application.OnException := DoOnExceptionApplication;
end;

end.
