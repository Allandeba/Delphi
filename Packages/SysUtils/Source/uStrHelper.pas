unit uStrHelper;

interface

uses
  Vcl.Controls;

type

  TStringHelper = record helper for String
    function IsEmpty: Boolean;
  end;

  TCaptionHelper = record helper for TCaption
    function IsEmpty: Boolean;
  end;

implementation

uses
  System.SysUtils;

{ TStringHelper }

function TStringHelper.IsEmpty: Boolean;
begin
  Result := Length(Trim(Self)) = 0;
end;

{ TCaptionHelper }

function TCaptionHelper.IsEmpty: Boolean;
begin
  Result := Length(Trim(Self)) = 0;
end;

end.
