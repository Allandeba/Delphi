unit uADComboBox;

interface

uses
  System.SysUtils, System.Classes, Vcl.Controls, Vcl.StdCtrls, Vcl.ExtCtrls, uADCustomPanelNoCaption;

type
  TADComboBox = class(TADCustomPanelNoCaption)
  strict private
    FComboBox: TComboBox;
    procedure ConfigureComboBox;

    function GetOnKeyDown: TKeyEvent;
    procedure SetOnKeyDown(_KeyEvent: TKeyEvent);
    function GetOnChange: TNotifyEvent;
    procedure SetOnChange(_NotifyEvent: TNotifyEvent);
    function GetOnKeyPress: TKeyPressEvent;
    procedure SetOnKeyPress(_KeyPressEvent: TKeyPressEvent);

    function GetText: TCaption;
    procedure SetText(_Caption: TCaption);
    function GetItemIndex: Integer;
    procedure SetItemIndex(_ItemIndex: Integer);
    function GetItems: TStrings;
    procedure SetItems(_Items: TStrings);
  public
    constructor Create(_Owner: TComponent); override;
  published
    property Text: TCaption read GetText write SetText;
    property ItemIndex: Integer read GetItemIndex write SetItemIndex;
    property Items: TStrings read GetItems write SetItems;
    property TabOrder;
    property BevelOuter;

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
  FComboBox.Left := 0;
  FComboBox.Align := alClient;
end;

constructor TADComboBox.Create(_Owner: TComponent);
begin
  inherited;
  ConfigureComboBox;
end;

function TADComboBox.GetItemIndex: Integer;
begin
  Result := FComboBox.ItemIndex;
end;

function TADComboBox.GetItems: TStrings;
begin
  Result := FComboBox.Items;
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

function TADComboBox.GetText: TCaption;
begin
  Result := FComboBox.Text;
end;

procedure TADComboBox.SetItemIndex(_ItemIndex: Integer);
begin
  FComboBox.ItemIndex := _ItemIndex;
end;

procedure TADComboBox.SetItems(_Items: TStrings);
begin
  FComboBox.Items := _Items;
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

procedure TADComboBox.SetText(_Caption: TCaption);
begin
  FComboBox.Text := _Caption;
end;

end.
