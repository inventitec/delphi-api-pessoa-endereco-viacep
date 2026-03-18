program Server;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  Vcl.Dialogs,
  Horse,
  System.SysUtils,
  FireDAC.Phys.PG,
  FireDAC.Phys.PGDef,
  FireDAC.Stan.Def,
  FireDAC.Stan.Async,
  FireDAC.DApt,
  pessoa.controller in 'controller\pessoa.controller.pas',
  connection.factory in 'database\connection.factory.pas',
  endereco.model in 'model\endereco.model.pas',
  pessoa.model in 'model\pessoa.model.pas',
  endereco.repository in 'repository\endereco.repository.pas',
  pessoa.repository in 'repository\pessoa.repository.pas',
  pessoa.service in 'service\pessoa.service.pas',
  cep.service in 'service\cep.service.pas',
  Funcoes in 'Uteis\Funcoes.pas',
  cep.thread in 'thread\cep.thread.pas';

begin
  try
    RegistrarRotasPessoa;

    //MIDDLEWARE GLOBAL DE ERRO
    THorse.Use(
      procedure(Req: THorseRequest; Res: THorseResponse; Next: TProc)
      begin
        try
          Next();
        except
          on E: Exception do
            Res.Status(500).Send(E.Message);
        end;
      end
    );

    // INICIA THREAD
    TCepThread.Create(False);

    //SOBE SERVIDOR
    THorse.Listen(9000);

    Writeln('Server rodando na porta 9000');
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
