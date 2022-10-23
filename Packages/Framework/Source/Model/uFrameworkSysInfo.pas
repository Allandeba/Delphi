unit uFrameworkSysInfo;

interface

type
  TFrameworkSysInfo = class
  public
    class function GetFilePathImageError: String;
    class function GetFilePathImageWarning: String;
    class function GetFilePathImageSuccess: String;
    class function GetFilePathImageDesenvolvimento: String;
  end;

implementation

uses
  System.SysUtils, Vcl.Forms, uFrameworkConsts;

{ TFrameworkSysInfo }

class function TFrameworkSysInfo.GetFilePathImageDesenvolvimento: String;
begin
  Result := ExtractFilePath(Application.ExeName) + IMG_FOLDER + IMG_DEVELOPER;
end;

class function TFrameworkSysInfo.GetFilePathImageError: String;
begin
  Result := ExtractFilePath(Application.ExeName) + IMG_FOLDER + IMG_ERROR;
end;

class function TFrameworkSysInfo.GetFilePathImageSuccess: String;
begin
  Result := ExtractFilePath(Application.ExeName) + IMG_FOLDER + IMG_SUCCESS;
end;

class function TFrameworkSysInfo.GetFilePathImageWarning: String;
begin
  Result := ExtractFilePath(Application.ExeName) + IMG_FOLDER + IMG_WARNING;
end;

end.
