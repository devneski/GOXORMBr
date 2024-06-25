{******************************************************************************}
{                                  GOXORMBr                                    }
{                                                                              }
{  Um ORM simples que simplifica a persist�ncia de dados, oferecendo           }
{  funcionalidades para mapear tabelas de banco de dados como objetos          }
{  relacionais, facilitando a manipula��o e a gest�o de dados.                 }
{                                                                              }
{  Voc� pode obter a �ltima vers�o desse arquivo no reposit�rio abaixo         }
{  https://github.com/jeicksongobeti/goxormbr                                  }
{                                                                              }
{******************************************************************************}
{                   Copyright (c) 2016, Isaque Pinheiro                        }
{                            All rights reserved.                              }
{                                                                              }
{                   Copyright (c) 2020, Jeickson Gobeti                        }
{                          All Modifications Reserved.                         }
{                                                                              }
{                    GNU Lesser General Public License                         }
{                                                                              }
{  Esta biblioteca � software livre; voc� pode redistribu�-la e/ou modific�-la }
{ sob os termos da Licen�a P�blica Geral Menor do GNU conforme publicada pela  }
{ Free Software Foundation; tanto a vers�o 2.1 da Licen�a, ou (a seu crit�rio) }
{ qualquer vers�o posterior.                                                   }
{                                                                              }
{  Esta biblioteca � distribu�da na expectativa de que seja �til, por�m, SEM   }
{ NENHUMA GARANTIA; nem mesmo a garantia impl�cita de COMERCIABILIDADE OU      }
{ ADEQUA��O A UMA FINALIDADE ESPEC�FICA. Consulte a Licen�a P�blica Geral Menor}
{ do GNU para mais detalhes. (Arquivo LICEN�A.TXT ou LICENSE.TXT)              }
{                                                                              }
{  Voc� deve ter recebido uma c�pia da Licen�a P�blica Geral Menor do GNU junto}
{ com esta biblioteca; se n�o, escreva para a Free Software Foundation, Inc.,  }
{ no endere�o 59 Temple Street, Suite 330, Boston, MA 02111-1307 USA.          }
{ Voc� tamb�m pode obter uma copia da licen�a em:                              }
{ http://www.opensource.org/licenses/lgpl-license.php                          }
{                                                                              }
{       Jeickson Gobeti - jeickson.gobeti@gmail.com - www.goxcode.com.br       }
{                                                                              }
{******************************************************************************}



unit goxormbr.manager.dataset.db.adapter;

interface

uses
  DB,
  Rtti,
  TypInfo,
  Classes,
  SysUtils,
  StrUtils,
  Variants,
  Generics.Collections,
  /// orm
  goxormbr.core.criteria,
  goxormbr.core.bind,
  goxormbr.manager.dataset.db.session,
  goxormbr.manager.dataset.adapter.base,
  goxormbr.core.mapping.classes,
  goxormbr.core.types.mapping,
  goxormbr.core.types;

type
  TDataSetHack = class(TDataSet)
  end;
  // M - Object M
  TGOXManagerDatasetAdapter<M: class, constructor> = class(TGOXManagerDataSetAdapterBase<M>)
  private
    procedure ExecuteCheckNotNull;
  protected
    FGOXORMEngine: TGOXDBConnection;
    procedure OpenDataSetChilds; override;
    procedure RefreshDataSetOneToOneChilds(AFieldName: string); override;
    procedure DoAfterScroll(DataSet: TDataSet); override;
    procedure DoBeforePost(DataSet: TDataSet); override;
    procedure DoBeforeDelete(DataSet: TDataSet); override;
    procedure DoNewRecord(DataSet: TDataSet); override;
  public
    constructor Create(AGOXORMEngine: TGOXDBConnection; ADataSet: TDataSet; APageSize: Integer; AMasterObject: TObject); overload;
    destructor Destroy; override;
//    procedure NextPacket; override;
  end;

implementation

uses
  goxormbr.manager.dataset.fields,
  goxormbr.core.objects.helper,
  goxormbr.core.rtti.helper,
  goxormbr.core.mapping.explorer,
  goxormbr.core.mapping.exceptions;

{ TGOXManagerDatasetAdapter<M> }
constructor TGOXManagerDatasetAdapter<M>.Create(AGOXORMEngine: TGOXDBConnection; ADataSet: TDataSet; APageSize: Integer; AMasterObject: TObject);
begin
  FGOXORMEngine := AGOXORMEngine;
  inherited Create(ADataSet, APageSize, AMasterObject);
  // Session que ser� usado pelo Adapter
  FSession := TGOXManagerDatasetSession<M>.Create(Self, AGOXORMEngine, APageSize);
end;

destructor TGOXManagerDatasetAdapter<M>.Destroy;
begin
  FSession.Free;
  inherited;
end;

procedure TGOXManagerDatasetAdapter<M>.DoAfterScroll(DataSet: TDataSet);
begin
  if DataSet.State in [dsBrowse] then
    if not FOrmDataSet.Eof then
      OpenDataSetChilds;
  inherited;
end;

procedure TGOXManagerDatasetAdapter<M>.DoBeforeDelete(DataSet: TDataSet);
var
  LDataSet: TDataSet;
  LFor: Integer;
begin
  inherited DoBeforeDelete(DataSet);
  // Alimenta a lista com registros deletados
  FSession.DeleteList.Add(M.Create);
  TBind.Instance
       .SetFieldToProperty(FOrmDataSet, TObject(FSession.DeleteList.Last));

  // Deleta registros de todos os DataSet filhos
  EmptyDataSetChilds;
  // Exclui os registros dos NestedDataSets linkados ao FOrmDataSet
  // Recurso usado em banco NoSQL
  for LFor := 0 to TDataSetHack(FOrmDataSet).NestedDataSets.Count - 1 do
  begin
    LDataSet := TDataSetHack(FOrmDataSet).NestedDataSets.Items[LFor];
    LDataSet.DisableControls;
    LDataSet.First;
    try
      repeat
        LDataSet.Delete;
      until LDataSet.Eof;
    finally
      LDataSet.EnableControls;
    end;
  end;
end;

procedure TGOXManagerDatasetAdapter<M>.DoBeforePost(DataSet: TDataSet);
begin
  inherited DoBeforePost(DataSet);
  // Rotina de valida��o se o campo foi deixado null
  ExecuteCheckNotNull;
end;

procedure TGOXManagerDatasetAdapter<M>.ExecuteCheckNotNull;
var
  LColumn: TColumnMapping;
  LColumns: TColumnMappingList;
begin
  LColumns := TMappingExplorer.GetMappingColumn(FCurrentInternal.ClassType);
  for LColumn in LColumns do
  begin
    if LColumn.IsNoInsert then
      Continue;
    if LColumn.IsNoUpdate then
      Continue;
    if LColumn.IsJoinColumn then
      Continue;
    if LColumn.IsNoValidate then
      Continue;
    if LColumn.IsNullable then
      Continue;
    if LColumn.FieldType in [ftDataSet, ftADT, ftBlob] then
      Continue;
    if LColumn.IsNotNull then
      if FOrmDataSet.FieldValues[LColumn.ColumnName] = Null then
        raise EFieldValidate.Create(FCurrentInternal.ClassName + '.' + LColumn.ColumnName,
                                  FOrmDataSet.FieldByName(LColumn.ColumnName).ConstraintErrorMessage);
  end;
end;

procedure TGOXManagerDatasetAdapter<M>.OpenDataSetChilds;
var
  LDataSetChild: TGOXManagerDataSetAdapterBase<M>;
  LSQL: String;
  LObject: TObject;
begin
  inherited;
  if not FOrmDataSet.Active then
    Exit;
  if FOrmDataSet.RecordCount = 0 then
    Exit;
  // Se Count > 0, identifica-se que � o objeto � o Master
  if FMasterObject.Count = 0 then
    Exit;

  // Popula o objeto com o registro atual do dataset Master para filtar
  // os filhos com os valores das chaves.
  LObject := M.Create;
  try
    TBind.Instance.SetFieldToProperty(FOrmDataSet, LObject);
    for LDataSetChild in FMasterObject.Values do
    begin
      LSQL := LDataSetChild.FSession.SelectAssociation(LObject);
      // Monta o comando SQL para abrir registros filhos
      if Length(LSQL) > 0 then
        LDataSetChild.OpenSQLInternal(LSQL);
    end;
  finally
    LObject.Free;
  end;
end;

//procedure TGOXManagerDatasetAdapter<M>.NextPacket;
//var
//  LBookMark: TBookmark;
//begin
//  inherited;
//  if FSession.FetchingRecords then
//    Exit;
//  FOrmDataSet.DisableControls;
//  // Desabilita os eventos dos TDataSets
//  DisableDataSetEvents;
//  LBookMark := FOrmDataSet.Bookmark;
//  try
//    FSession.NextPacket;
//  finally
//    FOrmDataSet.GotoBookmark(LBookMark);
//    FOrmDataSet.EnableControls;
//    EnableDataSetEvents;
//  end;
//end;

procedure TGOXManagerDatasetAdapter<M>.RefreshDataSetOneToOneChilds(AFieldName: string);
var
  LAssociations: TAssociationMappingList;
  LAssociation: TAssociationMapping;
  LDataSetChild: TGOXManagerDataSetAdapterBase<M>;
  LSQL: String;
  LObject: TObject;
begin
  inherited;
  if not FOrmDataSet.Active then
    Exit;
  LAssociations := TMappingExplorer.GetMappingAssociation(FCurrentInternal.ClassType);
  if LAssociations = nil then
    Exit;
  for LAssociation in LAssociations do
  begin
    if not (LAssociation.Multiplicity in [OneToOne, ManyToOne]) then
      Continue;
    // Checa se o campo que recebeu a altera��o, � um campo de associa��o
    // Se for � feito um novo select para atualizar a propriedade associada.
    if LAssociation.ColumnsName.IndexOf(AFieldName) = -1 then
      Continue;
    if not FMasterObject.ContainsKey(LAssociation.ClassNameRef) then
      Continue;
    LDataSetChild := FMasterObject.Items[LAssociation.ClassNameRef];
    if LDataSetChild = nil then
      Continue;
    // Popula o objeto com o registro atual do dataset Master para filtar
    // os filhos com os valores das chaves.
    LObject := M.Create;
    try
      TBind.Instance.SetFieldToProperty(FOrmDataSet, LObject);
      LSQL := LDataSetChild.FSession.SelectAssociation(LObject);
      if Length(LSQL) > 0 then
        LDataSetChild.OpenSQLInternal(LSQL);
    finally
      LObject.Free;
    end;
  end;
end;

procedure TGOXManagerDatasetAdapter<M>.DoNewRecord(DataSet: TDataSet);
begin
  // Limpa registros do dataset em mem�ria antes de receber os novos registros
  EmptyDataSetChilds;
  inherited DoNewRecord(DataSet);
end;

end.
