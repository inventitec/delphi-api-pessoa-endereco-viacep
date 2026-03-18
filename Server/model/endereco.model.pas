unit endereco.model;

interface

type
  TEndereco = class
  public
    FIdEndereco : Int64;
    FIdPessoa   : Int64;
    FCep        : string;

    property IdEndereco : Int64 read  FIdEndereco write FIdEndereco;
    property IdPessoa   : Int64 read  FIdPessoa   write FIdPessoa;
    property Cep        : string read FCep        write FCep;
  end;

implementation

end.
