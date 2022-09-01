unit uFrameworkMessageView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.Menus, Vcl.ExtCtrls, uFrameworkEnums, Vcl.StdCtrls, Vcl.Imaging.pngimage, uFrameworkView,
  uFrameworkMessage;

type
  TFrameworkMessageView = class(TFrameworkView)
    ImageError: TImage;
    LabelTitle: TLabel;
    MemoMessage: TMemo;
    PanelBackground: TPanel;
    PanelMessages: TPanel;
    PanelButtons: TPanel;
    PanelImage: TPanel;
    PanelMessageDetail: TPanel;
    PanelMessageTitle: TPanel;
    PanelContent: TPanel;
    procedure FormShow(Sender: TObject);
  private
    procedure ResizeView;
    procedure CreateButtons(_AButtonAction: TArray<TButtonAction>);
    procedure CreateButton(_ACaption: TArray<String>; _AModalResult: TArray<TModalResult>);
    procedure ConfigureImagem(_AMessageIconType: TMessageIconType);

    function GetMessage(_AMessage: String): String;
    function GetTitle(_AMessage: String): String;
    function GetMemoMessage(_ADetail: String): String;
  protected
    procedure PrepareComponents; override;
  public
    constructor CreateMsg(_AMessage: String); overload;
    constructor CreateMsg(_AMessage: String; _AButtonAction: TArray<TButtonAction>; _AMessageIconType: TMessageIconType; _ADetail: String); overload;

    function GetResult: TMessageViewResult;
  end;

implementation

uses
  uFrameworkMessages, uFrameworkSysInfo;

{$R *.dfm}

{ TFrameworkMessageView }

constructor TFrameworkMessageView.CreateMsg(_AMessage: String);
begin
  inherited Create(nil);
  LabelTitle.Caption := GetTitle(_AMessage);
  MemoMessage.Text := GetMessage(_AMessage);
end;

procedure TFrameworkMessageView.ConfigureImagem(_AMessageIconType: TMessageIconType);
begin
  ImageError.AutoSize := True;
  ImageError.Center := True;
  ImageError.Stretch := True;
  ImageError.Transparent := True;

  case _AMessageIconType of
    mitSuccess:
     ImageError.Picture.LoadFromFile(TFrameworkSysInfo.GetFilePathImageSuccess);

    mitWarning:
      ImageError.Picture.LoadFromFile(TFrameworkSysInfo.GetFilePathImageWarning);

    mitError:
      ImageError.Picture.LoadFromFile(TFrameworkSysInfo.GetFilePathImageError);

    mitDev:
      ImageError.Picture.LoadFromFile(TFrameworkSysInfo.GetFilePathImageDesenvolvimento);
  end;
end;

constructor TFrameworkMessageView.CreateMsg(_AMessage: String; _AButtonAction: TArray<TButtonAction>; _AMessageIconType: TMessageIconType; _ADetail: String);
begin
  CreateMsg(_AMessage);
  CreateButtons(_AButtonAction);
  ConfigureImagem(_AMessageIconType);
  MemoMessage.Text := GetMemoMessage(_ADetail);;
end;

procedure TFrameworkMessageView.CreateButton(_ACaption: TArray<String>; _AModalResult: TArray<TModalResult>);
var
  I: Integer;
  ACount: Integer;
  AButton: TButton;
begin
  if Length(_ACaption) <> Length(_AModalResult) then
    raise Exception.Create('Parameter incorrects. TFrameworkMessageView.CreateButton');

  ACount := Length(_ACaption);
  for I := 0 to ACount - 1 do
  begin
    AButton := TButton.Create(Self);
    try
      AButton.Caption := _ACaption[I];
      AButton.ModalResult := _AModalResult[I];
      AButton.Align := alRight;
      AButton.Parent := PanelButtons;
    except
      AButton.Free;
      raise;
    end;
  end;
end;

procedure TFrameworkMessageView.CreateButtons(_AButtonAction: TArray<TButtonAction>);
var
  AButtonAction: TButtonAction;
begin
  for AButtonAction in _AButtonAction do
  begin
    case AButtonAction of
      baOk:
        CreateButton(['&Ok'], [mrOk]);

      baYesNo:
        CreateButton(['&Yes', '&No'], [mrYes, mrNo]);
    else
      raise Exception.Create('Not implemented... TFrameworkMessageView.CreateButtons');
    end;
  end;
end;

procedure TFrameworkMessageView.FormShow(Sender: TObject);
begin
  inherited;
  ResizeView;
  BringToFront;
end;

function TFrameworkMessageView.GetTitle(_AMessage: String): String;
var
  APos: Integer;
begin
  Result := _AMessage;
  if not Length(_AMessage) > 0 then
    Exit;

  APos := Pos(MSG_CRLF, _AMessage);
  if APos > 0 then
    Result := Copy(_AMessage, 1, APos - 1);
end;

function TFrameworkMessageView.GetMemoMessage(_ADetail: String): String;
begin
  Result := EmptyStr;

  if Length(MemoMessage.Text) > 0 then
    Result := Format('%s%s%s', [MemoMessage.Text, sLineBreak, _ADetail])
  else
    Result := _ADetail;
end;

function TFrameworkMessageView.GetMessage(_AMessage: String): String;
var
  APos: Integer;
begin
  Result := EmptyStr;
  if not Length(_AMessage) > 0 then
    Exit;

  APos := Pos(MSG_CRLF, _AMessage);
  if APos > 0 then
    Result := Copy(_AMessage, APos + 2, Length(_AMessage));
  Result := Trim(Result);
end;

function TFrameworkMessageView.GetResult: TMessageViewResult;
begin
  Result := TMessageViewResult.Create;
  try
    Result.Title := LabelTitle.Caption;
    Result.Detail := MemoMessage.Text;
  except
    Result.Free;
    raise;
  end;
end;

procedure TFrameworkMessageView.PrepareComponents;
begin
  inherited;
  BorderStyle := bsDialog;
//  AutoSize := True;

  PanelButtons.Padding.Top := 3;
  PanelButtons.Padding.Bottom := 3;
  PanelButtons.Padding.Left := 3;
  PanelButtons.Padding.Right := 3;

  LabelTitle.Font.Style := [fsBold];
  PanelMessageTitle.Padding.Top := 5;
  PanelMessageTitle.Padding.Bottom := 5;
  PanelMessageTitle.Padding.Left := 5;
  PanelMessageTitle.Padding.Right := 5;

  MemoMessage.ReadOnly := True;
  MemoMessage.TabStop := False;
  PanelMessageDetail.Padding.Top := 5;
  PanelMessageDetail.Padding.Bottom := 5;
  PanelMessageDetail.Padding.Left := 5;
  PanelMessageDetail.Padding.Right := 5;
end;

procedure TFrameworkMessageView.ResizeView;
var
  AIsEmptyMessage: Boolean;
  ATotalSizeNecessary: Integer;
begin
  AIsEmptyMessage := MemoMessage.Text = '';
  PanelMessageDetail.Visible := not AIsEmptyMessage;

  if AIsEmptyMessage then
  begin
    ATotalSizeNecessary := PanelImage.Height + PanelButtons.Height + PanelMessageTitle.Height;    
    Height :=  ATotalSizeNecessary - PanelMessageDetail.Height;
  end;
end;

end.
