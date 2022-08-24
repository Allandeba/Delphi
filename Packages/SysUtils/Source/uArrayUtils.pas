unit uArrayUtils;

interface

uses
  Generics.Collections;

type
  TArrayUtils = class
    class function ContainsValue(_AValue: Integer; _AArray: TArray<Integer>): Boolean; overload;
    class function ContainsValue(_AValue: String; _AArray: TArray<String>): Boolean; overload;
  end;

implementation

{ TArrayUtils }

class function TArrayUtils.ContainsValue(_AValue: Integer; _AArray: TArray<Integer>): Boolean;
var
  AValue: Integer;
begin
  Result := False;

  for AValue in _AArray do
    if AValue = _AValue then
      Exit(True);
end;

class function TArrayUtils.ContainsValue(_AValue: String; _AArray: TArray<String>): Boolean;
var
  AValue: String;
begin
  Result := False;

  for AValue in _AArray do
    if AValue = _AValue then
      Exit(True);
end;

end.
