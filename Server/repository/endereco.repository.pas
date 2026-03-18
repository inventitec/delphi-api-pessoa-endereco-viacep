unit endereco.repository;

interface

uses FireDAC.Comp.Client, endereco.model;

type
  TEnderecoRepository = class
  private
    FConn: TFDConnection;
  public
    constructor Create(AConn: TFDConnection);
    procedure Insert(AEnd: TEndereco);
    procedure InserirIntegracao(AIdEndereco: Int64; ALogradouro, ABairro,
      ACidade, AUF, AComplemento: string);
    procedure DeleteByPessoa(AIdPessoa: Integer);
    procedure UpdateByPessoa(AIdPessoa: Integer; Endereco: TEndereco);

    function ListarEnderecos: TFDQuery;
    function ListarEnderecosPendentes: TFDQuery;
    function ExisteIntegracao(AIdEndereco: Int64): Boolean;

    function GetByPessoa(AIdPessoa: Integer): TEndereco;
  end;

implementation
uses Funcoes, System.SysUtils;

constructor TEnderecoRepository.Create(AConn: TFDConnection);
begin
  FConn := AConn;
end;

procedure TEnderecoRepository.Insert(AEnd: TEndereco);
var
  qry : TFDQuery;
begin
  qry := TFDQuery.Create(nil);
  qry.Connection := FConn;
  try
    PreparaQry(qry,
      'insert into endereco (idpessoa, dscep) values (:id,:cep)');

    qry.ParamByName('id').AsLargeInt := AEnd.IdPessoa;
    qry.ParamByName('cep').AsString := AEnd.Cep;

    qry.ExecSQL;
  finally
    qry.Free;
  end;
end;

function TEnderecoRepository.ListarEnderecos: TFDQuery;
begin
  Result := TFDQuery.Create(nil);
  Result.Connection := FConn;

  Result.SQL.Add('select idendereco, dscep from endereco');
  Result.Open;
end;

procedure TEnderecoRepository.InserirIntegracao(AIdEndereco: Int64;
  ALogradouro, ABairro, ACidade, AUF, AComplemento: string);
var
  qry : TFDQuery;
begin
  qry := TFDQuery.Create(nil);
  qry.Connection := FConn;
  try
    qry.Connection := FConn;

    PreparaQry(qry,
      'insert into endereco_integracao '+
      '(idendereco, nmlogradouro, nmbairro, nmcidade, dsuf, dscomplemento) '+
      'values (:id, :log, :bairro, :cidade, :uf, :comp)');

    qry.ParamByName('id').AsLargeInt   := AIdEndereco;
    qry.ParamByName('log').AsString    := ALogradouro;
    qry.ParamByName('bairro').AsString := ABairro;
    qry.ParamByName('cidade').AsString := ACidade;
    qry.ParamByName('uf').AsString     := AUF;
    qry.ParamByName('comp').AsString   := AComplemento;

    qry.ExecSQL;

  finally
    qry.Free;
  end;
end;

function TEnderecoRepository.ExisteIntegracao(AIdEndereco: Int64): Boolean;
var
  qry : TFDQuery;
begin
  qry := TFDQuery.Create(nil);
  qry.Connection := FConn;
  try
    qry.Connection := FConn;

    PreparaQry(qry,
      'select 1 from endereco_integracao where idendereco = :id');

    qry.ParamByName('id').AsLargeInt := AIdEndereco;

    qry.Open;

    Result := not qry.IsEmpty;

  finally
    qry.Free;
  end;
end;

function TEnderecoRepository.ListarEnderecosPendentes: TFDQuery;
begin
  Result := TFDQuery.Create(nil);
  Result.Connection := FConn;

  Result.SQL.Add(
    'select idendereco, dscep '+
    'from endereco '+
    'where idendereco not in ('+
    '  select idendereco from endereco_integracao'+
    ')');

  Result.Open;
end;

procedure TEnderecoRepository.DeleteByPessoa(AIdPessoa: Integer);
var
  pIDEnd : Integer;
  qry : TFDQuery;
begin
  qry := TFDQuery.Create(nil);
  qry.Connection := FConn;
  try
    // pegar o id do endereco
    PreparaQry(qry, 'select * from endereco where idpessoa = :id');
    qry.ParamByName('id').AsInteger := AIdPessoa;
    qry.Open;

    pIDEnd := qry.FieldByName('idendereco').AsInteger;

    // deletar o endereco integracao
    PreparaQry(qry, 'delete from endereco_integracao where idendereco = :id');
    qry.ParamByName('id').AsInteger := pIDEnd;
    qry.ExecSQL;

    // deletear endereco
    PreparaQry(qry, 'delete from endereco where idpessoa = :id');
    qry.ParamByName('id').AsInteger := AIdPessoa;
    qry.ExecSQL;
  finally
    qry.Free;
  end;
end;

procedure TEnderecoRepository.UpdateByPessoa(AIdPessoa: Integer; Endereco: TEndereco);
var
  pIDEnd : Integer;
  qry : TFDQuery;
begin
  qry := TFDQuery.Create(nil);
  qry.Connection := FConn;
  try
    // pegar o id do endereco
    PreparaQry(qry, 'select * from endereco where idpessoa = :id');
    qry.ParamByName('id').AsInteger := AIdPessoa;
    qry.Open;

    pIDEnd := qry.FieldByName('idendereco').AsInteger;

    // deletar o endereco integracao
    PreparaQry(qry, 'delete from endereco_integracao where idendereco = :id');
    qry.ParamByName('id').AsInteger := pIDEnd;
    qry.ExecSQL;


    PreparaQry(qry,
      'update endereco set dscep = :cep where idpessoa = :id');

    qry.ParamByName('cep').AsString := Endereco.Cep;
    qry.ParamByName('id').AsInteger := AIdPessoa;

    qry.ExecSQL;
  finally
    qry.Free;
  end;
end;

function TEnderecoRepository.GetByPessoa(AIdPessoa: Integer): TEndereco;
var
  qry : TFDQuery;
begin
  qry := TFDQuery.Create(nil);
  qry.Connection := FConn;
  try
    Result := TEndereco.Create;

    PreparaQry(qry, 'select * from endereco where idpessoa = :id');
    qry.ParamByName('id').AsInteger := AIdPessoa;
    qry.Open;

    if not qry.IsEmpty then
    begin
      Result.Cep := qry.FieldByName('dscep').AsString;
    end;
  finally
    qry.Free;
  end;
end;

end.
