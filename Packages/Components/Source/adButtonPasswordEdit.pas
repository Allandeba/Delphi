unit adButtonPasswordEdit;

interface

uses
  System.SysUtils, System.Classes, Vcl.Controls, cxControls, cxContainer,
  cxEdit, cxTextEdit, cxMaskEdit, cxButtonEdit;

type
  TADButtonPasswordEdit = class(TcxButtonEdit)
  private
    procedure DoOnButtonClick(_ASender: TObject; _AButtonIndex: Integer);
    procedure DoOnMouseLeave(_ASender: TObject);

    procedure SetPasswordType;
  public
    constructor Create(AOwner: TComponent); override;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Allan Debastiani', [TADButtonPasswordEdit]);
end;

constructor TADButtonPasswordEdit.Create(AOwner: TComponent);
var
  AButton: TcxEditButton;
begin
  inherited;

  Properties.Buttons.Clear;
  AButton := Properties.Buttons.Add;
  AButton.Caption := 'Mostrar senha';
  AButton.Kind := bkText;
  SetPasswordType;
  Properties.OnButtonClick := DoOnButtonClick;

  OnMouseLeave := DoOnMouseLeave;
end;

procedure TADButtonPasswordEdit.DoOnButtonClick(_ASender: TObject; _AButtonIndex: Integer);
begin
  Properties.PasswordChar := '#';
  Properties.EchoMode := eemNormal;
end;

procedure TADButtonPasswordEdit.DoOnMouseLeave(_ASender: TObject);
begin
  SetPasswordType;
end;

procedure TADButtonPasswordEdit.SetPasswordType;
begin
  Properties.PasswordChar := '*';
  Properties.EchoMode := eemPassword;
end;

end.
