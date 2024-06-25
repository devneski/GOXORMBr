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

unit goxormbr.core.json.utils;

interface

uses
  System.JSON,
  System.Rtti,
  System.SysUtils,
  Generics.Collections,
  System.TypInfo,
  System.Classes,
  //
  Neon.Core.Types,
  Neon.Core.Persistence,
  Neon.Core.Persistence.JSON,
  Neon.Core.Utils;

type
  TGOXJson = class
  private
     class function NeonConfiguration:INeonConfiguration;
  public
    class function ObjectSerializerJSON(AObject: TObject):TJSONValue;
    class function ObjectDeserializerJSON<T: class, constructor>(const AJSON: string): T;
    //
    class function ObjectToJSON(AObject: TObject): TJSONValue;
    class function ObjectToJSONString(AObject: TObject): String;
    //
    class function JSONToObject<T: class, constructor>(AJSON: TJSONValue): T;
    class function JSONStringToObject<T: class, constructor>(const AJSON: String): T;
    class function JSONStringToObjectList<T: class, constructor>(const AJSONString: String): TObjectList<T>;
    //
    class function ValueToJSON(const AValue: TValue): TJSONValue;
    class function JSONToValue<T>(AJSON: TJSONValue): T;
    //
    class function JSONStringToJSONValue(const AJson: string): TJSONValue;
    class function JSONStringToJSONObject(const AJson: string): TJSONObject;
    //
    class function Print(AJSONValue: TJSONValue; APretty: Boolean): string; static;
    class procedure PrintToStream(AJSONValue: TJSONValue; AStream: TStream; APretty: Boolean); static;
  end;

implementation

uses
  System.Variants;

{ TGOXJson }

class function TGOXJson.JSONStringToJSONObject(const AJson: string): TJSONObject;
begin
  Result := TJSONObject.ParseJSONValue(AJson) as TJSONObject;
  if not Assigned(Result) then
    raise Exception.Create('Error parsing JSON string');
end;

class function TGOXJson.JSONStringToJSONValue(const AJson: string): TJSONValue;
begin
  Result := TJSONObject.ParseJSONValue(AJson);
  if not Assigned(Result) then
    raise Exception.Create('Error parsing JSON string');
end;

class function TGOXJson.ObjectDeserializerJSON<T>(const AJson: string): T;
var
  LJSON: TJSONValue;
  LReader: TNeonDeserializerJSON;
begin
  try
    LJSON := TJSONObject.ParseJSONValue(AJSON);
    if not Assigned(LJSON) then
      raise Exception.Create('Error parsing JSON string');
    //
    LReader := TNeonDeserializerJSON.Create(NeonConfiguration);
    try
      Result := T.Create;
      LReader.JSONToObject(Result, LJSON);
    finally
      LReader.Free;
    end;
  finally
    LJSON.Free;
  end;
end;

class function TGOXJson.JSONStringToObjectList<T>(const AJSONString: String): TObjectList<T>;
begin
  Result := TNeon.JSONToObject<TObjectList<T>>(AJSONString,NeonConfiguration);
end;

class function TGOXJson.JSONToObject<T>(AJSON: TJSONValue): T;
begin
  Result := TNeon.JSONToObject<T>(AJSON,NeonConfiguration);
end;

class function TGOXJson.JSONStringToObject<T>(const AJSON: string): T;
begin
  Result := TNeon.JSONToObject<T>(AJSON,NeonConfiguration);
end;

class function TGOXJson.JSONToValue<T>(AJSON: TJSONValue): T;
begin
  Result := TNeon.JSONToValue<T>(AJSON,NeonConfiguration);
end;

class function TGOXJson.NeonConfiguration: INeonConfiguration;
var
  LVis: TNeonVisibility;
  LMembers: TNeonMembersSet;
begin
  LVis := [];
  LMembers := [TNeonMembers.Standard];
  Result := TNeonConfiguration.Default;

  // Case settings
  Result.SetMemberCustomCase(nil);
  Result.SetMemberCase(TNeonCase.UpperCase);




  // Member type settings
  LMembers := LMembers + [TNeonMembers.Properties];
  Result.SetMembers(LMembers);

  // F Prefix setting
  Result.SetIgnoreFieldPrefix(True);

  // Use UTC Date
  Result.SetUseUTCDate(True);

  // Pretty Printing
  Result.SetPrettyPrint(false);

  // Visibility settings
  LVis := LVis + [mvPublic];
  LVis := LVis + [mvPublished];
  Result.SetVisibility(LVis);

  //Custom Serializers
  //RegisterNeonSerializers(Result.GetSerializers);

end;

class function TGOXJson.ObjectSerializerJSON(AObject: TObject): TJSONValue;
var
  LWriter: TNeonSerializerJSON;
begin
  try
    LWriter := TNeonSerializerJSON.Create(NeonConfiguration);
    Result := LWriter.ObjectToJSON(AObject);
  finally
    LWriter.Free;
  end;
end;

class function TGOXJson.ObjectToJSONString(AObject: TObject): string;
begin
  Result := TNeon.ObjectToJSONString(AObject,NeonConfiguration);
end;

class function TGOXJson.ObjectToJSON(AObject: TObject): TJSONValue;
begin
  Result := TNeon.ObjectToJSON(AObject,NeonConfiguration);
end;

class function TGOXJson.Print(AJSONValue: TJSONValue; APretty: Boolean): string;
begin
  Result := TNeon.Print(AJSONValue,APretty);
end;

class procedure TGOXJson.PrintToStream(AJSONValue: TJSONValue; AStream: TStream; APretty: Boolean);
begin
  TNeon.PrintToStream(AJSONValue, AStream,APretty);
end;

class function TGOXJson.ValueToJSON(const AValue: TValue): TJSONValue;
begin
  Result := TNeon.ValueToJSON(AValue,NeonConfiguration);
end;

end.
