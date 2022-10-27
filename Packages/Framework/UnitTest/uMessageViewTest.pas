unit uMessageViewTest;

interface

uses
  DUnitX.TestFramework, uFrameworkMessage, uFrameworkMessages, uFrameworkMessageView, uFrameworkEnums;

type
  [TestFixture]
  TMessageViewTest = class
  public
    [Test]
    procedure MessageIconTypeTest;
    [Test]
    procedure MessageDetailTest;
    [Test]
    procedure MessageArgsTest;
    [Test]
    procedure MessageButtonTest;
  end;

implementation

uses
  Winapi.Windows, System.SysUtils, Vcl.Controls, pngimage;

procedure TMessageViewTest.MessageArgsTest;
var
  AMessageTitle: String;
  AFirstArgument: String;
  ASecondArgument: String;
  AMessageViewResult: TMessageViewResult;
begin
  AMessageTitle := 'MessageArgsTest first argument: %s, second argument: %s';
  AFirstArgument := 'primary argument OK';
  ASecondArgument := 'second argument OK';

  AMessageViewResult := TMessageView.New(AMessageTitle).Args([AFirstArgument, ASecondArgument]).GetResult;
  Assert.AreEqual(Format(AMessageTitle, [AFirstArgument, ASecondArgument]), AMessageViewResult.Title);
end;

procedure TMessageViewTest.MessageButtonTest;
var
  AModalResult: TModalResult;
  AQtdButtonAction: Integer;
  AQtdButtonTested: Integer;
begin
  AQtdButtonAction := Ord(High(TButtonAction));
  AModalResult := TMessageView.New('MessageShowAndResultTest - Select OK').Buttons([baOk]).ShowResult;
  Assert.AreEqual(Ord(AModalResult), Ord(mrOk), 'Not pressed "OK" button');

  // The same ButtonAction
  AModalResult := TMessageView.New('MessageShowAndResultTest - Select YES').Buttons([baYesNo]).ShowResult;
  Assert.AreEqual(Ord(AModalResult), Ord(mrYes), 'Not pressed "YES" button');
  AModalResult := TMessageView.New('MessageShowAndResultTest - Select NO').Buttons([baYesNo]).ShowResult;
  Assert.AreEqual(Ord(AModalResult), Ord(mrNo), 'Not pressed "NO" button');

  AQtdButtonTested := 1; // Quantity of runned tests - 1.
  Assert.AreEqual(AQtdButtonTested, AQtdButtonAction);
end;

procedure TMessageViewTest.MessageDetailTest;
var
  AMessageTitleSimple: String;
  AMessageDetailed: String;
  AMessageViewResult: TMessageViewResult;
  ADetail: String;
  AMessageWithDetail: String;
begin
  AMessageTitleSimple := 'MessageDetailTest';
  AMessageDetailed := 'Detailed test';
  AMessageViewResult := TMessageView.New(AMessageTitleSimple).Detail(AMessageDetailed).GetResult;
  try
    Assert.AreEqual(AMessageDetailed, AMessageViewResult.Detail);
  finally
    AMessageViewResult.Free;
  end;

  ADetail := 'This is a detail';
  AMessageWithDetail := Format('%s %s %s', [AMessageTitleSimple, MSG_CRLF, ADetail]);
  AMessageViewResult := TMessageView.New(AMessageWithDetail).Detail(AMessageDetailed).GetResult;
  try
    Assert.AreEqual(Format('%s%s%s', [ADetail, sLineBreak, AMessageDetailed]), AMessageViewResult.Detail);
  finally
    AMessageViewResult.Free;
  end;
end;

procedure TMessageViewTest.MessageIconTypeTest;
var
  AQtdMessageIconType: Integer;
  AQtdMessageIconTypeTested: Integer;
begin
  AQtdMessageIconType := Ord(High(TMessageIconType));

  TMessageView.New('MessageIconTypeTest - Warning').Warning.Show;
  TMessageView.New('MessageIconTypeTest - Success').Success.Show;
  TMessageView.New('MessageIconTypeTest - Error').Error.Show;
  TMessageView.New('MessageIconTypeTest - Dev').Dev.Show;

  AQtdMessageIconTypeTested := 3; // Quantity of runned tests - 1.
  Assert.AreEqual(AQtdMessageIconTypeTested, AQtdMessageIconType);
end;

initialization
  TDUnitX.RegisterTestFixture(TMessageViewTest);

end.
