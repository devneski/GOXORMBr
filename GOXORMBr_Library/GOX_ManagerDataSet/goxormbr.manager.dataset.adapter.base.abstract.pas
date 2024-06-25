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


unit goxormbr.manager.dataset.adapter.base.abstract;

interface

uses
  DB,
  Rtti,
  Generics.Collections,
  goxormbr.manager.dataset.fields,
  goxormbr.core.session.abstract,
  goxormbr.core.mapping.classes,
  goxormbr.core.rtti.helper,
  goxormbr.core.types;

type
  // M - Object M
  TGOXManagerDatasetAdapterBaseAbstract<M: class, constructor> = class
  protected
    FSession: TSessionAbstract<M>;
    // Objeto para controle de estado do registro
    FOrmDataSource: TDataSource;

    procedure RefreshDataSetOneToOneChilds(AFieldName: string); virtual; abstract;
    procedure DoDataChange(Sender: TObject; Field: TField); virtual;
  public
    // Objeto interface com o DataSet passado pela interface.
    FOrmDataSet: TDataSet;
    constructor Create(ADataSet: TDataSet; APageSize: Integer; AMasterObject: TObject); overload; virtual;
    destructor Destroy; override;
    //
    procedure OpenWhere(const AWhere: String; const AOrderBy: String; const APageNumber:Integer; const ARowsByPage:Integer); overload; virtual; Abstract;

    procedure OpenFrom(const ASubResourceName: String); virtual; Abstract;
  end;

implementation

uses
  goxormbr.core.mapping.explorer;

{ TGOXManagerDatasetAdapterBaseAbstract<M> }

constructor TGOXManagerDatasetAdapterBaseAbstract<M>.Create(ADataSet: TDataSet; APageSize: Integer; AMasterObject: TObject);
begin
  FOrmDataSource := TDataSource.Create(nil);
  FOrmDataSource.DataSet := FOrmDataSet;
  FOrmDataSource.OnDataChange := DoDataChange;
end;

destructor TGOXManagerDatasetAdapterBaseAbstract<M>.Destroy;
begin
  FOrmDataSource.Free;
  inherited;
end;

procedure TGOXManagerDatasetAdapterBaseAbstract<M>.DoDataChange(Sender: TObject; Field: TField);
var
  LValue: TDictionary<string, string>;
//  LContext: TRttiContext;
//  LObjectType: TRttiType;
  LColumn: TColumnMapping;
  LColumns: TColumnMappingList;
begin
  if not (FOrmDataSet.State in [dsInsert, dsEdit]) then
    Exit;
  if Field = nil then
    Exit;
  if Field.Tag > 0 then
    Exit;
  if (Field.FieldKind <> fkData) or (Field.FieldName = cInternalField) then
    Exit;
  // S� adiciona a lista se for edi��o
  if FOrmDataSet.State in [dsEdit] then
  begin
    LValue := FSession.ModifiedFields.Items[M.ClassName];
    if LValue <> nil then
    begin
      if not LValue.ContainsValue(Field.FieldName) then
      begin
        LColumns := TMappingExplorer.GetMappingColumn(M);
        for LColumn in LColumns do
        begin
          if LColumn.ColumnProperty = nil then
            Continue;
          if LColumn.ColumnProperty.IsVirtualData then
            Continue;
          if LColumn.ColumnProperty.IsNoUpdate then
            Continue;
          if LColumn.ColumnProperty.IsAssociation then
            Continue;
          if LColumn.ColumnName <> Field.FieldName then
            Continue;
          LValue.Add(LColumn.ColumnProperty.Name, Field.FieldName);
          Break;
        end;
//        LObjectType := LContext.GetType(TypeInfo(M));
//        for LProperty in LObjectType.GetProperties do
//        begin
//          if LProperty.GetColumn.ColumnName = Field.FieldName then
//          begin
//            LValue.Add(LProperty.Name, Field.FieldName);
//            Break;
//          end;
//        end;
      end;
    end;
  end;
  // Atualiza o registro da tabela externa, se o campo alterado
  // pertencer a um relacionamento OneToOne ou ManyToOne
  RefreshDataSetOneToOneChilds(Field.FieldName);
end;


end.
