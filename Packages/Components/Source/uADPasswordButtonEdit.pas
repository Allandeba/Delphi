unit uADPasswordButtonEdit;

interface

uses
  System.SysUtils, System.Classes, Vcl.Controls, Vcl.StdCtrls, Vcl.ExtCtrls, Generics.Collections;

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

  TPasswordButtonedEdit = class(TCustomButtonedEdit)
  strict private
    FImageList: TImageList;

    procedure CreateImageList;
    procedure ConfigreImageList;
    procedure AddNewImage(_AFileName: string);

    procedure DoOnRightButtonClick(_ASender: TObject);
  public
    constructor Create(_AOwner: TComponent); override;
    destructor Destroy; override;

    procedure AddImages(_AImagePasswordButtonEditList: TImagePasswordButtonEditList);
    property ImageList: TImageList read FImageList;
  end;

  TDAPasswordButtonedEdit = class(TPanel)
  strict private
    FPasswordButtonEdit: TPasswordButtonedEdit;
    FLabelCaption: TLabel;
    FLabelPanel: TPanel;

    procedure ConfigureMainPanel(_AOwner: TComponent);
    procedure ConfigureLabelPanel;
    procedure ConfigurePasswordButtonedEdit;
    procedure ConfigureLabelCaption;
  published
    property LabelCaption: TLabel read FLabelCaption;
  public
    constructor Create(_AOwner: TComponent); override;
  end;

procedure Register;

implementation

uses
  Vcl.Imaging.pngimage, Vcl.Graphics, Vcl.ImgList, Vcl.Forms;

procedure Register;
begin
  RegisterComponents('Allan Debastiani', [TDAPasswordButtonedEdit]);
end;

procedure TPasswordButtonedEdit.AddImages(_AImagePasswordButtonEditList: TImagePasswordButtonEditList);
var
  I: Integer;
begin
  FImageList.Clear;

  for I := 0 to _AImagePasswordButtonEditList.Count - 1 do
  begin
    if I > 1 then
      raise Exception.Create('Not expected more then 2 images to the component');

    if _AImagePasswordButtonEditList[I].IsPressedImage then
      RightButton.PressedImageIndex := I
    else
      RightButton.ImageIndex := I;

    AddNewImage(_AImagePasswordButtonEditList[I].Filename);
  end;
end;

procedure TPasswordButtonedEdit.AddNewImage(_AFileName: string);
var
  APngImage: TPngImage;
  AImageBmp: TBitmap;
begin
  APngImage := TPngImage.Create;
  try
    APngImage.LoadFromFile(_AFileName);

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

constructor TPasswordButtonedEdit.Create(_AOwner: TComponent);
begin
  inherited;
  CreateImageList;

  OnRightButtonClick := DoOnRightButtonClick;
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

procedure TPasswordButtonedEdit.DoOnRightButtonClick(_ASender: TObject);
begin
  if FImageList.Count = 0 then
    raise Exception.Create('You may use the procedure "AddImages()" to use your own icons to the button');

  case RightButton.HotImageIndex of
    0:
    begin
      RightButton.HotImageIndex := 1;
      PasswordChar := #0;
    end;

    1:
    begin
      RightButton.HotImageIndex := 0;
      PasswordChar := '*';
    end
  else
    raise Exception.Create('ImageIndex: ' + IntToStr(RightButton.HotImageIndex) + 'not expected');
  end;
end;

{ TDAPasswordButtonedEdit }

constructor TDAPasswordButtonedEdit.Create(_AOwner: TComponent);
begin
  inherited;
  ConfigureMainPanel(_AOwner);
  ConfigureLabelPanel;
  ConfigureLabelCaption;
  ConfigurePasswordButtonedEdit;
end;

procedure TDAPasswordButtonedEdit.ConfigurePasswordButtonedEdit;
begin
  FPasswordButtonEdit := TPasswordButtonedEdit.Create(Self);

  FPasswordButtonEdit.Left := 0;
  FPasswordButtonEdit.Parent := Self;
  FPasswordButtonEdit.Align := alClient;
  FPasswordButtonEdit.Alignment := taLeftJustify;
  FPasswordButtonEdit.PasswordChar := '*';

  FPasswordButtonEdit.RightButton.ImageIndex := 0;
  FPasswordButtonEdit.RightButton.HotImageIndex := 0;
  FPasswordButtonEdit.RightButton.PressedImageIndex := 1;
  FPasswordButtonEdit.RightButton.Enabled := True;
  FPasswordButtonEdit.RightButton.Visible := True;
end;

procedure TDAPasswordButtonedEdit.ConfigureLabelCaption;
begin
  FLabelCaption := TLabel.Create(FLabelPanel);
  FLabelCaption.Parent := FLabelPanel;
  FLabelCaption.Caption := 'Caption do Label';
  FLabelCaption.Align := alTop;
  FLabelCaption.Alignment := taLeftJustify;
end;

procedure TDAPasswordButtonedEdit.ConfigureLabelPanel;
begin
  FLabelPanel := TPanel.Create(Self);
  FLabelPanel.Height := 20;
  FLabelPanel.Left := 0;
  FLabelPanel.BevelOuter := bvNone;
  FLabelPanel.BorderStyle := bsNone;
  FLabelPanel.Parent := Self;
  FLabelPanel.Align := alTop;
end;

procedure TDAPasswordButtonedEdit.ConfigureMainPanel(_AOwner: TComponent);
begin
  Height := 40;
  Width := 150;
  Left := 10;
  BevelOuter := bvNone;
  BorderStyle := bsNone;
  Caption := '';
  ShowCaption := False;
end;

end.

