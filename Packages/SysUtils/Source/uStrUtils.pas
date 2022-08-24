unit uStrUtils;

interface

type
  TStrUtils = class
  private
    class function RemoveBetweenParentheses(_AText: String): String;
  public
    class function RemovePathBackFolders(_APath: String): String;

    class function GetExtractedFileName(_APath: String): String;
    class function GetNumbersFromText(_AText: String): Integer;
  end;

implementation

uses
  RegularExpressions, SysUtils;

{ TStrUtils }

class function TStrUtils.GetExtractedFileName(_APath: String): String;
var
  ARegex: TRegex;
  AMatch: TMatch;
begin
// Result := ExtractFileName(Result.Trim); Todo: Tentei remover os ..\..\ da frente antes de fazer ExtractFileName mas mesmo assim não deu certo.
// POG usar dois Regex;
  Result := RemovePathBackFolders(_APath);
  ARegex := TRegex.Create('[\w-]+\....');
  AMatch := ARegex.Match(Result, '[\w-]+\....');
  Result := AMatch.Value.Trim;

  if Result.IsEmpty then
    raise Exception.Create(Format('Não foi possível extrair o FileName do diretório: %s', [_APath]));
end;

class function TStrUtils.GetNumbersFromText(_AText: String): Integer;
var
  AValue: String;
  ARegex: TRegex;
begin
  AValue := RemoveBetweenParentheses(_AText.Trim);
  AValue := RemovePathBackFolders(AValue);

  ARegex := ARegex.Create('[A-z]');
  AValue := ARegex.Replace(AValue, '').Trim;

  if not TryStrToInt(AValue, Result) then
    raise Exception.Create(Format('Não foi possível encontrar os números do texto: %s', [_AText]));
end;

class function TStrUtils.RemoveBetweenParentheses(_AText: String): String;
var
  ARegex: TRegex;
begin
  ARegex := TRegex.Create('\(..........\)');
  Result := ARegex.Replace(_AText, '');

  if Result.IsEmpty then
    raise Exception.Create(Format('Não foi possível remover parenteses do texto: %s', [_AText]));
end;

class function TStrUtils.RemovePathBackFolders(_APath: String): String;
var
  ARegex: TRegex;
begin
  // Remove os ..\..\ "BackFolders"
  ARegex := TRegex.Create('[.\\:*?"<>|\r\n]*\\');
  Result := ARegex.Replace(_APath, '').Trim;

  if Result.IsEmpty then
    raise Exception.Create(Format('Não foi possível remover os PathBackFolders do diretório: %s', [_APath]));
end;

end.
