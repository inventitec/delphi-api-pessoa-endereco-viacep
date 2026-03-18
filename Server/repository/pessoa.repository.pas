unit pessoa.repository;

interface

uses
  FireDAC.Comp.Client,
  pessoa.model,
  System.Generics.Collections, Data.DB;

type
  TPessoaRepository = class
  private
    FConn: TFDConnection;
  public
    constructor Create(AConn: TFDConnection);
    procedure Insert(APessoa: TPessoa);
    procedure InsertBatch(Lista: TObjectList<TPessoa>);
    procedure Delete(AId: Integer);
    procedure Update(P: TPessoa);

    function GetById(AId: Integer): TPessoa;
  end;

implementation
uses Funcoes;

constructor TPessoaRepository.Create(AConn: TFDConnection);
begin
  FConn := AConn;
end;

procedure TPessoaRepository.Insert(APessoa: TPessoa);
var
  qry : TFDQuery;
begin
  qry := TFDQuery.Create(nil);
  qry.Connection := FConn;
  try
    PreparaQry(qry,
      'insert into pessoa (flnatureza, dsdocumento, nmprimeiro, nmsegundo, dtregistro) '+
      'values (:n,:d,:p1,:p2,:dt) returning idpessoa');

    qry.ParamByName('n').AsInteger := APessoa.Natureza;
    qry.ParamByName('d').AsString := APessoa.Documento;
    qry.ParamByName('p1').AsString := APessoa.PrimeiroNome;
    qry.ParamByName('p2').AsString := APessoa.SegundoNome;
    qry.ParamByName('dt').AsDate := APessoa.DtRegistro;

    qry.Open;

    APessoa.IdPessoa := qry.Fields[0].AsLargeInt;
  finally
    qry.Free;
  end;
end;

procedure TPessoaRepository.InsertBatch(Lista: TObjectList<TPessoa>);
var
  i: Integer;
  qry : TFDQuery;
begin
  qry := TFDQuery.Create(nil);
  qry.Connection := FConn;
  try
    PreparaQry(qry,
      'insert into pessoa (flnatureza, dsdocumento, nmprimeiro, nmsegundo, dtregistro) '+
      'values (:n,:d,:p1,:p2,:dt)');

    qry.Params.ArraySize := Lista.Count;

    qry.Params.ParamByName('n').DataType  := ftSmallint;
    qry.Params.ParamByName('d').DataType  := ftString;
    qry.Params.ParamByName('p1').DataType := ftString;
    qry.Params.ParamByName('p2').DataType := ftString;
    qry.Params.ParamByName('dt').DataType := ftDate;

    qry.Prepare;

    for i := 0 to Lista.Count - 1 do
    begin
      qry.ParamByName('n').AsIntegers[i] := Lista[i].Natureza;
      qry.ParamByName('d').AsStrings[i]  := Lista[i].Documento;
      qry.ParamByName('p1').AsStrings[i] := Lista[i].PrimeiroNome;
      qry.ParamByName('p2').AsStrings[i] := Lista[i].SegundoNome;
      qry.ParamByName('dt').AsDates[i]   := Lista[i].DtRegistro;
    end;

    qry.Execute(Lista.Count);
  finally
    qry.Free;
  end;
end;

procedure TPessoaRepository.Delete(AId: Integer);
var
  qry : TFDQuery;
begin
  qry := TFDQuery.Create(nil);
  qry.Connection := FConn;
  try
    PreparaQry(qry, 'delete from pessoa where idpessoa = :id');
    qry.ParamByName('id').AsInteger := AId;
    qry.ExecSQL;
  finally
    qry.Free;
  end;
end;

procedure TPessoaRepository.Update(P: TPessoa);
var
  qry : TFDQuery;
begin
  qry := TFDQuery.Create(nil);
  qry.Connection := FConn;
  try
    PreparaQry(qry,
      'update pessoa set '+
      'flnatureza = :n, dsdocumento = :d, nmprimeiro = :p1, nmsegundo = :p2, dtregistro = :dt '+
      'where idpessoa = :id');

    qry.ParamByName('n').AsInteger  := P.Natureza;
    qry.ParamByName('d').AsString   := P.Documento;
    qry.ParamByName('p1').AsString  := P.PrimeiroNome;
    qry.ParamByName('p2').AsString  := P.SegundoNome;
    qry.ParamByName('dt').AsDate    := P.DtRegistro;
    qry.ParamByName('id').AsInteger := P.IdPessoa;

    qry.ExecSQL;
  finally
    qry.Free;
  end;
end;

function TPessoaRepository.GetById(AId: Integer): TPessoa;
var
  qry : TFDQuery;
begin
  qry := TFDQuery.Create(nil);
  qry.Connection := FConn;
  try
    Result := TPessoa.Create;

    PreparaQry(qry, 'select * from pessoa where idpessoa = :id');
    qry.ParamByName('id').AsInteger := AId;
    qry.Open;

    if not qry.IsEmpty then
    begin
      Result.IdPessoa     := qry.FieldByName('idpessoa').AsInteger;
      Result.Natureza     := qry.FieldByName('flnatureza').AsInteger;
      Result.Documento    := qry.FieldByName('dsdocumento').AsString;
      Result.PrimeiroNome := qry.FieldByName('nmprimeiro').AsString;
      Result.SegundoNome  := qry.FieldByName('nmsegundo').AsString;
      Result.DtRegistro   := qry.FieldByName('dtregistro').AsDateTime;
    end;
  finally
    qry.Free;
  end;
end;

end.
