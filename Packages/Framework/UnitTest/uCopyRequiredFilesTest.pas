unit uCopyRequiredFilesTest;

interface

uses
  DUnitX.TestFramework;

const
  DEFAULT_FOLDER_FILE_NAME = 'File2ExeFolder/Source';

type
  [TestFixture]
  TCopyRequiredFilesTest = class
  private
    function GetDefaultRequiredFolderPath: String;
    function GetFilePathWhereToCopy: String;
  public
    [Test]
    procedure CopyRequiredFilesTest;
    [Test]
    procedure CheckIfRequiredFolderExists;
  end;

implementation

uses
  System.SysUtils, System.Classes, Vcl.Forms, System.IOUtils;

procedure TCopyRequiredFilesTest.CheckIfRequiredFolderExists;
begin
  Assert.IsTrue(TDirectory.Exists(GetFilePathWhereToCopy))
end;

procedure TCopyRequiredFilesTest.CopyRequiredFilesTest;
begin
  Assert.WillNotRaise(
    procedure
    begin
      if not TDirectory.Exists(GetDefaultRequiredFolderPath) then
        raise Exception.Create(Format('Can not find required folder.%s%s', [sLineBreak, GetDefaultRequiredFolderPath]));

      TDirectory.Copy(GetDefaultRequiredFolderPath, GetFilePathWhereToCopy);
    end
  );
end;

function TCopyRequiredFilesTest.GetDefaultRequiredFolderPath: String;
begin
  Result := Format('%s..\..\..\%s', [ExtractFilePath(Application.ExeName), DEFAULT_FOLDER_FILE_NAME]);
end;

function TCopyRequiredFilesTest.GetFilePathWhereToCopy: String;
begin
  Result := Format('%s%s', [ExtractFilePath(Application.ExeName), 'Source']);
end;

initialization
  TDUnitX.RegisterTestFixture(TCopyRequiredFilesTest);

end.
