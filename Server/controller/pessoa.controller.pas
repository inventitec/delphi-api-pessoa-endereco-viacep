unit pessoa.controller;

interface

procedure RegistrarRotasPessoa;

implementation

uses Horse, REST.Json, pessoa.model, endereco.model, pessoa.service, System.JSON,
  System.Generics.Collections, System.DateUtils, cep.service, System.SysUtils;

procedure RegistrarRotasPessoa;
begin
  // insert simples
  THorse.Post('/pessoas',
    procedure(Req: THorseRequest; Res: THorseResponse)
    var
      Pessoa: TPessoa;
      Endereco: TEndereco;
      Service: TPessoaService;
      Json, ObjPessoa, ObjEndereco: TJSONObject;
    begin
      Json := TJSONObject.ParseJSONValue(Req.Body) as TJSONObject;

      if not Assigned(Json) then
      begin
        Res.Status(400).Send('JSON inválido');
        Exit;
      end;

      Pessoa := TPessoa.Create;
      Endereco := TEndereco.Create;

      try
        //pega objetos internos
        ObjPessoa := Json.GetValue('pessoa') as TJSONObject;
        ObjEndereco := Json.GetValue('endereco') as TJSONObject;

        if not Assigned(ObjPessoa) then
          raise Exception.Create('Objeto pessoa não informado');

        if not Assigned(ObjEndereco) then
          raise Exception.Create('Objeto endereco não informado');

        Pessoa.Natureza     := ObjPessoa.GetValue<Integer>('Natureza');
        Pessoa.Documento    := ObjPessoa.GetValue<string>('Documento');
        Pessoa.PrimeiroNome := ObjPessoa.GetValue<string>('PrimeiroNome');
        Pessoa.SegundoNome  := ObjPessoa.GetValue<string>('SegundoNome');
        Pessoa.DtRegistro   := ISO8601ToDate(ObjPessoa.GetValue<string>('DtRegistro'));

        Endereco.Cep := ObjEndereco.GetValue<string>('Cep');

        Service := TPessoaService.Create;
        try
          Service.Insert(Pessoa, Endereco);
          Res.Status(200).Send('OK');
        finally
          Service.Free;
        end;

      finally
        Pessoa.Free;
        Endereco.Free;
        Json.Free;
      end;

    end);

  // insert em lote
  THorse.Post('/pessoas/lote',
    procedure(Req: THorseRequest; Res: THorseResponse)
    var
      JSONArray: TJSONArray;
      Lista: TObjectList<TPessoa>;
      i: Integer;
      Obj: TJSONObject;
      P: TPessoa;
      Service: TPessoaService;
    begin

      JSONArray := TJSONObject.ParseJSONValue(Req.Body) as TJSONArray;

      Lista := TObjectList<TPessoa>.Create;

      try
        for i := 0 to JSONArray.Count - 1 do
        begin
          Obj := JSONArray.Items[i] as TJSONObject;

          P := TPessoa.Create;

          P.Natureza     := Obj.GetValue<Integer>('Natureza');
          P.Documento    := Obj.GetValue<string>('Documento');
          P.PrimeiroNome := Obj.GetValue<string>('PrimeiroNome');
          P.SegundoNome  := Obj.GetValue<string>('SegundoNome');
          P.DtRegistro   := ISO8601ToDate(Obj.GetValue<string>('DtRegistro'));
          p.CEP          := Obj.GetValue<string>('Cep');

          Lista.Add(P);
        end;

        Service := TPessoaService.Create;
        try
          Service.InsertBatch(Lista);
          Res.Send('OK');
        finally
          Service.Free;
        end;

      finally
        Lista.Free;
        JSONArray.Free;
      end;

    end );


  // atualizar endereco
  THorse.Get('/cep/atualizar',
    procedure(Req: THorseRequest; Res: THorseResponse)
    begin
      TCepService.AtualizarEnderecos;
      Res.Send('Processo iniciado');
    end);


  // deletar registros
  THorse.Delete('/pessoas/:id',
    procedure(Req: THorseRequest; Res: THorseResponse)
    var
      Service: TPessoaService;
      Id: Integer;
    begin
      Id := Req.Params['id'].ToInteger;

      Service := TPessoaService.Create;
      try
        Service.Delete(Id);
        Res.Status(200).Send('Excluído');
      finally
        Service.Free;
      end;
    end);


  // atualizar registro
  THorse.Put('/pessoas/:id',
    procedure(Req: THorseRequest; Res: THorseResponse)
    var
      Service: TPessoaService;
      Id: Integer;
      Json, ObjPessoa, ObjEndereco: TJSONObject;
      Pessoa: TPessoa;
      Endereco: TEndereco;
    begin
      Id := Req.Params['id'].ToInteger;

      Json := TJSONObject.ParseJSONValue(Req.Body) as TJSONObject;

      Pessoa := TPessoa.Create;
      Endereco := TEndereco.Create;

      try
        ObjPessoa := Json.GetValue('pessoa') as TJSONObject;
        ObjEndereco := Json.GetValue('endereco') as TJSONObject;

        Pessoa.IdPessoa     := Id;
        Pessoa.Natureza     := ObjPessoa.GetValue<Integer>('Natureza');
        Pessoa.Documento    := ObjPessoa.GetValue<string>('Documento');
        Pessoa.PrimeiroNome := ObjPessoa.GetValue<string>('PrimeiroNome');
        Pessoa.SegundoNome  := ObjPessoa.GetValue<string>('SegundoNome');
        Pessoa.DtRegistro   := ISO8601ToDate(ObjPessoa.GetValue<string>('DtRegistro'));

        Endereco.Cep := ObjEndereco.GetValue<string>('Cep');

        Service := TPessoaService.Create;
        try
          Service.Update(Pessoa, Endereco);
          Res.Status(200).Send('Atualizado');
        finally
          Service.Free;
        end;

      finally
        Pessoa.Free;
        Endereco.Free;
        Json.Free;
      end;
    end);

  // pesquisar registro
  THorse.Get('/pessoas/:id',
    procedure(Req: THorseRequest; Res: THorseResponse)
    var
      Service: TPessoaService;
      Id: Integer;
      Pessoa: TPessoa;
      Endereco: TEndereco;
      Json, ObjPessoa, ObjEndereco: TJSONObject;
    begin
      Id := Req.Params['id'].ToInteger;

      Service := TPessoaService.Create;
      try
        Service.GetById(Id, Pessoa, Endereco);

        if not Assigned(Pessoa) then
        begin
          Res.Status(404).Send('Registro não encontrado');
          Exit;
        end;

        ObjPessoa := TJSONObject.Create;
        ObjPessoa.AddPair('Natureza', TJSONNumber.Create(Pessoa.Natureza));
        ObjPessoa.AddPair('Documento', Pessoa.Documento);
        ObjPessoa.AddPair('PrimeiroNome', Pessoa.PrimeiroNome);
        ObjPessoa.AddPair('SegundoNome', Pessoa.SegundoNome);
        ObjPessoa.AddPair('DtRegistro', DateToStr(Pessoa.DtRegistro));

        ObjEndereco := TJSONObject.Create;
        ObjEndereco.AddPair('Cep', Endereco.Cep);

        Json := TJSONObject.Create;
        Json.AddPair('pessoa', ObjPessoa);
        Json.AddPair('endereco', ObjEndereco);

        Res.ContentType('application/json');
        Res.Send(Json.ToString);

      finally
        Service.Free;
      end;
    end);
end;

end.
