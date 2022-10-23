unit uADLabeledEdit;

interface

uses
  System.SysUtils, System.Classes, Vcl.Controls, Vcl.StdCtrls, Vcl.ExtCtrls, uADCustomPanelNoCaption;

type
  TADLabeledEdit = class(TADCustomPanelNoCaption)
  private
    FEdit: TEdit;
    procedure ConfigureEdit;
    function GetText: String;
    procedure SetText(_Text: String);
  public
    constructor Create(_Owner: TComponent); override;
  published
    property Text: String read GetText write SetText;
    property TabOrder;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Allan Debastiani', [TADLabeledEdit]);
end;

{ TADLabeledEdit }

procedure TADLabeledEdit.ConfigureEdit;
begin
  FEdit := TEdit.Create(Self);
  FEdit.Parent := Self;
  FEdit.Left := 0;
  FEdit.Alignment := taLeftJustify;
  FEdit.Align := alClient;
end;

constructor TADLabeledEdit.Create(_Owner: TComponent);
begin
  inherited;
  ConfigureEdit;
end;


function TADLabeledEdit.GetText: String;
begin
  Result := FEdit.Text;
end;

procedure TADLabeledEdit.SetText(_Text: String);
begin
  FEdit.Text := _Text;
end;

end.
