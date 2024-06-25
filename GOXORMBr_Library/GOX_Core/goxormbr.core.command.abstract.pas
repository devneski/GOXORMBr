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
unit goxormbr.core.command.abstract;

{$INCLUDE ..\goxorm.inc}

interface

uses
  system.SysUtils,
  DB,
  Rtti,
  {$IFDEF USE_ENGINE_DAC_FIREDAC}
   FireDAC.Comp.Client,
   FireDAC.Stan.Param,
  {$ENDIF}
  goxormbr.core.dml.generator.base,
  goxormbr.core.types;

type

  TDMLCommandAbstract = class
  protected
    FGOXORMEngine: TGOXDBConnection;
    FGeneratorCommand_SQLServer: TDMLGeneratorCommandBase;
    FGeneratorCommand_PostgreSQL: TDMLGeneratorCommandBase;
    FGeneratorCommand_Firebird: TDMLGeneratorCommandBase;
    FGeneratorCommand_SQLite: TDMLGeneratorCommandBase;
    //
    FGeneratorCommand: TDMLGeneratorCommandBase;

    FParams:{$IFDEF USE_ENGINE_DAC_FIREDAC}TParams{$ELSE}TParams{$ENDIF};

    FResultCommand: string;
  public
    constructor Create(AGOXORMEngine: TGOXDBConnection; ADriverType: TDriverType; AObject: TObject); virtual;
    destructor Destroy; override;
    function GetDMLCommand: string;
    function Params: {$IFDEF USE_ENGINE_DAC_FIREDAC}TParams{$ELSE}TParams{$ENDIF};
  end;

implementation

{ TDMLCommandAbstract }

uses   goxormbr.core.dml.generator.mssql,
       goxormbr.core.dml.generator.postgresql,
       goxormbr.core.dml.generator.sqlite,
       goxormbr.core.dml.generator.firebird;

constructor TDMLCommandAbstract.Create(AGOXORMEngine: TGOXDBConnection; ADriverType: TDriverType; AObject: TObject);
begin
  // Driver de Conex�o
  FGOXORMEngine := AGOXORMEngine;
  // Driver do banco de dados
  FGeneratorCommand_SQLServer := TDMLGeneratorMSSql.Create;
  FGeneratorCommand_SQLServer.SetConnection(AGOXORMEngine);
  FGeneratorCommand_PostgreSQL  := TDMLGeneratorPostgreSQL.Create;
  FGeneratorCommand_PostgreSQL.SetConnection(AGOXORMEngine);
  FGeneratorCommand_Firebird  := TDMLGeneratorFirebird.Create;
  FGeneratorCommand_Firebird.SetConnection(AGOXORMEngine);
  FGeneratorCommand_SQLite    := TDMLGeneratorSQLite.Create;
  FGeneratorCommand_SQLite.SetConnection(AGOXORMEngine);

  if ADriverType = dnMSSQL then
  FGeneratorCommand := FGeneratorCommand_SQLServer
  else if ADriverType = dnPostgreSQL then
  FGeneratorCommand := FGeneratorCommand_PostgreSQL
  else if ADriverType = dnFirebird then
  FGeneratorCommand := FGeneratorCommand_Firebird
  else if ADriverType = dnSQLite then
  FGeneratorCommand := FGeneratorCommand_SQLite;

  // Lista de par�metros
  FParams := {$IFDEF USE_ENGINE_DAC_FIREDAC}TParams.Create{$ELSE}TParams.Create{$ENDIF};
end;

destructor TDMLCommandAbstract.Destroy;
begin
  FreeAndNil(FGeneratorCommand_SQLServer);
  FreeAndNil(FGeneratorCommand_Firebird);
  FreeAndNil(FGeneratorCommand_PostgreSQL);
  FreeAndNil(FGeneratorCommand_SQLite);
  FGeneratorCommand := nil;
  FreeAndNil(FParams);
  inherited;
end;

function TDMLCommandAbstract.GetDMLCommand: string;
begin
  Result := FResultCommand;
end;

function TDMLCommandAbstract.Params:{$IFDEF USE_ENGINE_DAC_FIREDAC}TParams{$ELSE}TParams{$ENDIF};
begin
  Result := FParams;
end;

end.
