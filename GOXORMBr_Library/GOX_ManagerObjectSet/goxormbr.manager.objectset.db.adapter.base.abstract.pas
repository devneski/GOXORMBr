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


unit goxormbr.manager.objectset.db.adapter.base.abstract;

interface

uses
  Rtti,
  Variants,
  Generics.Collections,
  goxormbr.core.session.abstract;

type
  /// <summary>
  /// M - Object M
  /// </summary>
  TGOXManagerObjectSetAdapterBaseAbstract<M: class, constructor> = class
  protected
    FSession: TSessionAbstract<M>;
    FObjectState: TObjectDictionary<string, TObject>;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    function ExistSequence: Boolean; virtual; abstract;
    function ModifiedFields: TDictionary<string, TDictionary<string, string>>; virtual; abstract;
    function Find: TObjectList<M>; overload; virtual; abstract;
    function Find(const APK: Int64): M; overload; virtual; abstract;
    function Find(const APK: string): M; overload; virtual; abstract;
    function FindWhere(const AWhere: string; const AOrderBy: string = ''): TObjectList<M>; overload; virtual; abstract;
    function FindWhere(const AWhere: String; const AOrderBy: String; const APageNumber:Integer; const ARowsByPage:Integer):TObjectList<M>; overload; virtual; abstract;


    procedure Insert(const AObject: M); virtual; abstract;
    procedure Update(const AObject: M); virtual; abstract;
    procedure Delete(const AObject: M); virtual; abstract;
    procedure Modify(const AObject: M); virtual; abstract;
    procedure New(var AObject: M); virtual; abstract;
    //
    function GetPackagePageCount(const AWhere: String; const ARowsByPage:Integer):Integer; virtual; abstract;
  end;

implementation

{ TGOXManagerObjectSetAdapterBaseAbstract<M> }

constructor TGOXManagerObjectSetAdapterBaseAbstract<M>.Create;
begin
  //
end;

destructor TGOXManagerObjectSetAdapterBaseAbstract<M>.Destroy;
begin
  //
  inherited;
end;

end.
