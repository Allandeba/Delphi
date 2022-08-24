unit uClassUtils;

interface

type

  TObjectHelper = class helper for TObject
    function Clone: TObject;
  end;

implementation

uses
  System.JSON, DBXJSON, DBXJSONReflect;

{ TObjectHelper }

function TObjectHelper.Clone: TObject;
var
  AMarshalObj: TJSONMarshal;
  AUnMarshalObj: TJSONUnMarshal;
  AJSONValue: TJSONValue;
begin
  Result := nil;

  AMarshalObj := TJSONMarshal.Create;
  try
    AUnMarshalObj := TJSONUnMarshal.Create;
    try
      AJSONValue := AMarshalObj.Marshal(Self);
      try
        if Assigned(AJSONValue) then
          Result:= AUnMarshalObj.Unmarshal(AJSONValue);
      finally
        AJSONValue.Free;
      end;
    finally
      AUnMarshalObj.Free;
    end;
  finally
    AMarshalObj.Free;
  end;
end;

end.
