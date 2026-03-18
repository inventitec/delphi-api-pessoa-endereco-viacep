unit client.service;

interface

type
  TClientService = class
  public

    class procedure DeletePessoa(AId: Integer); static;
    class procedure UpdatePessoa(AId, ANatureza: Integer; ADocumento,
      APrimeiroNome, ASegundoNome, AData, ACep: string); static;
    class procedure EnviarPessoa(
      ANatureza: Integer;
      ADocumento, APrimeiroNome, ASegundoNome, AData, ACep: string);

    class procedure EnviarLote(Qtd: Integer);
    class procedure BuscarPessoa(AId: Integer; out JsonStr: string); static;


  end;

implementation

uses
  System.Net.HttpClient,
  System.JSON,
  System.SysUtils,
  System.Classes;

class procedure TClientService.EnviarPessoa(
  ANatureza: Integer;
  ADocumento, APrimeiroNome, ASegundoNome, AData, ACep: string);
var
  Http: THTTPClient;
  Json, ObjPessoa, ObjEndereco: TJSONObject;
  Response: IHTTPResponse;
  Stream: TStringStream;
begin
  Http := THTTPClient.Create;
  try
    Http.ContentType := 'application/json';

    Json := TJSONObject.Create;
    try
      ObjPessoa := TJSONObject.Create;
      ObjPessoa.AddPair('Natureza', TJSONNumber.Create(ANatureza));
      ObjPessoa.AddPair('Documento', ADocumento);
      ObjPessoa.AddPair('PrimeiroNome', APrimeiroNome);
      ObjPessoa.AddPair('SegundoNome', ASegundoNome);
      ObjPessoa.AddPair('DtRegistro', AData);

      ObjEndereco := TJSONObject.Create;
      ObjEndereco.AddPair('Cep', ACep);

      Json.AddPair('pessoa', ObjPessoa);
      Json.AddPair('endereco', ObjEndereco);

      Stream := TStringStream.Create(Json.ToString, TEncoding.UTF8);
      try
        Response := Http.Post('http://localhost:9000/pessoas', Stream);

        if Response.StatusCode <> 200 then
          raise Exception.Create('Erro: ' + Response.ContentAsString);
      finally
        Stream.Free;
      end;

    finally
      Json.Free;
    end;

  finally
    Http.Free;
  end;
end;

class procedure TClientService.EnviarLote(Qtd: Integer);
var
  Http: THTTPClient;
  JsonArray: TJSONArray;
  Obj: TJSONObject;
  i: Integer;
  Stream: TStringStream;
  Response: IHTTPResponse;
begin
  Http := THTTPClient.Create;
  try
    Http.ContentType := 'application/json';

    JsonArray := TJSONArray.Create;
    try
      for i := 1 to Qtd do
      begin
        Obj := TJSONObject.Create;
        Obj.AddPair('Natureza', TJSONNumber.Create(1));
        Obj.AddPair('Documento', i.ToString);
        Obj.AddPair('PrimeiroNome', 'Nome ' + i.ToString);
        Obj.AddPair('SegundoNome', 'Teste');
        Obj.AddPair('DtRegistro', FormatDateTime('yyyy-mm-dd', Date));
        Obj.AddPair('Cep', '37.220-000');
        JsonArray.AddElement(Obj);
      end;

      Stream := TStringStream.Create(JsonArray.ToString, TEncoding.UTF8);
      try
        Response := Http.Post('http://localhost:9000/pessoas/lote', Stream);

        if Response.StatusCode <> 200 then
          raise Exception.Create('Erro no lote: ' + Response.ContentAsString);
      finally
        Stream.Free;
      end;

    finally
      JsonArray.Free;
    end;

  finally
    Http.Free;
  end;
end;

class procedure TClientService.DeletePessoa(AId: Integer);
var
  Http: THTTPClient;
  Response: IHTTPResponse;
begin
  Http := THTTPClient.Create;
  try
    Response := Http.Delete('http://localhost:9000/pessoas/' + AId.ToString);

    if Response.StatusCode <> 200 then
      raise Exception.Create('Erro ao excluir');
  finally
    Http.Free;
  end;
end;

class procedure TClientService.UpdatePessoa(
  AId: Integer;
  ANatureza: Integer;
  ADocumento, APrimeiroNome, ASegundoNome, AData, ACep: string);
var
  Http: THTTPClient;
  Json, ObjPessoa, ObjEndereco: TJSONObject;
  Response: IHTTPResponse;
  Stream: TStringStream;
begin
  Http := THTTPClient.Create;
  try
    Http.ContentType := 'application/json';

    Json := TJSONObject.Create;
    try
      ObjPessoa := TJSONObject.Create;
      ObjPessoa.AddPair('Natureza', TJSONNumber.Create(ANatureza));
      ObjPessoa.AddPair('Documento', ADocumento);
      ObjPessoa.AddPair('PrimeiroNome', APrimeiroNome);
      ObjPessoa.AddPair('SegundoNome', ASegundoNome);
      ObjPessoa.AddPair('DtRegistro', AData);

      ObjEndereco := TJSONObject.Create;
      ObjEndereco.AddPair('Cep', ACep);

      Json.AddPair('pessoa', ObjPessoa);
      Json.AddPair('endereco', ObjEndereco);

      Stream := TStringStream.Create(Json.ToString, TEncoding.UTF8);
      try
        Response := Http.Put(
          'http://localhost:9000/pessoas/' + AId.ToString,
          Stream
        );

        if Response.StatusCode <> 200 then
          raise Exception.Create('Erro ao atualizar');

      finally
        Stream.Free;
      end;

    finally
      Json.Free;
    end;

  finally
    Http.Free;
  end;
end;

class procedure TClientService.BuscarPessoa(AId: Integer; out JsonStr: string);
var
  Http: THTTPClient;
  Response: IHTTPResponse;
begin
  Http := THTTPClient.Create;
  try
    Response := Http.Get('http://localhost:9000/pessoas/' + AId.ToString);

    case Response.StatusCode of
      200:
        JsonStr := Response.ContentAsString;

      404:
        raise Exception.Create('Registro não encontrado');

    else
      raise Exception.Create('Erro na API: ' + Response.ContentAsString);
    end;

  finally
    Http.Free;
  end;
end;

end.
