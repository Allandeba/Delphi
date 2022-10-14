unit uStrHelper;

interface

uses
  Vcl.Controls, Vcl.ExtCtrls;

type

  TStringHelper = record helper for String
    function IsEmpty: Boolean;
  end;

  TCaptionHelper = record helper for TCaption
    function IsEmpty: Boolean;
  end;

  TLabedEditHelper = class helper for TCustomLabeledEdit
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

{ TLabedEditHelper }

function TLabedEditHelper.IsEmpty: Boolean;
begin
  Result := Length(Trim(Text)) = 0;
end;

end.
