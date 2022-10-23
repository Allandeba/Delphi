unit uADPasswordButtonedEdit;

interface

uses
  System.SysUtils, System.Classes, Vcl.Controls, Vcl.StdCtrls, Vcl.ExtCtrls, Generics.Collections, uADCustomPanelNoCaption;

type
  TImagePasswordButtonEdit = class
  strict private
    FFilename: string;
    FIsPressedImage: Boolean;
  public
    property Filename: string read FFilename write FFilename;
    property IsPressedImage: Boolean read FIsPressedImage write FIsPressedImage;
  end;

  TImagePasswordButtonEditList = class(TObjectList<TImagePasswordButtonEdit>);

  TPasswordButtonedEdit = class(TButtonedEdit)
  strict private
    FImageList: TImageList;

    procedure CreateImageList;
    procedure ConfigreImageList;
    procedure AddNewImage(_FileName: string);
    procedure SetRightButtonImage(_ActivePasswordView: Boolean);

    procedure DoOnRightButtonClick(_Sender: TObject);
    procedure DoOnMouseLeave(_Sender: TObject);
  public
    constructor Create(_Owner: TComponent); override;
    destructor Destroy; override;

    procedure AddImages(_ImagePasswordButtonEditList: TImagePasswordButtonEditList);
    property ImageList: TImageList read FImageList;
  end;

  TADPasswordButtonedEdit = class(TADCustomPanelNoCaption)
  strict private
    FPasswordButtonedEdit: TPasswordButtonedEdit;
    procedure ConfigurePasswordButtonedEdit;

    function GetPasswordButtonedEditText: String;
    procedure SetPasswordButtonedEditText(_Text: String);

    function GetOnKeyDown: TKeyEvent;
    procedure SetOnKeyDown(_KeyEvent: TKeyEvent);
  public
    constructor Create(_Owner: TComponent); override;
    procedure AddImages(_ImagePasswordButtonEditList: TImagePasswordButtonEditList);

    procedure Clear;
    procedure SetFocus; override;
    function CanFocus: Boolean; override;
  published
    property Text: String read GetPasswordButtonedEditText write SetPasswordButtonedEditText;
    property TabOrder;
    property BevelOuter;

    property OnKeyDown: TKeyEvent read GetOnKeyDown write SetOnKeyDown;
  end;

procedure Register;

implementation

uses
  Vcl.Imaging.pngimage, Vcl.Graphics, Vcl.ImgList, Vcl.Forms;

procedure Register;
begin
  RegisterComponents('Allan Debastiani', [TADPasswordButtonedEdit]);
end;

procedure TPasswordButtonedEdit.AddImages(_ImagePasswordButtonEditList: TImagePasswordButtonEditList);
var
  I: Integer;
begin
  FImageList.Clear;

  for I := 0 to _ImagePasswordButtonEditList.Count - 1 do
  begin
    if I > 1 then
      raise Exception.Create('Not expected more then 2 images to the component');

    if _ImagePasswordButtonEditList[I].IsPressedImage then
      RightButton.PressedImageIndex := I
    else
      RightButton.ImageIndex := I;

    AddNewImage(_ImagePasswordButtonEditList[I].Filename);
  end;
end;

procedure TPasswordButtonedEdit.AddNewImage(_FileName: string);
var
  APngImage: TPngImage;
  AImageBmp: TBitmap;
begin
  APngImage := TPngImage.Create;
  try
    APngImage.LoadFromFile(_FileName);

    AImageBmp := TBitmap.Create;
    try
      APngImage.AssignTo(AImageBmp);
      AImageBmp.AlphaFormat := afIgnored;

      FImageList.Add(AImageBmp, nil);
    finally
      AImageBmp.Free;
    end;
  finally
    APngImage.Free;
  end;
end;

procedure TPasswordButtonedEdit.ConfigreImageList;
begin
  FImageList := TImageList.Create(nil);
  FImageList.Masked := False;
  FImageList.ColorDepth := cd32bit;
  FImageList.ImageType := itImage;
  FImageList.DrawingStyle := dsTransparent;
  FImageList.Width := 16;
  FImageList.Height := 16;
end;

constructor TPasswordButtonedEdit.Create(_Owner: TComponent);
begin
  inherited;
  CreateImageList;

  OnRightButtonClick := DoOnRightButtonClick;
  OnMouseLeave := DoOnMouseLeave;
end;

procedure TPasswordButtonedEdit.CreateImageList;
begin
  ConfigreImageList;

  Images := FImageList;
end;

destructor TPasswordButtonedEdit.Destroy;
begin
  FImageList.Free;
  inherited;
end;

procedure TPasswordButtonedEdit.DoOnMouseLeave(_Sender: TObject);
begin
  SetRightButtonImage(True);
end;

procedure TPasswordButtonedEdit.DoOnRightButtonClick(_Sender: TObject);
begin
  if FImageList.Count = 0 then
    raise Exception.Create('You may use the procedure "AddImages()" to use your own icons to the button');

  case RightButton.HotImageIndex of
    0: SetRightButtonImage(False);
    1: SetRightButtonImage(True);
  else
    raise Exception.Create('ImageIndex: ' + IntToStr(RightButton.HotImageIndex) + 'not expected');
  end;
end;

procedure TPasswordButtonedEdit.SetRightButtonImage(_ActivePasswordView: Boolean);
begin
  if _ActivePasswordView then
  begin
    RightButton.HotImageIndex := 0;
    PasswordChar := '*';
  end
  else
  begin
    RightButton.HotImageIndex := 1;
    PasswordChar := #0;
  end;
end;

{ TDAPasswordButtonedEdit }

constructor TADPasswordButtonedEdit.Create(_Owner: TComponent);
begin
  inherited;
  ConfigurePasswordButtonedEdit;
end;

function TADPasswordButtonedEdit.GetPasswordButtonedEditText: String;
begin
  Result := FPasswordButtonedEdit.Text;
end;

procedure TADPasswordButtonedEdit.SetPasswordButtonedEditText(_Text: String);
begin
  FPasswordButtonedEdit.Text := _Text;
end;

function TADPasswordButtonedEdit.GetOnKeyDown: TKeyEvent;
begin
  Result := FPasswordButtonedEdit.OnKeyDown;
end;

procedure TADPasswordButtonedEdit.SetFocus;
begin
  FPasswordButtonedEdit.SetFocus;
end;

procedure TADPasswordButtonedEdit.SetOnKeyDown(_KeyEvent: TKeyEvent);
begin
  FPasswordButtonedEdit.OnKeyDown := _KeyEvent;
end;

procedure TADPasswordButtonedEdit.ConfigurePasswordButtonedEdit;
begin
  FPasswordButtonedEdit := TPasswordButtonedEdit.Create(Self);

  FPasswordButtonedEdit.Left := 0;
  FPasswordButtonedEdit.Parent := Self;
  FPasswordButtonedEdit.Align := alClient;
  FPasswordButtonedEdit.Alignment := taLeftJustify;
  FPasswordButtonedEdit.PasswordChar := '*';

  FPasswordButtonedEdit.RightButton.ImageIndex := 0;
  FPasswordButtonedEdit.RightButton.HotImageIndex := 0;
  FPasswordButtonedEdit.RightButton.PressedImageIndex := 1;
  FPasswordButtonedEdit.RightButton.Enabled := True;
  FPasswordButtonedEdit.RightButton.Visible := True;
end;

procedure TADPasswordButtonedEdit.AddImages(_ImagePasswordButtonEditList: TImagePasswordButtonEditList);
begin
  FPasswordButtonedEdit.AddImages(_ImagePasswordButtonEditList);
end;

function TADPasswordButtonedEdit.CanFocus: Boolean;
begin
  Result := FPasswordButtonedEdit.CanFocus;
end;

procedure TADPasswordButtonedEdit.Clear;
begin
  FPasswordButtonedEdit.Clear;
end;

end.

