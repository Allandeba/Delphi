unit uADComboBox;

interface

uses
  System.SysUtils, System.Classes, Vcl.Controls, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TADComboBox = class(TCustomPanel)
  strict private
    FInnerLabelCaption: TLabel;
    FLabelPanel: TPanel;
    FComboBox: TComboBox;

    procedure ConfigureMainPanel(_Owner: TComponent);
    procedure ConfigureLabelPanel;
    procedure ConfigureLabelCaption;
    procedure ConfigureComboBox;

    function GetLabelCaption: TCaption;
    procedure SetLabelCaption(_Caption: TCaption);
  public
      constructor Create(_Owner: TComponent); override;
  published
    property ComboBox: TComboBox read FComboBox;
    property LabelCaption: TCaption read GetLabelCaption write SetLabelCaption;
  end;

procedure Register;

implementation

uses
  Vcl.Forms;

procedure Register;
begin
  RegisterComponents('Allan Debastiani', [TADComboBox]);
end;

{ TADComboBox }

procedure TADComboBox.ConfigureComboBox;
begin
  FComboBox := TComboBox.Create(Self);
  FComboBox.Parent := Self;
  FComboBox.Align := alClient;
end;

procedure TADComboBox.ConfigureLabelCaption;
begin
  FInnerLabelCaption := TLabel.Create(FLabelPanel);
  FInnerLabelCaption.Parent := FLabelPanel;
  FInnerLabelCaption.Caption := 'TADComboBox';
  FInnerLabelCaption.Align := alTop;
  FInnerLabelCaption.Alignment := taLeftJustify;
end;

procedure TADComboBox.ConfigureLabelPanel;
begin
  FLabelPanel := TPanel.Create(Self);
  FLabelPanel.Height := 20;
  FLabelPanel.Left := 0;
  FLabelPanel.BevelOuter := bvNone;
  FLabelPanel.BorderStyle := bsNone;
  FLabelPanel.Parent := Self;
  FLabelPanel.Align := alTop;
end;

procedure TADComboBox.ConfigureMainPanel(_Owner: TComponent);
begin
  Height := 45;
  Width := 150;
  Left := 10;
  BevelOuter := bvNone;
  BorderStyle := bsNone;
  Caption := '';
  ShowCaption := False;
end;

constructor TADComboBox.Create(_Owner: TComponent);
begin
  inherited;
  ConfigureMainPanel(_Owner);
  ConfigureLabelPanel;
  ConfigureLabelCaption;
  ConfigureComboBox;
end;

function TADComboBox.GetLabelCaption: TCaption;
begin
  Result := FInnerLabelCaption.Caption;
end;

procedure TADComboBox.SetLabelCaption(_Caption: TCaption);
begin
  FInnerLabelCaption.Caption := _Caption;
end;

end.
