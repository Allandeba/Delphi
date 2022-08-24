unit uJSON;

interface

type
  TJSONUtils<T> = class
  public
    class function Parse(_AValueNameToGet: String; _AContentToParse: String; _AWhereToFindIt: String; _ADecode64: Boolean): T;
  end;

implementation

uses
  JSON, NetEncoding, uStrHelper;

{ TJSON<T> }

class function TJSONUtils<T>.Parse(_AValueNameToGet, _AContentToParse, _AWhereToFindIt: String; _ADecode64: Boolean): T;
var
  AContent: String;
  AJSONValue: TJSonValue;
begin
  AContent := _AContentToParse;

  if not _AWhereToFindIt.IsEmpty then
  begin
    AJSONValue := TJSonObject.ParseJSONValue(_AContentToParse);
    try
      AContent := AJSONValue.GetValue<String>(_AWhereToFindIt);
    finally
      AJSONValue.Free;
    end;
  end;

  if _ADecode64 then
    AContent := TBase64Encoding.Base64.Decode(AContent);

  AJSONValue := TJSonObject.ParseJSONValue(AContent);
  try
    Result := AJSONValue.GetValue<T>(_AValueNameToGet);
  finally
    AJSONValue.Free;
  end;
end;

end.
