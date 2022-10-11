unit uArrayUtils;

interface

uses
  Generics.Collections;

type
  TArrayUtils = class
    class function ContainsValue(_Value: Integer; _Array: TArray<Integer>): Boolean; overload;
    class function ContainsValue(_Value: String; _Array: TArray<String>): Boolean; overload;
  end;

implementation

{ TArrayUtils }

class function TArrayUtils.ContainsValue(_Value: Integer; _Array: TArray<Integer>): Boolean;
var
  AValue: Integer;
begin
  Result := False;

  for AValue in _Array do
    if AValue = _Value then
      Exit(True);
end;

class function TArrayUtils.ContainsValue(_Value: String; _Array: TArray<String>): Boolean;
var
  AValue: String;
begin
  Result := False;

  for AValue in _Array do
    if AValue = _Value then
      Exit(True);
end;

end.
