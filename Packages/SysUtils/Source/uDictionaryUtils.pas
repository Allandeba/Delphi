unit uDictionaryUtils;

interface

uses
  Generics.Collections;

type
  TDictionaryUtils = class
  public
    class procedure AtualizaValor(_Dictionary: TDictionary<Integer, Integer>; _Value: Integer);
  end;

implementation

{ TDictionaryUtils }

class procedure TDictionaryUtils.AtualizaValor(_Dictionary: TDictionary<Integer, Integer>; _Value: Integer);
var
  APair: TPair<Integer, Integer>;
  AQtdRepetido: Integer;
begin
  APair := _Dictionary.ExtractPair(_Value);
  AQtdRepetido := APair.Value;
  Inc(AQtdRepetido);

  _Dictionary.Remove(APair.Key);
  _Dictionary.Add(APair.Key, AQtdRepetido);
end;

end.
