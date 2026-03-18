unit pessoa.service;

interface

uses
  pessoa.model,
  endereco.model,
  FireDAC.Comp.Client,
  System.Generics.Collections;

type
  TPessoaService = class
  private
    FConn: TFDConnection;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Insert(APessoa: TPessoa; AEndereco: TEndereco);
    procedure InsertBatch(Lista: TObjectList<TPessoa>);

    procedure Delete(AId: Integer);
    procedure Update(Pessoa: TPessoa; Endereco: TEndereco);

    procedure GetById(AId: Integer; out Pessoa: TPessoa;
      out Endereco: TEndereco);
  end;

implementation

uses connection.factory, pessoa.repository, endereco.repository;

constructor TPessoaService.Create;
begin
  FConn := TConnectionFactory.GetConnection;
end;

destructor TPessoaService.Destroy;
begin
  FConn.Free;
  inherited;
end;

procedure TPessoaService.Insert(APessoa: TPessoa; AEndereco: TEndereco);
var
  RepoP: TPessoaRepository;
  RepoE: TEnderecoRepository;
begin
  RepoP := TPessoaRepository.Create(FConn);
  RepoE := TEnderecoRepository.Create(FConn);

  FConn.StartTransaction;
  try
    RepoP.Insert(APessoa);

    AEndereco.IdPessoa := APessoa.IdPessoa;

    RepoE.Insert(AEndereco);

    FConn.Commit;
  except
    FConn.Rollback;
    raise;
  end;
end;

procedure TPessoaService.InsertBatch(Lista: TObjectList<TPessoa>);
var
  RepoPessoa: TPessoaRepository;
  RepoEndereco: TEnderecoRepository;
  P: TPessoa;
  Endereco: TEndereco;
begin
  RepoPessoa := TPessoaRepository.Create(FConn);
  RepoEndereco := TEnderecoRepository.Create(FConn);

  try
    for P in Lista do
    begin
      // cria endereço para cada pessoa
      Endereco := TEndereco.Create;
      try
        Endereco.Cep := P.Cep;

        // usa o fluxo já existente (garante consistência)
        RepoPessoa.Insert(P);

        Endereco.IdPessoa := P.IdPessoa;

        RepoEndereco.Insert(Endereco);

      finally
        Endereco.Free;
      end;
    end;

  finally
    RepoPessoa.Free;
    RepoEndereco.Free;
  end;
end;

procedure TPessoaService.Delete(AId: Integer);
var
  RepoP: TPessoaRepository;
  RepoE: TEnderecoRepository;
begin
  RepoP := TPessoaRepository.Create(FConn);
  RepoE := TEnderecoRepository.Create(FConn);

  try
    RepoE.DeleteByPessoa(AId);
    RepoP.Delete(AId);
  finally
    RepoP.Free;
    RepoE.Free;
  end;
end;

procedure TPessoaService.Update(Pessoa: TPessoa; Endereco: TEndereco);
var
  RepoP: TPessoaRepository;
  RepoE: TEnderecoRepository;
begin
  RepoP := TPessoaRepository.Create(FConn);
  RepoE := TEnderecoRepository.Create(FConn);

  try
    RepoP.Update(Pessoa);
    RepoE.UpdateByPessoa(Pessoa.IdPessoa, Endereco);
  finally
    RepoP.Free;
    RepoE.Free;
  end;
end;

procedure TPessoaService.GetById(AId: Integer; out Pessoa: TPessoa; out Endereco: TEndereco);
var
  RepoP: TPessoaRepository;
  RepoE: TEnderecoRepository;
begin
  RepoP := TPessoaRepository.Create(FConn);
  RepoE := TEnderecoRepository.Create(FConn);

  try
    Pessoa   := RepoP.GetById(AId);
    Endereco := RepoE.GetByPessoa(AId);
  finally
    RepoP.Free;
    RepoE.Free;
  end;
end;

end.
