unit cep.service;

interface

type
  TCepService = class
  public
    class procedure AtualizarEnderecos;
  end;

implementation

uses
  System.Threading,
  System.SysUtils,
  System.Net.HttpClient,
  System.JSON,
  FireDAC.Comp.Client,
  connection.factory,
  endereco.repository,
  Funcoes;

class procedure TCepService.AtualizarEnderecos;
var
  Conn: TFDConnection;
  Query: TFDQuery;
  Http: THTTPClient;
  Response: IHTTPResponse;
  Json: TJSONObject;
  Cep: string;
  Repo: TEnderecoRepository;
  IdEndereco: Int64;
  Logradouro, Bairro, Cidade, UF, Complemento: string;
begin
  Conn := TConnectionFactory.GetConnection;
  Http := THTTPClient.Create;

  try
    Repo := TEnderecoRepository.Create(Conn);

    //SOMENTE PENDENTES
    Query := Repo.ListarEnderecosPendentes;

    try
      while not Query.Eof do
      begin
        Cep := Query.FieldByName('dscep').AsString;
        IdEndereco := Query.FieldByName('idendereco').AsLargeInt;

        // limpa CEP
        Cep := SomenteNumeros(Cep);

        try
          Response := Http.Get('https://viacep.com.br/ws/' + Cep + '/json');

          Json := TJSONObject.ParseJSONValue(Response.ContentAsString) as TJSONObject;

          if Assigned(Json) then
          begin
            try
              if not Json.GetValue<Boolean>('erro', False) then
              begin
                Logradouro := Json.GetValue<string>('logradouro');
                Bairro     := Json.GetValue<string>('bairro');
                Cidade     := Json.GetValue<string>('localidade');
                UF         := Json.GetValue<string>('uf');
                Complemento := '';

                Repo.InserirIntegracao(
                  IdEndereco,
                  Logradouro,
                  Bairro,
                  Cidade,
                  UF,
                  Complemento
                );
              end;
            finally
              Json.Free;
            end;
          end;

        except
          // evita parar o loop
        end;

        Query.Next;
      end;

    finally
      Query.Free;
      Repo.Free;
    end;

  finally
    Http.Free;
    Conn.Free;
  end;
end;

end.
