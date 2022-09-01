unit uImageFolderTest;

interface

uses
  DUnitX.TestFramework, uFrameworkConsts;

type
  [TestFixture]
  TImageFolderTest = class
  public
    [Test]
    [TestCase('ImageFolderTest - Error', IMG_FOLDER + IMG_ERROR)]
    [TestCase('ImageFolderTest - Success', IMG_FOLDER + IMG_SUCCESS)]
    [TestCase('ImageFolderTest - Warning', IMG_FOLDER + IMG_WARNING)]
    [TestCase('ImageFolderTest - Developer', IMG_FOLDER + IMG_DEVELOPER)]
    procedure ImageFolderTest(const _AFilePath: String);
  end;

implementation

uses
  System.SysUtils;


{ TImageFolderTest }

procedure TImageFolderTest.ImageFolderTest(const _AFilePath: String);
begin
  Assert.IsTrue(FileExists(_AFilePath), Format('File to image not reached %s', [_AFilePath]));
end;

initialization
  TDUnitX.RegisterTestFixture(TImageFolderTest);

end.
