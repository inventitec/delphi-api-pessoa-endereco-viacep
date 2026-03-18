unit connection.factory;

interface

uses
  FireDAC.Comp.Client,
  FireDAC.Phys.PG,
  FireDAC.Phys.PGDef,
  FireDAC.Stan.Def,
  FireDAC.Stan.Async,
  FireDAC.DApt;

type
  TConnectionFactory = class
  public
    class function GetConnection: TFDConnection;
  end;

implementation

class function TConnectionFactory.GetConnection: TFDConnection;
begin
  Result                 := TFDConnection.Create(nil);
  Result.DriverName      := 'PG';
  Result.Params.Database := 'Teste';
  Result.Params.UserName := 'postgres';
  Result.Params.Password := 'postgres';
  Result.Params.Add('Server=localhost');
  Result.Params.Add('Port=5432');
  Result.Connected       := True;
end;

end.
