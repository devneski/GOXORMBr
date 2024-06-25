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


unit goxormbr.manager.dataset.db.session;

interface

uses
  DB,
  Rtti,
  TypInfo,
  Classes,
  Variants,
  SysUtils,
  Generics.Collections,
  /// orm
  goxormbr.core.objects.manager,
  goxormbr.core.objects.manager.abstract,
  goxormbr.core.session.abstract,
  goxormbr.manager.dataset.adapter.base,
  goxormbr.core.mapping.classes,
  goxormbr.core.types;

type
  // M - Sess�o DataManager
  TGOXManagerDataSetSession<M: class, constructor> = class(TSessionAbstract<M>)
  private
    FOwner: TGOXManagerDataSetAdapterBase<M>;
    procedure PopularDataSet(const ADBResultSet: TGOXDBQuery);
  protected
    FGOXORMEngine: TGOXDBConnection;
  public
    constructor Create(const AOwner: TGOXManagerDataSetAdapterBase<M>; const AGOXORMEngine: TGOXDBConnection; const APageSize: Integer = -1); overload;
    destructor Destroy; override;
    //
    procedure OpenID(const APK: Variant); override;
    procedure OpenSQL(const ASQL: string); override;
    procedure OpenWhere(const AWhere: string; const AOrderBy: string = ''); overload; override;
//    procedure OpenByPackage(const APageNumber:Integer; const ARowsByPage:Integer; const AWhere: String; AOrderBy: String); override;
    //
    procedure RefreshRecord(const AColumns: TParams); override;
    function SelectAssociation(const AObject: TObject): String; override;
  end;

implementation

uses
  goxormbr.core.bind;

{ TGOXManagerDataSetSession<M> }

constructor TGOXManagerDataSetSession<M>.Create(const AOwner: TGOXManagerDataSetAdapterBase<M>;  const AGOXORMEngine: TGOXDBConnection; const APageSize: Integer);
begin
  inherited Create(APageSize);
  FOwner := AOwner;
  FGOXORMEngine := AGOXORMEngine;
  FManager := TObjectManager<M>.Create(Self, AGOXORMEngine, APageSize);
end;

destructor TGOXManagerDataSetSession<M>.Destroy;
begin
  FreeAndNil(FManager);
  inherited;
end;

function TGOXManagerDataSetSession<M>.SelectAssociation(const AObject: TObject): String;
begin
  inherited;
  Result := FManager.SelectInternalAssociation(AObject);
end;

//procedure TGOXManagerDataSetSession<M>.OpenByPackage(const APageNumber, ARowsByPage: Integer; const AWhere: String; AOrderBy: String);
//begin
//  inherited;
//  OpenByPackage(APageNumber,ARowsByPage,AWhere,AOrderBy);
//end;

procedure TGOXManagerDataSetSession<M>.OpenID(const APK: Variant);
var
  LDBResultSet: TGOXDBQuery;
begin
  inherited;
  LDBResultSet := FManager.SelectInternalID(APK);
  // Popula o DataSet em mem�ria com os registros retornardos no comando SQL
  PopularDataSet(LDBResultSet);
  //
  FreeAndNil(LDBResultSet);
end;

procedure TGOXManagerDataSetSession<M>.OpenSQL(const ASQL: string);
var
  LDBResultSet: TGOXDBQuery;
begin
  inherited;
  if ASQL = '' then
    LDBResultSet := FManager.SelectInternalAll
  else
    LDBResultSet := FManager.SelectInternal(ASQL);
  // Popula o DataSet em mem�ria com os registros retornardos no comando SQL
  PopularDataSet(LDBResultSet);
  //
  FreeAndNil(LDBResultSet);
end;

procedure TGOXManagerDataSetSession<M>.OpenWhere(const AWhere: string;
  const AOrderBy: string);
begin
  inherited;
  OpenSQL(FManager.SelectInternalWhere(AWhere, AOrderBy));
end;

procedure TGOXManagerDataSetSession<M>.RefreshRecord(const AColumns: TParams);
var
  LDBResultSet: TGOXDBQuery;
  LWhere: String;
  LFor: Integer;
begin
  inherited;
  LWhere := '';
  for LFor := 0 to AColumns.Count -1 do
  begin
    LWhere := LWhere + AColumns[LFor].Name + '=' + AColumns[LFor].AsString;
    if LFor < AColumns.Count -1 then
      LWhere := LWhere + ' AND ';
  end;
  LDBResultSet := FManager.SelectInternal(FManager.SelectInternalWhere(LWhere, ''));
  // Atualiza dados no DataSet
  while not LDBResultSet.Eof do
  begin
    FOwner.FOrmDataSet.Edit;
    TBind.Instance
         .SetFieldToField(LDBResultSet, FOwner.FOrmDataSet);
    FOwner.FOrmDataSet.Post;
    //
    LDBResultSet.Next;
  end;
  //
  FreeAndNil(LDBResultSet);
end;

procedure TGOXManagerDataSetSession<M>.PopularDataSet(const ADBResultSet: TGOXDBQuery);
begin
//  FOrmDataSet.Locate(KeyFiels, KeyValues, Options);
//  { TODO -oISAQUE : Procurar forma de verificar se o registro n�o j� est� em mem�ria
//  pela chave primaria }
  while not ADBResultSet.Eof do
  begin
     FOwner.FOrmDataSet.Append;
     TBind.Instance
          .SetFieldToField(ADBResultSet, FOwner.FOrmDataSet);
     FOwner.FOrmDataSet.Fields[0].AsInteger := -1;
     FOwner.FOrmDataSet.Post;
     //
     ADBResultSet.Next;
  end;
  ADBResultSet.Close;
end;

end.
