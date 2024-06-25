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

unit goxormbr.core.dml.generator.postgresql;

interface

uses
  Classes,
  SysUtils,
  Rtti,
  goxormbr.core.dml.generator.base,
  goxormbr.core.mapping.classes,
  goxormbr.core.mapping.explorer,
//  goxormbr.core.dml.commands,
  goxormbr.core.criteria,
  goxormbr.core.types;

type
  /// <summary>
  /// Classe de banco de dados PostgreSQL
  /// </summary>
  TDMLGeneratorPostgreSQL = class(TDMLGeneratorCommandBase)
  public
    constructor Create;
    destructor Destroy; override;
    function GeneratorSelectAll(AClass: TClass; APageSize: Integer; AID: Variant): string; override;
    function GeneratorSelectWhere(AClass: TClass; AWhere: string; AOrderBy: string; APageSize: Integer): string; override;
    function GeneratorAutoIncCurrentValue(AObject: TObject; AAutoInc: TDMLCommandAutoInc): Int64; override;
    function GeneratorAutoIncNextValue(AObject: TObject; AAutoInc: TDMLCommandAutoInc): Int64; override;

    //function nova pacote
    function GeneratorSelectByPackage(AClass: TClass; const APageNumber:Integer; const ARowsByPage:Integer; const AWhere: String; AOrderBy: String):String; override;
    function GeneratorPackagePageCount(AClass: TClass; const AWhere: String; const ARowsByPage:Integer):String; override;

  end;

implementation

{ TDMLGeneratorPostgreSQL }

constructor TDMLGeneratorPostgreSQL.Create;
begin
  inherited;
  FDateFormat := 'yyyy-MM-dd';
  FTimeFormat := 'HH:MM:SS';
end;

destructor TDMLGeneratorPostgreSQL.Destroy;
begin

  inherited;
end;

function TDMLGeneratorPostgreSQL.GeneratorSelectAll(AClass: TClass; APageSize: Integer; AID: Variant): string;
var
  LCriteria: ICriteria;
  LTable: TTableMapping;
begin
  LCriteria := GetCriteriaSelect(AClass, AID);
  Result := LCriteria.AsString;
  // Atualiza o comando SQL com pagina��o e atualiza a lista de cache.
  if APageSize > -1 then
    Result := GetGeneratorSelect(LCriteria);
  //
  LTable := TMappingExplorer.GetMappingTable(AClass);
  // Where
  Result := Result + GetGeneratorWhere(AClass, LTable.Name, AID);
  // OrderBy
  Result := Result + GetGeneratorOrderBy(AClass, LTable.Name, AID);
end;

function TDMLGeneratorPostgreSQL.GeneratorSelectByPackage(AClass: TClass; const APageNumber, ARowsByPage: Integer; const AWhere: String;
  AOrderBy: String): String;
var
  LCriteria: ICriteria;
  LScopeWhere: String;
  LScopeOrderBy: String;
  //
  LTable: TTableMapping;
  LPrimaryKey: TPrimaryKeyMapping;
  LColumnName: String;
begin
  LCriteria := GetCriteriaSelect(AClass, -1);
  Result := LCriteria.AsString;

  // Params Where and OrderBy
  if Length(AWhere) > 0 then
  begin
    Result := Result + ' WHERE ';
    Result := Result + AWhere;
  end;
  if Length(AOrderBy) > 0 then
  begin
    Result := Result + ' ORDER BY ';
    Result := Result + AOrderBy;
  end
  else
  begin
    //
    LTable := TMappingExplorer.GetMappingTable(AClass);
    LPrimaryKey := TMappingExplorer.GetMappingPrimaryKey(AClass);
    if LPrimaryKey <> nil then
    begin
      for var LFor := 0 to LPrimaryKey.Columns.Count -1 do
      begin
        if LFor > 0 then
          Continue;
        LColumnName := LTable.Name + '.' + LPrimaryKey.Columns[LFor];
      end;
      Result := Result + ' ORDER BY ';
      Result := Result + LColumnName;
    end;
    Result := Result + ' ORDER BY (SELECT NULL)';
  end;
  if ARowsByPage > 0 then
  begin
    Result := Result +' LIMIT '+IntToStr(ARowsByPage)+' OFFSET '+IntToStr(((APageNumber - 1) * ARowsByPage));
  end;
end;

function TDMLGeneratorPostgreSQL.GeneratorSelectWhere(AClass: TClass;
  AWhere: string; AOrderBy: string; APageSize: Integer): string;
var
  LCriteria: ICriteria;
begin
  LCriteria := GetCriteriaSelect(AClass, -1);
  LCriteria.Where(AWhere);
  LCriteria.OrderBy(AOrderBy);
  if APageSize > -1 then
    Result := LCriteria.AsString + ' LIMIT %s OFFSET %s'
  else
    Result := LCriteria.AsString;
end;

function TDMLGeneratorPostgreSQL.GeneratorAutoIncCurrentValue(AObject: TObject; AAutoInc: TDMLCommandAutoInc): Int64;
begin
  Result := ExecuteSequence(Format('SELECT CURRVAL(''%s'')', [AAutoInc.Sequence.Name]));
end;

function TDMLGeneratorPostgreSQL.GeneratorAutoIncNextValue(AObject: TObject; AAutoInc: TDMLCommandAutoInc): Int64;
begin
  Result := ExecuteSequence(Format('SELECT NEXTVAL(''%s'')', [AAutoInc.Sequence.Name]));
end;

function TDMLGeneratorPostgreSQL.GeneratorPackagePageCount(AClass: TClass; const AWhere: String; const ARowsByPage: Integer): String;
var
  LCriteria: ICriteria;
  LTable: TTableMapping;
  LPrimaryKey: TPrimaryKeyMapping;
begin
  LTable := TMappingExplorer.GetMappingTable(AClass);
  LPrimaryKey := TMappingExplorer.GetMappingPrimaryKey(AClass);
  //
  if LPrimaryKey <> nil then
  LCriteria := CreateCriteria.Select('COUNT('+LTable.Name + '.' + LPrimaryKey.Columns[0]+') PACKAGECOUNT').From(LTable.Name)
  else
  LCriteria := CreateCriteria.Select('COUNT(*) PACKAGECOUNT').From(LTable.Name);
  // Joins - INNERJOIN, LEFTJOIN, RIGHTJOIN, FULLJOIN
  GenerateJoinNoColumn(AClass, LTable, LCriteria);
  //
  Result :=  LCriteria.AsString;
  // Params Where
  if Length(AWhere) > 0 then
  begin
    Result := Result + ' WHERE ';
    Result := Result + AWhere;
  end;
end;

end.

