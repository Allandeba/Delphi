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
    function GetOnKeyDown: TKeyEvent;
    procedure SetOnKeyDown(_KeyEvent: TKeyEvent);
    function GetOnChange: TNotifyEvent;
    procedure SetOnChange(_NotifyEvent: TNotifyEvent);
    function GetOnKeyPress: TKeyPressEvent;
    procedure SetOnKeyPress(_KeyPressEvent: TKeyPressEvent);
  public
      constructor Create(_Owner: TComponent); override;
  published
    property ComboBox: TComboBox read FComboBox;
    property LabelCaption: TCaption read GetLabelCaption write SetLabelCaption;

    property OnKeyDown: TKeyEvent read GetOnKeyDown write SetOnKeyDown;
    property OnKeyPress: TKeyPressEvent read GetOnKeyPress write SetOnKeyPress;
    property OnChange: TNotifyEvent read GetOnChange write SetOnChange;
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

function TADComboBox.GetOnChange: TNotifyEvent;
begin
  Result := FComboBox.OnChange;
end;

function TADComboBox.GetOnKeyDown: TKeyEvent;
begin
  Result := FComboBox.OnKeyDown;
end;

function TADComboBox.GetOnKeyPress: TKeyPressEvent;
begin
  Result := FComboBox.OnKeyPress;
end;

procedure TADComboBox.SetLabelCaption(_Caption: TCaption);
begin
  FInnerLabelCaption.Caption := _Caption;
end;

procedure TADComboBox.SetOnChange(_NotifyEvent: TNotifyEvent);
begin
  FComboBox.OnChange := _NotifyEvent;
end;

procedure TADComboBox.SetOnKeyDown(_KeyEvent: TKeyEvent);
begin
  FComboBox.OnKeyDown := _KeyEvent;
end;

procedure TADComboBox.SetOnKeyPress(_KeyPressEvent: TKeyPressEvent);
begin
  FComboBox.OnKeyPress := _KeyPressEvent;
end;

end.
