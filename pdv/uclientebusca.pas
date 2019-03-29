unit uClienteBusca;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, DBGrids, Buttons, uPadraoBusca, db, udmpdv;

type

  { TfClienteBusca }

  TfClienteBusca = class(TfPadraoBusca)
    chCurso: TCheckBox;
    dsCliente: TDataSource;
    Label2: TLabel;
    procedure btnProcurarClick(Sender: TObject);
    procedure DBGrid1CellClick(Column: TColumn);
    procedure Edit1KeyPress(Sender: TObject; var Key: char);
    procedure Edit2KeyPress(Sender: TObject; var Key: char);
    procedure FormShow(Sender: TObject);
  private
    procedure Procurar();
  public
    cCodCliente: Integer;
    cNomeCliente : String;
    procedure BuscaCliente;
  end;

var
  fClienteBusca: TfClienteBusca;

implementation

{$R *.lfm}

{ TfClienteBusca }



procedure TfClienteBusca.btnProcurarClick(Sender: TObject);
begin
    Procurar();
end;


procedure TfClienteBusca.DBGrid1CellClick(Column: TColumn);
begin
  cNomeCliente := dmPdv.sqBusca.FieldByName('NOMECLIENTE').AsString;
  cCodCliente  := dmPdv.sqBusca.FieldByName('CODCLIENTE').AsInteger;
end;

procedure TfClienteBusca.Edit1KeyPress(Sender: TObject; var Key: char);
begin
  if (key = #13) then
  begin
    Key := #0;
    if (edit1.Text <> '') then
      Procurar();
  end;
end;

procedure TfClienteBusca.Edit2KeyPress(Sender: TObject; var Key: char);
begin
  if (key = #13) then
  begin
    Key := #0;
    if (edit2.Text <> '') then
      Procurar();
  end;
end;

procedure TfClienteBusca.FormShow(Sender: TObject);
begin
  //dmPdv.IbCon.Connected:=False;
  //dmPdv.IbCon.Connected:=True;
  DBGrid1.Columns[0].FieldName := 'CODCLIENTE';
  DBGrid1.Columns[1].FieldName := 'NOMECLIENTE';
  DBGrid1.Columns[0].Title.Caption:='Código';
  DBGrid1.Columns[1].Title.Caption:='Cliente';
  cNomeCliente:='';
  if (dmPdv.usaCurso = 0) then
  begin
    chCurso.Visible := False;
  end;
end;

procedure TfClienteBusca.Procurar();
var sql: String;
begin
  sql := '';
  if (dmPdv.sqBusca.Active) then
    dmPdv.sqBusca.Close;
  dmPdv.sqBusca.SQL.Clear;

  if chCurso.Checked then
  begin
    sql := ' WHERE STATUS = 1 AND REGIAO = 1';
  end
  else begin
    sql := ' WHERE STATUS = 1 AND REGIAO = 0';
  end;

  if ((chCurso.Checked) and (chInativo.Checked)) then
  begin
    sql := ' WHERE STATUS = 0 AND REGIAO = 1';
  end;

  if edit1.Text <> '' then
  begin
    sql := sql + ' AND CODCLIENTE = ' + Edit1.Text;
  end;
  if edit2.Text <> '' then
  begin
    sql := sql + ' AND UPPER(NOMECLIENTE) LIKE UPPER(' + QuotedStr('%' + Edit2.Text + '%') + ')';
  end;

  sql := 'SELECT * FROM CLIENTES ' + sql;

  dmPdv.sqBusca.SQL.Text := sql;
  dmPdv.sqBusca.Open;
  cNomeCliente := dmPdv.sqBusca.FieldByName('NOMECLIENTE').AsString;
  cCodCliente  := dmPdv.sqBusca.FieldByName('CODCLIENTE').AsInteger;
end;

procedure TfClienteBusca.BuscaCliente;
var sql: String;
begin
  if (dmPdv.sqBusca.Active) then
    dmPdv.sqBusca.Close;
  dmPdv.sqBusca.SQL.Clear;

  sql := 'SELECT * FROM CLIENTES';
  sql := sql + ' WHERE CODCLIENTE = ' + IntToStr(cCodCliente);
  dmPdv.sqBusca.SQL.Text := sql;
  dmPdv.sqBusca.Open;
  if not dmPdv.sqBusca.IsEmpty then
    cNomeCliente := dmPdv.sqBusca.FieldByName('NOMECLIENTE').AsString;

end;

end.

