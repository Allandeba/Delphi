unit uFrameworkMessageView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
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
    procedure CreateButtons(_ButtonAction: TArray<TButtonAction>);
    procedure CreateButton(_Caption: TArray<String>; _ModalResult: TArray<TModalResult>);
    procedure ConfigureImagem(_MessageIconType: TMessageIconType);

    function GetMessage(_Message: String): String;
    function GetDetailMessage(_Detail: String): String;
    function GetTitle(_Message: String): String;
    function GetMemoMessage(_Detail: String): String;
  protected
    procedure PrepareComponents; override;
  public
    constructor CreateMsg(_Message: String); overload;
    constructor CreateMsg(_Message: String; _ButtonAction: TArray<TButtonAction>; _MessageIconType: TMessageIconType; _Detail: String); overload;

    function GetResult: TMessageViewResult;
  end;

implementation

uses
  uFrameworkMessages, uFrameworkSysInfo, System.SysUtils;

{$R *.dfm}

{ TFrameworkMessageView }

constructor TFrameworkMessageView.CreateMsg(_Message: String);
begin
  inherited Create(nil);
  LabelTitle.Caption := GetTitle(_Message);
  MemoMessage.Text := GetMessage(_Message);
end;

procedure TFrameworkMessageView.ConfigureImagem(_MessageIconType: TMessageIconType);
begin
  ImageError.AutoSize := True;
  ImageError.Center := True;
  ImageError.Stretch := True;
  ImageError.Transparent := True;

  case _MessageIconType of
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

constructor TFrameworkMessageView.CreateMsg(_Message: String; _ButtonAction: TArray<TButtonAction>; _MessageIconType: TMessageIconType; _Detail: String);
begin
  CreateMsg(_Message);
  CreateButtons(_ButtonAction);
  ConfigureImagem(_MessageIconType);
  MemoMessage.Text := GetMemoMessage(_Detail);;
end;

procedure TFrameworkMessageView.CreateButton(_Caption: TArray<String>; _ModalResult: TArray<TModalResult>);
var
  I: Integer;
  ACount: Integer;
  AButton: TButton;
begin
  if Length(_Caption) <> Length(_ModalResult) then
    raise Exception.Create('Parameter incorrects. TFrameworkMessageView.CreateButton');

  ACount := Length(_Caption);
  for I := 0 to ACount - 1 do
  begin
    AButton := TButton.Create(Self);
    try
      AButton.Caption := _Caption[I];
      AButton.ModalResult := _ModalResult[I];
      AButton.Align := alRight;
      AButton.Parent := PanelButtons;
    except
      AButton.Free;
      raise;
    end;
  end;
end;

procedure TFrameworkMessageView.CreateButtons(_ButtonAction: TArray<TButtonAction>);
var
  AButtonAction: TButtonAction;
begin
  for AButtonAction in _ButtonAction do
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

function TFrameworkMessageView.GetTitle(_Message: String): String;
var
  APos: Integer;
begin
  Result := _Message;
  if not Length(_Message) > 0 then
    Exit;

  APos := Pos(MSG_CRLF, _Message);
  if APos > 0 then
    Result := Copy(_Message, 1, APos - 1);
end;

function TFrameworkMessageView.GetDetailMessage(_Detail: String): String;
begin
  Result := StringReplace(_Detail, MSG_CRLF, sLineBreak, [rfReplaceAll, rfIgnoreCase]);
end;

function TFrameworkMessageView.GetMemoMessage(_Detail: String): String;
var
  ADetail: String;
begin
  Result := EmptyStr;

  ADetail := GetDetailMessage(_Detail);
  if Length(MemoMessage.Text) > 0 then
    Result := Format('%s%s%s', [MemoMessage.Text, sLineBreak, ADetail])
  else
    Result := ADetail;
end;

function TFrameworkMessageView.GetMessage(_Message: String): String;
var
  APos: Integer;
begin
  Result := EmptyStr;
  if not Length(_Message) > 0 then
    Exit;

  APos := Pos(MSG_CRLF, _Message);
  if APos > 0 then
    Result := Copy(_Message, APos + 2, Length(_Message));
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
