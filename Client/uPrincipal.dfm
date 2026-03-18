object frmPrincipal: TfrmPrincipal
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Client Teste'
  ClientHeight = 407
  ClientWidth = 443
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnlEnviar: TPanel
    Left = 0
    Top = 82
    Width = 443
    Height = 228
    Align = alClient
    TabOrder = 1
    ExplicitTop = 76
    object Label1: TLabel
      Left = 10
      Top = 15
      Width = 46
      Height = 13
      Caption = 'Natureza'
    end
    object Label2: TLabel
      Left = 116
      Top = 15
      Width = 60
      Height = 13
      Caption = 'Documento'
    end
    object Label3: TLabel
      Left = 222
      Top = 15
      Width = 24
      Height = 13
      Caption = 'Data'
    end
    object Label4: TLabel
      Left = 328
      Top = 15
      Width = 19
      Height = 13
      Caption = 'CEP'
    end
    object Label5: TLabel
      Left = 10
      Top = 65
      Width = 74
      Height = 13
      Caption = 'Primeiro nome'
    end
    object Label6: TLabel
      Left = 10
      Top = 115
      Width = 79
      Height = 13
      Caption = 'Segundo nome'
    end
    object edtNatureza: TEdit
      Left = 10
      Top = 30
      Width = 98
      Height = 21
      CharCase = ecUpperCase
      TabOrder = 0
    end
    object edtDocumento: TEdit
      Left = 116
      Top = 30
      Width = 98
      Height = 21
      CharCase = ecUpperCase
      TabOrder = 1
    end
    object edtPrimeiroNome: TEdit
      Left = 10
      Top = 80
      Width = 416
      Height = 21
      CharCase = ecUpperCase
      TabOrder = 4
    end
    object edtSegundoNome: TEdit
      Left = 10
      Top = 130
      Width = 416
      Height = 21
      CharCase = ecUpperCase
      TabOrder = 5
    end
    object edtCep: TMaskEdit
      Left = 328
      Top = 30
      Width = 97
      Height = 21
      EditMask = '99.999-999;1;_'
      MaxLength = 10
      TabOrder = 3
      Text = '37.220-000'
    end
    object edtData: TDateTimePicker
      Left = 222
      Top = 30
      Width = 100
      Height = 21
      Date = 46098.000000000000000000
      Time = 46098.000000000000000000
      TabOrder = 2
    end
    object btnEnviar: TButton
      Left = 10
      Top = 169
      Width = 100
      Height = 25
      Caption = '&Enviar'
      TabOrder = 6
      OnClick = btnEnviarClick
    end
    object btnAtualizar: TButton
      Left = 116
      Top = 169
      Width = 100
      Height = 25
      Caption = '&Atualizar'
      Enabled = False
      TabOrder = 7
      TabStop = False
      OnClick = btnAtualizarClick
    end
    object btnExcluir: TButton
      Left = 222
      Top = 169
      Width = 100
      Height = 25
      Caption = 'E&xcluir'
      Enabled = False
      TabOrder = 8
      TabStop = False
      OnClick = btnExcluirClick
    end
  end
  object pnlEnviarLote: TPanel
    Left = 0
    Top = 310
    Width = 443
    Height = 97
    Align = alBottom
    TabOrder = 2
    ExplicitTop = 277
    ExplicitWidth = 447
    object Label7: TLabel
      Left = 10
      Top = 15
      Width = 125
      Height = 13
      Caption = 'Quantidade de registros'
    end
    object btnLote: TButton
      Left = 166
      Top = 30
      Width = 200
      Height = 25
      Caption = 'Enviar &lote'
      TabOrder = 1
      OnClick = btnLoteClick
    end
    object edtQtdLote: TEdit
      Left = 10
      Top = 30
      Width = 150
      Height = 21
      CharCase = ecUpperCase
      TabOrder = 0
    end
  end
  object pnlBusca: TPanel
    Left = 0
    Top = 0
    Width = 443
    Height = 82
    Align = alTop
    TabOrder = 0
    ExplicitWidth = 561
    object Label8: TLabel
      Left = 10
      Top = 10
      Width = 77
      Height = 13
      Caption = 'C'#243'digo pessoa'
    end
    object btnBusca: TButton
      Left = 179
      Top = 25
      Width = 75
      Height = 25
      Caption = '&Buscar'
      TabOrder = 1
      OnClick = btnBuscaClick
    end
    object edtId: TEdit
      Left = 10
      Top = 25
      Width = 150
      Height = 21
      CharCase = ecUpperCase
      TabOrder = 0
    end
  end
end
