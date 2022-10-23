unit uADCustomPanelNoCaption;

interface

uses
  System.SysUtils, System.Classes, Vcl.Controls, Vcl.ExtCtrls, VCLTee.TeeProcs,
  Vcl.StdCtrls;

type
  TADCustomPanelNoCaption = class(TCustomPanelNoCaption)
  private
    FInnerLabelCaption: TLabel;
    FLabelPanel: TPanel;

    procedure ConfigureMainPanel;
    procedure ConfigureLabelPanel;
    procedure ConfigureLabelCaption;

    function GetLabelCaption: TCaption;
    procedure SetLabelCaption(_Caption: TCaption);
  public
    constructor Create(_Owner: TComponent); override;
  published
    property LabelCaption: TCaption read GetLabelCaption write SetLabelCaption;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Allan Debastiani', [TADCustomPanelNoCaption]);
end;

{ TADCustomPanelNoCaption }

constructor TADCustomPanelNoCaption.Create(_Owner: TComponent);
begin
  inherited;
  ConfigureMainPanel;
  ConfigureLabelPanel;
  ConfigureLabelCaption;
end;

procedure TADCustomPanelNoCaption.ConfigureLabelCaption;
begin
  FInnerLabelCaption := TLabel.Create(FLabelPanel);
  FInnerLabelCaption.Parent := FLabelPanel;
  FInnerLabelCaption.Caption := 'ADLabelCaption';
  FInnerLabelCaption.Align := alTop;
  FInnerLabelCaption.Alignment := taLeftJustify;
  FInnerLabelCaption.Height := 15;
end;

procedure TADCustomPanelNoCaption.ConfigureLabelPanel;
begin
  FLabelPanel := TPanel.Create(Self);
  FLabelPanel.Parent := Self;
  FLabelPanel.Align := alTop;
  FLabelPanel.Height := 15;
  FLabelPanel.Left := 0;
  FLabelPanel.Top := 0;
  FLabelPanel.BevelKind := bkNone;
  FLabelPanel.BevelOuter := bvNone;
  FLabelPanel.BevelInner := bvNone;
end;

procedure TADCustomPanelNoCaption.ConfigureMainPanel;
begin
  Height := 40;
  Width := 150;
  Left := 0;
  Top := 0;
  BevelOuter := bvNone;
  BevelInner := bvNone;
  BevelKind := bkNone;
  Caption := '';
  ShowCaption := False;
end;

function TADCustomPanelNoCaption.GetLabelCaption: TCaption;
begin
  Result := FInnerLabelCaption.Caption;
end;

procedure TADCustomPanelNoCaption.SetLabelCaption(_Caption: TCaption);
begin
  FInnerLabelCaption.Caption := _Caption;
end;

end.
