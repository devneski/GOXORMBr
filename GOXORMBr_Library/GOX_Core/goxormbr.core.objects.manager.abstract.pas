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

unit goxormbr.core.objects.manager.abstract;

interface

uses
  Rtti,
  Generics.Collections,
  // ORMBr
  goxormbr.core.mapping.explorer,
  goxormbr.core.mapping.classes,
  goxormbr.core.types;

type
  TObjectManagerAbstract<M: class, constructor> = class abstract
  protected
    procedure FillAssociation(const AObject: M);  virtual; abstract;

    // Instancia a class que mapea todas as class do tipo Entity
    function FindSQLInternal(const ASQL: String): TObjectList<M>; virtual; abstract;
    procedure ExecuteOneToOne(AObject: TObject; AProperty: TRttiProperty; AAssociation: TAssociationMapping); virtual; abstract;
    procedure ExecuteOneToMany(AObject: TObject; AProperty: TRttiProperty; AAssociation: TAssociationMapping); virtual; abstract;
  public
    constructor Create(const AOwner: TObject; const AGOXORMEngine: TGOXDBConnection; const APageSize: Integer); virtual;
    destructor Destroy; override;
    // Procedures
    procedure InsertInternal(const AObject: M);  virtual; abstract;
    procedure UpdateInternal(const AObject: TObject; const AModifiedFields: TDictionary<string, string>);  virtual; abstract;
    procedure DeleteInternal(const AObject: M);  virtual; abstract;

    // Functions
    function GetDMLCommand: string;  virtual; abstract;
    function ExistSequence: Boolean;  virtual; abstract;
    // DataSet
    function SelectInternalWhere(const AWhere: string; const AOrderBy: string): string;  virtual; abstract;
    function SelectInternalAll: TGOXDBQuery;  virtual; abstract;
    function SelectInternalID(const APK: Variant): TGOXDBQuery;  virtual; abstract;
    function SelectInternal(const ASQL: String): TGOXDBQuery;  virtual; abstract;
    function SelectInternalAssociation(const AObject: TObject): String;  virtual; abstract;
    function SelectInternalByPackage(const APageNumber:Integer; const ARowsByPage:Integer; const AWhere: String; AOrderBy: String):TGOXDBQuery;  virtual; abstract;
    function SelectByPackage(const APageNumber:Integer; const ARowsByPage:Integer; const AWhere: String; AOrderBy: String):TObjectList<M>;  virtual; abstract;    function GetPackagePageCount(const AWhere: String; const ARowsByPage:Integer):Integer; virtual; abstract;

    // ObjectSet
    function Find: TObjectList<M>; overload;  virtual; abstract;
    function Find(const APK: Variant): M; overload;  virtual; abstract;
    function FindWhere(const AWhere: string;  const AOrderBy: string): TObjectList<M>;  virtual; abstract;
    //

  end;

implementation

{ TObjectManagerAbstract<M> }

constructor TObjectManagerAbstract<M>.Create(const AOwner: TObject; const AGOXORMEngine: TGOXDBConnection; const APageSize: Integer);
begin
  // Popula todas classes modelos na lista
  TMappingExplorer.GetRepositoryMapping;
end;


destructor TObjectManagerAbstract<M>.Destroy;
begin
  inherited;
end;

end.
