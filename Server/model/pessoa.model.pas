unit pessoa.model;

interface

type
  TPessoa = class
  public

    FNatureza     : Integer;
    FDtRegistro   : TDate;
    FCEP          : string;
    FDocumento    : string;
    FIdPessoa     : Int64;
    FPrimeiroNome : string;
    FSegundoNome  : string;

    property IdPessoa     : Int64   read FIdPessoa     write FIdPessoa;
    property Natureza     : Integer read FNatureza     write FNatureza;
    property Documento    : string  read FDocumento    write FDocumento;
    property PrimeiroNome : string  read FPrimeiroNome write FPrimeiroNome;
    property SegundoNome  : string  read FSegundoNome  write FSegundoNome;
    property DtRegistro   : TDate   read FDtRegistro   write FDtRegistro;
    property CEP          : string  read FCEP          write FCEP;
  end;

implementation

end.





