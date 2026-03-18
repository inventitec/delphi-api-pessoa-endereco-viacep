unit cep.thread;

interface

uses
  System.Classes;

type
  TCepThread = class(TThread)
  protected
    procedure Execute; override;
  end;

implementation

uses
  System.SysUtils,
  cep.service,
  Winapi.Windows;

procedure TCepThread.Execute;
begin
  while not Terminated do
  begin
    try
      TCepService.AtualizarEnderecos;
    except
      on E: Exception do
        OutputDebugString(PChar(E.Message));
    end;

    Sleep(60000); //roda a cada 60s
  end;
end;

end.
