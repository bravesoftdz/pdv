unit uCompValor;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Buttons, ExtCtrls,
  EditBtn, StdCtrls, DBCtrls, db;

type

  { TfCompValor }

  TfCompValor = class(TForm)
    BitBtn1: TBitBtn;
    btnOk: TBitBtn;
    dbCompNome: TDBEdit;
    dbValComp: TDBEdit;
    Label1: TLabel;
    Label2: TLabel;
    procedure BitBtn1Click(Sender: TObject);
    procedure btnEditaClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private

  public
    fvalor : integer;
  end;

var
  fCompValor: TfCompValor;

implementation

uses udmpdv, uDmCte;

{$R *.lfm}

{ TfCompValor }

procedure TfCompValor.btnOkClick(Sender: TObject);
var vstr_sql :string;
  num_cod_comp: Integer;
begin
  vstr_sql := '';
  FormatSettings.DecimalSeparator := '.';
  if (dmCte.dsComp.State in [dsInsert]) then
  begin
    if (dmCte.sqCompCOMP_NOME.AsString <> '') then
    begin
      num_cod_comp := dmPdv.busca_generator('GEN_CTE_COMP_ID');
      vstr_sql := 'INSERT INTO CTE_COMP (COD_CTE_COMP, COD_CTE ,COMP_NOME, ' +
        ' COMP_VALOR) VALUES ( ' + IntToStr(num_cod_comp);
      vstr_sql := vstr_sql + ', ' + IntToStr(dmCte.sqCompCOD_CTE.AsInteger) ;
      vstr_sql := vstr_sql + ', ' + QuotedStr(dmCte.sqCompCOMP_NOME.AsString);
      vstr_sql := vstr_sql + ', '  + FloatToStr(dmCte.sqCompCOMP_VALOR.AsFloat);
      vstr_sql := vstr_sql + ')';
      dmCte.sqCompCOD_CTE_COMP.AsInteger := num_cod_comp;
    end;
  end;
  if (dmCte.dsComp.State in [dsEdit]) then
  begin
    vstr_sql := 'UPDATE CTE_COMP SET COMP_NOME = ';
    vstr_sql := vstr_sql + QuotedStr(dmCte.sqCompCOMP_NOME.AsString);
    vstr_sql := vstr_sql + ', COMP_VALOR = ';
    vstr_sql := vstr_sql +  FloatToStr(dmCte.sqCompCOMP_VALOR.AsFloat)  ; // +  Format('%8.2f', [valComp.Value]);
    vstr_sql := vstr_sql + ' WHERE COD_CTE_COMP = ';
    vstr_sql := vstr_sql + IntToStr(dmCte.sqCOMPCOD_CTE_COMP.AsInteger);
  end;
  FormatSettings.DecimalSeparator := ',';
  if (vstr_sql <> '') then
    dmPdv.Ibcon.ExecuteDirect(vstr_sql);
  Close;
end;

procedure TfCompValor.FormShow(Sender: TObject);
begin
  dbCompNome.SetFocus;
end;

procedure TfCompValor.btnEditaClick(Sender: TObject);
begin
end;

procedure TfCompValor.BitBtn1Click(Sender: TObject);
begin
  Close;
end;

end.

