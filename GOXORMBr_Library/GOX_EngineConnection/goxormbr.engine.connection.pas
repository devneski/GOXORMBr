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


{$INCLUDE ..\goxorm.inc}

unit goxormbr.engine.connection;

interface

uses
  Classes,
  sysutils,
  DB,
  Variants,
  StrUtils,
  {$IFDEF USE_ENGINE_DAC_FIREDAC}
   FireDAC.Comp.Client,
   goxormbr.engine.dbconnection.firedac,
  {$ENDIF}
  {$IFDEF USE_ENGINE_DAC_ZEOS}
  {$ENDIF}
  //
  {$IFDEF USE_ENGINE_REST_WIRL}
   goxormbr.engine.restconnection.wirl,
  {$ENDIF}
  {$IFDEF USE_ENGINE_REST_HORSE}
  {$ENDIF}
  goxormbr.core.types;

type
  // GOXORM Engine DAC
  TGOXDBConnectionEngine = class({$IFDEF USE_ENGINE_DAC_FIREDAC}TGOXDBConnectionFireDAC{$ENDIF}
                                 {$IFDEF USE_ENGINE_DAC_ZEOS}                          {$ENDIF})
  private
  public
    constructor Create(const AOwner: TComponent; const ADriverType: TDriverType);
  end;


  // GOXORM Engine REST
  TGOXRESTConnectionEngine = class({$IFDEF USE_ENGINE_REST_WIRL}TGOXRESTConnectionWiRL{$ENDIF}
                                   {$IFDEF USE_ENGINE_REST_HORSE}                     {$ENDIF})
  private
  public
    constructor Create(const AURLBase:String = '');
    destructor Destroy; override;
  end;




implementation

{ TGOXDBConnectionEngine }
constructor TGOXDBConnectionEngine.Create(const AOwner: TComponent; const ADriverType: TDriverType);
begin
   inherited Create(AOwner, ADriverType);
end;


{ TGOXRESTConnectionEngine }
constructor TGOXRESTConnectionEngine.Create(const AURLBase:String);
begin
  Inherited Create(AURLBase);
end;

destructor TGOXRESTConnectionEngine.Destroy;
begin
  inherited;
end;



end.
