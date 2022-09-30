unit uADPasswordButtonEdit;

interface

uses
  System.SysUtils, System.Classes, Vcl.Controls, Vcl.StdCtrls, Vcl.ExtCtrls, Generics.Collections;

type
  TImagePasswordButtonEdit = class
  private
    FFilename: string;
    FIsPressedImage: Boolean;
  public
    property Filename: string read FFilename write FFilename;
    property IsPressedImage: Boolean read FIsPressedImage write FIsPressedImage;
  end;

  TImagePasswordButtonEditList = class(TObjectList<TImagePasswordButtonEdit>);

  TADPasswordButtonEdit = class(TCustomButtonedEdit)
  private
    FImageList: TImageList;

    procedure ConfigureButtonedEdit;
    procedure CreateImageList;
    procedure ConfigreImageList;
    procedure AddNewImage(_AFileName: string);

    procedure DoOnRightButtonClick(_ASender: TObject);
  public
    destructor Destroy; override;
    constructor Create(_AOwner: TComponent); override;

    procedure AddImages(_AImagePasswordButtonEditList: TImagePasswordButtonEditList);
  end;

procedure Register;

implementation

uses
  Vcl.Imaging.pngimage, Vcl.Graphics, Vcl.ImgList;

procedure Register;
begin
  RegisterComponents('Allan Debastiani', [TADPasswordButtonEdit]);
end;

procedure TADPasswordButtonEdit.AddImages(_AImagePasswordButtonEditList: TImagePasswordButtonEditList);
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

procedure TADPasswordButtonEdit.AddNewImage(_AFileName: string);
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

procedure TADPasswordButtonEdit.ConfigreImageList;
begin
  FImageList := TImageList.Create(nil);
  FImageList.Masked := False;
  FImageList.ColorDepth := cd32bit;
  FImageList.ImageType := itImage;
  FImageList.DrawingStyle := dsTransparent;
  FImageList.Width := 16;
  FImageList.Height := 16;
end;

procedure TADPasswordButtonEdit.ConfigureButtonedEdit;
begin
  Images := FImageList;

  PasswordChar := '*';
  RightButton.ImageIndex := 0;
  RightButton.HotImageIndex := 0;
  RightButton.PressedImageIndex := 1;
  RightButton.Enabled := True;
  RightButton.Visible := True;

  OnRightButtonClick := DoOnRightButtonClick;
end;

constructor TADPasswordButtonEdit.Create(_AOwner: TComponent);
begin
  inherited;
  CreateImageList;
  ConfigureButtonedEdit;
end;

procedure TADPasswordButtonEdit.CreateImageList;
begin
  ConfigreImageList;
end;

destructor TADPasswordButtonEdit.Destroy;
begin
  FImageList.Free;
  inherited;
end;

procedure TADPasswordButtonEdit.DoOnRightButtonClick(_ASender: TObject);
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

end.

