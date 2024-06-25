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

unit goxormbr.core.command.updater;

interface

uses
  DB,
  Rtti,
  Math,
  Classes,
  SysUtils,
  StrUtils,
  Variants,
  TypInfo,
  Generics.Collections,
  /// ORMBr
  goxormbr.core.command.abstract,
  goxormbr.core.utils,
  goxormbr.core.consts,
  goxormbr.core.types.blob,
  goxormbr.core.rtti.helper,
  goxormbr.core.mapping.classes,
  goxormbr.core.mapping.attributes,
  goxormbr.core.mapping.explorer,
  goxormbr.core.types;

type
  TCommandUpdater = class(TDMLCommandAbstract)
  private
    function GetParamValue(AInstance: TObject; AProperty: TRttiProperty; AFieldType: TFieldType): Variant;
  public
    constructor Create(AGOXORMEngine: TGOXDBConnection; ADriverType: TDriverType; AObject: TObject); override;
    function GenerateUpdate(AObject: TObject; AModifiedFields: TDictionary<string, string>): string;
  end;

implementation

uses
  goxormbr.core.objects.helper;

{ TCommandUpdater }

constructor TCommandUpdater.Create(AGOXORMEngine: TGOXDBConnection; ADriverType: TDriverType; AObject: TObject);
var
  LColumns: TPrimaryKeyColumnsMapping;
  LColumn: TColumnMapping;
begin
  inherited Create(AGOXORMEngine, ADriverType, AObject);
  LColumns := TMappingExplorer
                  .GetMappingPrimaryKeyColumns(AObject.ClassType);
  for LColumn in LColumns.Columns do
  begin
    with FParams.Add as TParam do
    begin
      Name := LColumn.ColumnName;
      DataType := LColumn.FieldType;
    end;
  end;
end;

function TCommandUpdater.GenerateUpdate(AObject: TObject;
  AModifiedFields: TDictionary<string, string>): string;
var
  LPrimaryKey: TPrimaryKeyColumnsMapping;
  LFor: Integer;
  LParams: TParams;
  LColumn: TColumnMapping;
  LObjectType: TRttiType;
  LProperty: TRttiProperty;
  LKey: String;
  LFieldType: Column;
  LBooleanValue: Integer;
begin
  Result := '';
  FResultCommand := '';
  if AModifiedFields.Count = 0 then
    Exit;
  // Variavel local � usado como par�metro para montar o script s� com os
  // campos PrimaryKey.
  LParams := TParams.Create(nil);
  try
    LPrimaryKey := TMappingExplorer
                     .GetMappingPrimaryKeyColumns(AObject.ClassType);
    if LPrimaryKey = nil then
      raise Exception.Create(cMESSAGEPKNOTFOUND);

    for LColumn in LPrimaryKey.Columns do
    begin
      with LParams.Add as TParam do
      begin
        Name := LColumn.ColumnName;
        DataType := LColumn.FieldType;
        ParamType := ptUnknown;
        Value := LColumn.ColumnProperty.GetNullableValue(AObject).AsVariant;
      end;
    end;
    FResultCommand := FGeneratorCommand.GeneratorUpdate(AObject, LParams, AModifiedFields);
    Result := FResultCommand;
    // Gera todos os par�metros, sendo os campos alterados primeiro e o do
    // PrimaryKey por �ltimo, usando LParams criado local.
    AObject.GetType(LObjectType);
    for LKey in AModifiedFields.Keys do
    begin
      LProperty := LObjectType.GetProperty(LKey);
      if LProperty = nil then
        Continue;
      if LProperty.IsNoUpdate then
        Continue;
      LFieldType := LProperty.GetColumn;
      if LFieldType = nil then
        Continue;

      with LParams.Add as TParam do
      begin
        Name := LFieldType.ColumnName;
        DataType := LFieldType.FieldType;
        ParamType := ptInput;
        Value := GetParamValue(AObject, LProperty, DataType);

    	// Tratamento para o tipo ftBoolean nativo, indo como Integer
        // para gravar no banco.
        if DataType in [ftBoolean] then
        begin
          LBooleanValue := IfThen(Boolean(Value), 1, 0);
          DataType := ftInteger;
          Value := LBooleanValue;
        end;
      end;
    end;
    FParams.Clear;
    for LFor := LParams.Count -1 downto 0 do
    begin
      with FParams.Add as TParam do
      begin
        Name := LParams.Items[LFor].Name;
        DataType := LParams.Items[LFor].DataType;
        Value := LParams.Items[LFor].Value;
        ParamType := LParams.Items[LFor].ParamType;
      end;
    end;
  finally
    LParams.Free;
  end;
end;

function TCommandUpdater.GetParamValue(AInstance: TObject;
  AProperty: TRttiProperty; AFieldType: TFieldType): Variant;
begin
  Result := Null;
  if AProperty.IsNullValue(AInstance) then
    Exit;

  case AProperty.PropertyType.TypeKind of
    tkEnumeration:
      Result := AProperty.GetEnumToFieldValue(AInstance, AFieldType).AsType<Variant>;
    tkRecord:
      begin
        if AProperty.IsBlob then
          Result := AProperty.GetNullableValue(AInstance).AsType<TBlob>.ToBytes
        else
        if AProperty.IsNullable then
          Result := AProperty.GetNullableValue(AInstance).AsType<Variant>;
      end
  else
    Result := AProperty.GetValue(AInstance).AsType<Variant>;
  end;
end;

end.
