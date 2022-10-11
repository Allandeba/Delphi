unit uStrUtils;

interface

type
  TStrUtils = class
  private
    class function RemoveBetweenParentheses(_Text: String): String;
  public
    class function RemovePathBackFolders(_Path: String): String;

    class function GetExtractedFileName(_Path: String): String;
    class function GetNumbersFromText(_Text: String): Integer;
  end;

implementation

uses
  RegularExpressions, SysUtils;

{ TStrUtils }

class function TStrUtils.GetExtractedFileName(_Path: String): String;
var
  ARegex: TRegex;
  AMatch: TMatch;
begin
// Result := ExtractFileName(Result.Trim); Todo: Tentei remover os ..\..\ da frente antes de fazer ExtractFileName mas mesmo assim não deu certo.
// POG usar dois Regex;
  Result := RemovePathBackFolders(_Path);
  ARegex := TRegex.Create('[\w-]+\....');
  AMatch := ARegex.Match(Result, '[\w-]+\....');
  Result := AMatch.Value.Trim;

  if Result.IsEmpty then
    raise Exception.Create(Format('Não foi possível extrair o FileName do diretório: %s', [_Path]));
end;

class function TStrUtils.GetNumbersFromText(_Text: String): Integer;
var
  AValue: String;
  ARegex: TRegex;
begin
  AValue := RemoveBetweenParentheses(_Text.Trim);
  AValue := RemovePathBackFolders(AValue);

  ARegex := ARegex.Create('[A-z]');
  AValue := ARegex.Replace(AValue, '').Trim;

  if not TryStrToInt(AValue, Result) then
    raise Exception.Create(Format('Não foi possível encontrar os números do texto: %s', [_Text]));
end;

class function TStrUtils.RemoveBetweenParentheses(_Text: String): String;
var
  ARegex: TRegex;
begin
  ARegex := TRegex.Create('\(..........\)');
  Result := ARegex.Replace(_Text, '');

  if Result.IsEmpty then
    raise Exception.Create(Format('Não foi possível remover parenteses do texto: %s', [_Text]));
end;

class function TStrUtils.RemovePathBackFolders(_Path: String): String;
var
  ARegex: TRegex;
begin
  // Remove os ..\..\ "BackFolders"
  ARegex := TRegex.Create('[.\\:*?"<>|\r\n]*\\');
  Result := ARegex.Replace(_Path, '').Trim;

  if Result.IsEmpty then
    raise Exception.Create(Format('Não foi possível remover os PathBackFolders do diretório: %s', [_Path]));
end;

end.
