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

unit goxormbr.core.objects.helper;

interface

uses
  DB,
  Rtti,
  Variants,
  SysUtils,
  TypInfo, {Delphi 2010}
  Generics.Collections,
  goxormbr.core.consts,
  goxormbr.core.rtti.helper,
  goxormbr.core.mapping.explorer,
  goxormbr.core.mapping.classes,
  goxormbr.core.mapping.attributes;

type
  TORMBrObject = class
  public
    constructor Create; virtual;
  end;

  TObjectHelper = class helper for TObject
  public
    function GetTable: Table;
    function GetPrimaryKey: PrimaryKey;
    function GetResource: Resource;
    function GetNotServerUse: NotServerUse;
    function GetSubResource: SubResource;
    function &GetType(out AType: TRttiType): Boolean;
    function GetSequence: Sequence;
    function MethodCall(const AMethodName: string;
      const AParameters: array of TValue): TValue;
    procedure SetDefaultValue;
  end;

implementation

{ TObjectHelper }

function TObjectHelper.GetNotServerUse: NotServerUse;
var
  LType: TRttiType;
  LAttribute: TCustomAttribute;
begin
  Result := nil;
  if &GetType(LType) then
  begin
    for LAttribute in LType.GetAttributes do // NotServerUse
    begin
      if LAttribute is NotServerUse then
        Exit(NotServerUse(LAttribute));
    end;
    Exit(nil);
  end;
end;

function TObjectHelper.GetPrimaryKey: PrimaryKey;
var
  LType: TRttiType;
  LAttribute: TCustomAttribute;
begin
  if &GetType(LType) then
  begin
    for LAttribute in LType.GetAttributes do
    begin
      if (LAttribute is PrimaryKey) then // PrimaryKey
        Exit(PrimaryKey(LAttribute));
    end;
    Exit(nil);
  end
  else
    Exit(nil);
end;

function TObjectHelper.GetResource: Resource;
var
  LType: TRttiType;
  LAttribute: TCustomAttribute;
begin
  Result := nil;
  if &GetType(LType) then
  begin
    for LAttribute in LType.GetAttributes do // Resource
    begin
      if LAttribute is Resource then
        Exit(Resource(LAttribute));
    end;
    Exit(nil);
  end;
end;

function TObjectHelper.GetSequence: Sequence;
var
  LType: TRttiType;
  LAttribute: TCustomAttribute;
begin
  Result := nil;
  if &GetType(LType) then
  begin
    for LAttribute in LType.GetAttributes do
    begin
      if LAttribute is Sequence then // Sequence
        Exit(Sequence(LAttribute));
    end;
  end;
end;

function TObjectHelper.GetSubResource: SubResource;
var
  LType: TRttiType;
  LAttribute: TCustomAttribute;
begin
  if &GetType(LType) then
  begin
    for LAttribute in LType.GetAttributes do // SubResource
    begin
      if LAttribute is SubResource then
        Exit(SubResource(LAttribute));
    end;
    Exit(nil);
  end
  else
    Exit(nil);
end;

function TObjectHelper.GetTable: Table;
var
  LType: TRttiType;
  LAttribute: TCustomAttribute;
begin
  if &GetType(LType) then
  begin
    for LAttribute in LType.GetAttributes do
    begin
      if (LAttribute is Table) or (LAttribute is View) then // Table/View
        Exit(Table(LAttribute));
    end;
    Exit(nil);
  end
  else
    Exit(nil);
end;

function TObjectHelper.&GetType(out AType: TRttiType): Boolean;
var
  LContext: TRttiContext;
begin
  Result := False;
  if Assigned(Self) then
  begin
    LContext := TRttiContext.Create;
    try
      AType  := LContext.GetType(Self.ClassType);
      Result := Assigned(AType);
    finally
      LContext.Free;
    end;
  end;
end;

function TObjectHelper.MethodCall(const AMethodName: string;
  const AParameters: array of TValue): TValue;
var
  LContext: TRttiContext;
  LRttiType: TRttiType;
  LMethod: TRttiMethod;
begin
  LContext := TRttiContext.Create;
  try
    LRttiType := LContext.GetType(Self.ClassType);
    LMethod   := LRttiType.GetMethod(AMethodName);
    if Assigned(LMethod) then
       Result := LMethod.Invoke(Self, AParameters)
    else
       raise Exception.CreateFmt('Cannot find method "%s" in the object', [AMethodName]);
  finally
    LContext.Free;
  end;
end;

procedure TObjectHelper.SetDefaultValue;
var
  LColumns: TColumnMappingList;
  LColumn: TColumnMapping;
  LProperty: TRttiProperty;
  LValue: Variant;
begin
  LColumns := TMappingExplorer.GetMappingColumn(Self.ClassType);
  if LColumns = nil then
    Exit;

  for LColumn in LColumns do
  begin
    if Length(LColumn.DefaultValue) = 0 then
      Continue;

    LProperty := LColumn.ColumnProperty;
    LValue := StringReplace(LColumn.DefaultValue, '''', '', [rfReplaceAll]);

    case LProperty.PropertyType.TypeKind of
      tkString, tkWString, tkUString, tkWChar, tkLString, tkChar:
        LProperty.SetValue(Self, TValue.FromVariant(LValue).AsString);
      tkInteger, tkSet, tkInt64:
        LProperty.SetValue(Self, StrToIntDef(LValue, 0));
      tkFloat:
        begin
          if LProperty.PropertyType.Handle = TypeInfo(TDateTime) then // TDateTime
            LProperty.SetValue(Self, TValue.FromVariant(Date).AsType<TDateTime>)
          else
          if LProperty.PropertyType.Handle = TypeInfo(TDate) then // TDate
            LProperty.SetValue(Self, TValue.FromVariant(Date).AsType<TDate>)
          else
          if LProperty.PropertyType.Handle = TypeInfo(TTime) then// TTime
            LProperty.SetValue(Self, TValue.FromVariant(Time).AsType<TTime>)
          else
            LProperty.SetValue(Self, StrToFloatDef(LValue, 0));
        end;
      tkRecord:
        LProperty.SetValueNullable(Self, LProperty.PropertyType.Handle, LValue);
      tkEnumeration:
        begin
          case LColumn.FieldType of
            ftString, ftFixedChar:
              LProperty.SetValue(Self, LProperty.GetEnumStringValue(Self, LValue));
            ftInteger:
              LProperty.SetValue(Self, LProperty.GetEnumIntegerValue(Self, LValue));
            ftBoolean:
              LProperty.SetValue(Self, TValue.FromVariant(LValue).AsBoolean);
          else
            raise Exception.Create(cENUMERATIONSTYPEERROR);
          end;
        end;
    end;
  end;
end;

{ TORMBrObject }

constructor TORMBrObject.Create;
begin
  Self.SetDefaultValue;
end;

end.
