unit pessoa.model;

interface

type
  TPessoa = class
  public
    IdPessoa     : Int64;
    Natureza     : Integer;
    Documento    : string;
    PrimeiroNome : string;
    SegundoNome  : string;
    DtRegistro   : TDate;
    CEP          : string;
  end;

implementation

end.
