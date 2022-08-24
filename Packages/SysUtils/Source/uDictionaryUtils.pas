unit uDictionaryUtils;

interface

uses
  Generics.Collections;

type
  TDictionaryUtils = class
  public
    class procedure AtualizaValor(_ADictionary: TDictionary<Integer, Integer>; _AValor: Integer);
  end;

implementation

{ TDictionaryUtils }

class procedure TDictionaryUtils.AtualizaValor(_ADictionary: TDictionary<Integer, Integer>; _AValor: Integer);
var
  APair: TPair<Integer, Integer>;
  AQtdRepetido: Integer;
begin
  APair := _ADictionary.ExtractPair(_AValor);
  AQtdRepetido := APair.Value;
  Inc(AQtdRepetido);

  _ADictionary.Remove(APair.Key);
  _ADictionary.Add(APair.Key, AQtdRepetido);
end;

end.
