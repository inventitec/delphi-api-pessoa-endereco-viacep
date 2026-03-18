unit uPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes,
  Vcl.Controls, Vcl.Forms, Vcl.StdCtrls, Vcl.Dialogs, Vcl.ComCtrls,
  Vcl.Mask, Vcl.ExtCtrls, System.Net.HttpClient, System.JSON;

type
  TfrmPrincipal = class(TForm)
    pnlEnviar: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    edtNatureza: TEdit;
    edtDocumento: TEdit;
    edtPrimeiroNome: TEdit;
    edtSegundoNome: TEdit;
    edtCep: TMaskEdit;
    edtData: TDateTimePicker;
    btnEnviar: TButton;
    pnlEnviarLote: TPanel;
    btnLote: TButton;
    edtQtdLote: TEdit;
    Label7: TLabel;
    pnlBusca: TPanel;
    btnBusca: TButton;
    edtId: TEdit;
    Label8: TLabel;
    btnAtualizar: TButton;
    btnExcluir: TButton;
    procedure btnEnviarClick(Sender: TObject);
    procedure btnLoteClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnBuscaClick(Sender: TObject);
    procedure btnAtualizarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);

  private
    procedure LimparDados;
  public
    { Public declarations }


  end;
var
  frmPrincipal: TfrmPrincipal;

implementation

uses client.service, Funcoes;

{$R *.dfm}

procedure TfrmPrincipal.btnAtualizarClick(Sender: TObject);
begin
  if Trim(edtNatureza.Text) = EmptyStr then
  begin
    ShowMessage('Preencha o campo "Natureza".');

    SetarFoco(edtNatureza);

    Exit;
  end;

  if Trim(edtDocumento.Text) = EmptyStr then
  begin
    ShowMessage('Preencha o campo "Documento".');

    SetarFoco(edtDocumento);

    Exit;
  end;

  if Trim(tiraoquequiser(edtCep.Text,'.-')) = EmptyStr then
  begin
    ShowMessage('Preencha o campo "CEP".');

    SetarFoco(edtCep);

    Exit;
  end;

  if Trim(edtPrimeiroNome.Text) = EmptyStr then
  begin
    ShowMessage('Preencha o campo "Primeiro nome".');

    SetarFoco(edtPrimeiroNome);

    Exit;
  end;

  if Trim(edtSegundoNome.Text) = EmptyStr then
  begin
    ShowMessage('Preencha o campo "Segundo nome".');

    SetarFoco(edtSegundoNome);

    Exit;
  end;

  try
    TClientService.UpdatePessoa(
      StrToInt(edtId.Text),
      StrToIntDef(edtNatureza.Text, 0),
      edtDocumento.Text,
      edtPrimeiroNome.Text,
      edtSegundoNome.Text,
      FormatDateTime('yyyy-mm-dd', edtData.Date),
      edtCep.Text
    );

    ShowMessage('Registro atualizado com sucesso!');

    LimparDados;

    btnAtualizar.Enabled := False;
    btnExcluir.Enabled   := False;
    btnEnviar.Enabled    := True;
  except
    on E: Exception do
      ShowMessage(E.Message);
  end;
end;

procedure TfrmPrincipal.btnBuscaClick(Sender: TObject);
var
  JsonStr: string;
  Json, ObjPessoa, ObjEndereco: TJSONObject;
begin
  try
    if StrToIntDef(edtId.Text,0) = 0 then
    begin
      ShowMessage('Informe o ID');
      Exit;
    end;

    btnAtualizar.Enabled := True;
    btnExcluir.Enabled   := True;
    btnEnviar.Enabled    := False;

    TClientService.BuscarPessoa(StrToInt(edtId.Text), JsonStr);

    Json := TJSONObject.ParseJSONValue(JsonStr) as TJSONObject;

    if not Assigned(Json) then
      raise Exception.Create('Resposta inválida da API');

    try
      //valida pessoa
      ObjPessoa := Json.GetValue('pessoa') as TJSONObject;

      if not Assigned(ObjPessoa) then
      begin
        raise Exception.Create('Registro não encontrado');
      end;

      // valida endereco
      ObjEndereco := Json.GetValue('endereco') as TJSONObject;

      // preenche tela
      edtNatureza.Text     := ObjPessoa.GetValue<string>('Natureza');
      edtDocumento.Text    := ObjPessoa.GetValue<string>('Documento');
      edtPrimeiroNome.Text := ObjPessoa.GetValue<string>('PrimeiroNome');
      edtSegundoNome.Text  := ObjPessoa.GetValue<string>('SegundoNome');
      edtData.Date         := StrToDate(ObjPessoa.GetValue<string>('DtRegistro'));

      if Assigned(ObjEndereco) then
        edtCep.Text := ObjEndereco.GetValue<string>('Cep')
      else
        edtCep.Clear;

    finally
      Json.Free;
    end;
  except
    on E: Exception do
    begin
      btnAtualizar.Enabled := False;
      btnExcluir.Enabled   := False;
      btnEnviar.Enabled    := True;
      ShowMessage(E.Message);
    end;
  end;
end;

procedure TfrmPrincipal.btnEnviarClick(Sender: TObject);
begin
  if Trim(edtNatureza.Text) = EmptyStr then
  begin
    ShowMessage('Preencha o campo "Natureza".');

    SetarFoco(edtNatureza);

    Exit;
  end;

  if Trim(edtDocumento.Text) = EmptyStr then
  begin
    ShowMessage('Preencha o campo "Documento".');

    SetarFoco(edtDocumento);

    Exit;
  end;

  if Trim(tiraoquequiser(edtCep.Text,'.-')) = EmptyStr then
  begin
    ShowMessage('Preencha o campo "CEP".');

    SetarFoco(edtCep);

    Exit;
  end;

  if Trim(edtPrimeiroNome.Text) = EmptyStr then
  begin
    ShowMessage('Preencha o campo "Primeiro nome".');

    SetarFoco(edtPrimeiroNome);

    Exit;
  end;

  if Trim(edtSegundoNome.Text) = EmptyStr then
  begin
    ShowMessage('Preencha o campo "Segundo nome".');

    SetarFoco(edtSegundoNome);

    Exit;
  end;

  try
    TClientService.EnviarPessoa(
      StrToIntDef(edtNatureza.Text, 0),
      edtDocumento.Text,
      edtPrimeiroNome.Text,
      edtSegundoNome.Text,
      FormatDateTime('yyyy-mm-dd', edtData.Date),
      edtCep.Text
    );

    ShowMessage('Enviado!');

    LimparDados;
  except
    on E: Exception do
    begin
      ShowMessage(E.Message);
    end;
  end;
end;

procedure TfrmPrincipal.btnExcluirClick(Sender: TObject);
begin
  try
    if MessageDlg('Deseja realmente excluir?', mtConfirmation, [mbYes, mbNo], 0) = mrNo then
      Exit;

    TClientService.DeletePessoa(StrToInt(edtId.Text));

    ShowMessage('Registro excluído com sucesso!');

    limparDados;

    btnAtualizar.Enabled := False;
    btnExcluir.Enabled   := False;
    btnEnviar.Enabled    := True;
  except
    on E: Exception do
      ShowMessage(E.Message);
  end;
end;

procedure TfrmPrincipal.btnLoteClick(Sender: TObject);
begin
  if StrToIntDef(edtQtdLote.Text, 0) > 0 then
  begin
    btnLote.Enabled := False;
    btnLote.Caption := 'Aguarde...';

    TThread.CreateAnonymousThread(
      procedure
      begin
        try
          TClientService.EnviarLote(StrToIntDef(edtQtdLote.Text, 0));

          TThread.Synchronize(nil,
            procedure
            begin
              ShowMessage('Lote enviado!');
            end);

        finally
          TThread.Synchronize(nil,
            procedure
            begin
              btnLote.Enabled := True;
              btnLote.Caption := 'Enviar Lote';
            end);
        end;
      end
    ).Start;
  end
  else
  begin
    ShowMessage('Preencha o campo "Quantidade de registros".');
    SetarFoco(edtQtdLote);
  end;

end;

procedure TfrmPrincipal.FormShow(Sender: TObject);
begin
  edtData.Date := Date;
end;

procedure TfrmPrincipal.LimparDados;
begin
  edtId.Clear;
  edtNatureza.Clear;
  edtDocumento.Clear;
  edtPrimeiroNome.Clear;
  edtSegundoNome.Clear;
  edtCep.Clear;
  edtData.Date := Date;
end;

end.
