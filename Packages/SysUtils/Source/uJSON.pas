unit uJSON;

interface

type
  TJSONUtils<T> = class
  public
    class function Parse(_ValueNameToGet: String; _ContentToParse: String; _WhereToFindIt: String; _Decode64: Boolean): T;
  end;

implementation

uses
  JSON, NetEncoding, uStrHelper;

{ TJSON<T> }

class function TJSONUtils<T>.Parse(_ValueNameToGet, _ContentToParse, _WhereToFindIt: String; _Decode64: Boolean): T;
var
  AContent: String;
  AJSONValue: TJSonValue;
begin
  AContent := _ContentToParse;

  if not _WhereToFindIt.IsEmpty then
  begin
    AJSONValue := TJSonObject.ParseJSONValue(_ContentToParse);
    try
      AContent := AJSONValue.GetValue<String>(_WhereToFindIt);
    finally
      AJSONValue.Free;
    end;
  end;

  if _Decode64 then
    AContent := TBase64Encoding.Base64.Decode(AContent);

  AJSONValue := TJSonObject.ParseJSONValue(AContent);
  try
    Result := AJSONValue.GetValue<T>(_ValueNameToGet);
  finally
    AJSONValue.Free;
  end;
end;

end.
