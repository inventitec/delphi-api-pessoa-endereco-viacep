unit Funcoes;

interface
uses Vcl.Controls, FireDAC.Comp.Client;

function SomenteNumeros(const S: string): string;
procedure PreparaQry(pQry: TFDQuery; pSql: string);

implementation

function SomenteNumeros(const S: string): string;
var
  c: Char;
begin
  Result := '';
  for c in S do
    if c in ['0'..'9'] then
      Result := Result + c;
end;

procedure PreparaQry(pQry: TFDQuery; pSql: string);
begin
  pQry.Close;
  pQry.SQL.Clear;
  pQry.Params.Clear;
  pQry.SQL.Add(pSql);
end;

end.
