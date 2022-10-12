unit uJSON;

interface

type
  TJSONUtils<T> = class
  private
    class function DecodeBase64(_Content: String): String;
  public
    class function Parse(_ValueNameToGet: String; _ContentToParse: Variant; _WhereToFindIt: String; _Decode64: Boolean): T; overload;
    class function Parse(_ValueNameToGet: String; _ContentToParse: Variant; _Decode64: Boolean): T; overload;
  end;

implementation

uses
  JSON, NetEncoding, uStrHelper;

{ TJSONUtils<T> }

class function TJSONUtils<T>.Parse(_ValueNameToGet: String; _ContentToParse: Variant; _WhereToFindIt: String; _Decode64: Boolean): T;
var
  AContent: String;
  AJSONValue: TJSonValue;
  AJSONArray: TJSONArray;
  AArrayElement: TJSONValue;
  AJSONValueInside: TJSONValue;
begin
  // Todo: If needs to get values from all arrays values, must do different.
  AContent := _ContentToParse;

  if _Decode64 then
    AContent := DecodeBase64(AContent);

  if _WhereToFindIt.IsEmpty then
    Result := Parse(_ValueNameToGet, AContent, False)
  else
  begin
    AJSONValue := TJSonObject.ParseJSONValue(AContent);
    try
      if AJSONValue is TJSONArray then
      begin
        AJSONArray := (AJSONValue as TJSONArray);
        for AArrayElement in AJSONArray do
          if AArrayElement.TryGetValue<TJSONValue>(_WhereToFindIt, AJSONValueInside) then
            Result := Parse(_ValueNameToGet, AJSONValueInside.ToString, False)
      end
      else
      begin
        if AJSONValue.TryGetValue<TJSONValue>(_WhereToFindIt, AJSONValueInside) then
          Result := Parse(_ValueNameToGet, AJSONValueInside.ToString, False)
      end;
    finally
      AJSONValue.Free;
    end;
  end;
end;

class function TJSONUtils<T>.DecodeBase64(_Content: String): String;
begin
  Result := TBase64Encoding.Base64.Decode(_Content);
end;

class function TJSONUtils<T>.Parse(_ValueNameToGet: String; _ContentToParse: Variant; _Decode64: Boolean): T;
var
  AContent: String;
  AJSONValue: TJSonValue;
  AJSONArray: TJSONArray;
  AArrayElement: TJSONValue;
begin
  AContent := _ContentToParse;

  if _Decode64 then
    AContent := DecodeBase64(AContent);

  AJSONValue := TJSonObject.ParseJSONValue(AContent);
  try
    if AJSONValue is TJSONArray then
    begin
      AJSONArray := (AJSONValue as TJSONArray);
      for AArrayElement in AJSONArray do
        if AArrayElement.TryGetValue<T>(_ValueNameToGet, Result) then
          Break;
    end
    else
      Result := AJSONValue.GetValue<T>(_ValueNameToGet);
  finally
    AJSONValue.Free;
  end;
end;

end.
