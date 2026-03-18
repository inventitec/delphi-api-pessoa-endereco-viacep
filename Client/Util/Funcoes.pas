unit Funcoes;

interface

uses
  Vcl.Controls, FireDAC.Comp.Client, System.SysUtils;

procedure SetarFoco(pComponente: TWinControl);
procedure PreparaQry(pQry: TFDQuery; pSql: string);
function tiraoquequiser(str,tiraoque : string): string;

implementation

procedure SetarFoco(pComponente: TWinControl);
begin
  if pComponente.CanFocus then
    pComponente.SetFocus;
end;

procedure PreparaQry(pQry: TFDQuery; pSql: string);
begin
  pQry.Close;
  pQry.SQL.Clear;
  pQry.SQL.Add(pSql);
end;

function tiraoquequiser(str,tiraoque : string): string;
var
   i: integer;
begin
  for i := 1 to length(tiraoque) do
    while pos(tiraoque[i],str)>0 do
      delete(str,pos(tiraoque[i],str),1);

  result:=str;
end;

end.
