unit uStrHelper;

interface

uses
  Vcl.Controls, System.SysUtils, System.MaskUtils;

type
  TStringHelper = record helper for String
    function IsEmpty: Boolean;
  end;

  TCaptionHelper = record helper for TCaption
    function IsEmpty: Boolean;
    function Trim: string;
  end;

  TUnicodeStringHelper = record helper for UnicodeString
    function Trim: string;
    function IsEmpty: Boolean;
  end;

  TMaskedTextHelper = record helper for TMaskedText
    function Trim: string;
    function IsEmpty: Boolean;
  end;

implementation

{ TStringHelper }

function TStringHelper.IsEmpty: Boolean;
begin
  Result := Length(System.SysUtils.Trim(Self)) = 0;
end;

{ TCaptionHelper }

function TCaptionHelper.IsEmpty: Boolean;
begin
  Result := Length(System.SysUtils.Trim(Self)) = 0;
end;

function TCaptionHelper.Trim: string;
begin
  Result := System.SysUtils.Trim(Self);
end;

{ TUnicodeStringHelper }

function TUnicodeStringHelper.Trim: String;
begin
  Result := System.SysUtils.Trim(Self);
end;

function TUnicodeStringHelper.IsEmpty: Boolean;
begin
  Result := Length(Self.Trim) = 0;
end;

{ TMaskedTextHelper }

function TMaskedTextHelper.Trim: string;
begin
  Result := System.SysUtils.Trim(Self);
end;

function TMaskedTextHelper.IsEmpty: Boolean;
begin
  Result := Length(Self.Trim) = 0;
end;

end.
