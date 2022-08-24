unit uFrameworkView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Generics.Collections, uProcessParameters;

type
  TFrameworkView = class(TForm)
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  strict private
    FProcessParameters: TProcessParameters;
    FCanClose: Boolean;

    procedure DoOnClose(_ASender: TObject; var _AAction: TCloseAction);
    procedure DoOnExceptionApplication(_ASender: TObject; _AE: Exception);
  protected
    property ParametrosProcesso: TProcessParameters read FProcessParameters;
    property CanClose: Boolean read FCanClose write FCanClose;

    procedure PrepareComponents; virtual;
    procedure PrepareEvents; virtual;
    procedure AddNamesValues<T>(_AComboBoxItems: TStrings); overload;
    procedure AddNamesValues(_AComboBoxItems: TStrings; _AListaValores: TArray<String>); overload;
  public
    constructor Create(_AOwner: TComponent); reintroduce; overload; override;
    constructor Create(_AOwner: TComponent; _AParametrosProcesso: TProcessParameters); reintroduce; overload;
  end;

implementation

uses
  TypInfo, uFrameworkMessages, uFrameworkMessage;

{$R *.dfm}

{ TFrameworkView }

procedure TFrameworkView.AddNamesValues(_AComboBoxItems: TStrings; _AListaValores: TArray<String>);
var
  AValor: String;
begin
  _AComboBoxItems.BeginUpdate;
  try
    _AComboBoxItems.Clear;

    for AValor in _AListaValores do
      _AComboBoxItems.Add(AValor);

  finally
    _AComboBoxItems.EndUpdate;
  end;
end;

procedure TFrameworkView.AddNamesValues<T>(_AComboBoxItems: TStrings);
var
  I: Integer;
  AEnumName: String;
  AEnumValue: Integer;
begin
  I := 0;
  _AComboBoxItems.BeginUpdate;
  try
    _AComboBoxItems.Clear;

    repeat
      AEnumName := GetEnumName(TypeInfo(T), I);
      AEnumValue := GetEnumValue(TypeInfo(T), AEnumName);

      if AEnumValue <> -1 then
        _AComboBoxItems.Add(AEnumName);

      Inc(I);

    until AEnumValue < 0;
  finally
    _AComboBoxItems.EndUpdate;
  end;
end;

constructor TFrameworkView.Create(_AOwner: TComponent; _AParametrosProcesso: TProcessParameters);
begin
  inherited Create(_AOwner);
  FProcessParameters := _AParametrosProcesso;

  Position := poMainFormCenter;
  FormStyle := fsNormal;
  PrepareComponents;
end;

constructor TFrameworkView.Create(_AOwner: TComponent);
begin
  inherited Create(_AOwner);

  Position := poMainFormCenter;
  FormStyle := fsNormal;
  PrepareComponents;
  PrepareEvents;
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

procedure TFrameworkView.DoOnClose(_ASender: TObject; var _AAction: TCloseAction);
begin
  if not FCanClose then
    Abort;

  inherited;
end;

procedure TFrameworkView.DoOnExceptionApplication(_ASender: TObject; _AE: Exception);
begin
  TMessageView.New(FMSG_0002).Detail(_AE.Message).Error.Show;
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
