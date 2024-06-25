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

unit goxormbr.manager.objectset.db.session;

interface

uses
  DB,
  Rtti,
  TypInfo,
  Classes,
  Variants,
  SysUtils,
  Generics.Collections,
  /// GOXORMBr
  goxormbr.core.bind,
  goxormbr.core.objects.manager,
  goxormbr.core.session.abstract,
  goxormbr.core.types;

type
  // M - Sess�o Abstract
  TSessionObjectSet<M: class, constructor> = class(TSessionAbstract<M>)
  protected
    FConnection: TGOXDBConnection;
  public
    constructor Create(const AConnection: TGOXDBConnection; const APageSize: Integer = -1); overload;
    destructor Destroy; override;

    function ExistSequence: Boolean; override;
    function ModifiedFields: TDictionary<string, TDictionary<string, string>>; override;
    // ObjectSet
    procedure Insert(const AObject: M); overload; override;
    procedure Insert(const AObjectList: TObjectList<M>); overload; override;
    procedure Update(const AObject: M; const AKey: string); overload; override;
    procedure Update(const AObjectList: TObjectList<M>); overload;  override;
    procedure Delete(const AObject: M); overload; override;
    procedure Delete(const APK: Int64); overload;  override;
    // DataSet
    procedure Open; override;
    procedure OpenID(const APK: Variant); override;
    procedure OpenSQL(const ASQL: string); override;
    procedure OpenWhere(const AWhere: string; const AOrderBy: string = ''); override;

    procedure RefreshRecord(const AColumns: TParams); override;
    function SelectAssociation(const AObject: TObject): String; override;
    function ResultParams: TParams;
    // DataSet e ObjectSet
    procedure ModifyFieldsCompare(const AKey: string; const AObjectSource, AObjectUpdate: TObject); override;

    function Find: TObjectList<M>; overload; override;
    function Find(const APK: Int64): M; overload; override;
    function Find(const APK: string): M; overload; override;
    function FindWhere(const AWhere: string; const AOrderBy: string = ''): TObjectList<M>; overload; override;
    function FindWhere(const AWhere: String; const AOrderBy: String; const APageNumber:Integer; const ARowsByPage:Integer):TObjectList<M>; overload; override;

    function GetPackagePageCount(const AWhere: String; const ARowsByPage:Integer):Integer; override;
    function DeleteList: TObjectList<M>; override;

  end;

implementation

{ TSessionObjectSet<M> }

constructor TSessionObjectSet<M>.Create(const AConnection: TGOXDBConnection; const APageSize: Integer);
begin
  inherited Create(APageSize);
  FConnection := AConnection;
  try
    FManager := TObjectManager<M>.Create(Self, AConnection, APageSize);
  except on E: Exception do
    raise Exception.Create('Manager :'+E.Message);
  end;
end;


function TSessionObjectSet<M>.ModifiedFields: TDictionary<string, TDictionary<string, string>>;
begin
 Result := inherited;
end;

procedure TSessionObjectSet<M>.ModifyFieldsCompare(const AKey: string; const AObjectSource, AObjectUpdate: TObject);
begin
  inherited;
end;

procedure TSessionObjectSet<M>.Open;
begin
  inherited;

end;

procedure TSessionObjectSet<M>.OpenID(const APK: Variant);
begin
  inherited;

end;

procedure TSessionObjectSet<M>.OpenSQL(const ASQL: string);
begin
  inherited;

end;

procedure TSessionObjectSet<M>.OpenWhere(const AWhere, AOrderBy: string);
begin
  inherited;

end;

procedure TSessionObjectSet<M>.RefreshRecord(const AColumns: TParams);
begin
  inherited;

end;

function TSessionObjectSet<M>.ResultParams: TParams;
begin
  Result := inherited;
end;

function TSessionObjectSet<M>.SelectAssociation(const AObject: TObject): String;
begin
  Result := inherited;
end;

procedure TSessionObjectSet<M>.Update(const AObject: M; const AKey: string);
begin
  inherited;
end;

procedure TSessionObjectSet<M>.Update(const AObjectList: TObjectList<M>);
begin
  inherited;
end;

procedure TSessionObjectSet<M>.Delete(const AObject: M);
begin
  inherited;
end;

procedure TSessionObjectSet<M>.Delete(const APK: Int64);
begin
  inherited;
end;

function TSessionObjectSet<M>.DeleteList: TObjectList<M>;
begin
  Result := inherited;
end;

destructor TSessionObjectSet<M>.Destroy;
begin
  FreeAndNil(FManager);
  inherited;
end;

function TSessionObjectSet<M>.ExistSequence: Boolean;
begin
  Result := inherited;
end;

function TSessionObjectSet<M>.Find(const APK: Int64): M;
begin
 Result := inherited;
end;

function TSessionObjectSet<M>.Find(const APK: string): M;
begin
 Result := inherited;
end;

function TSessionObjectSet<M>.FindWhere(const AWhere, AOrderBy: String ;const APageNumber, ARowsByPage: Integer): TObjectList<M>;
begin
  Result := nil;
  if FFetchingRecords then
    Exit;

  Result := FManager.SelectByPackage(APageNumber,ARowsByPage,AWhere,AOrderBy);

  if Result = nil then
    Exit;
  if Result.Count > 0 then
    Exit;
  FFetchingRecords := True;
end;

function TSessionObjectSet<M>.GetPackagePageCount(const AWhere: String; const ARowsByPage: Integer): Integer;
begin
  Result := FManager.GetPackagePageCount(AWhere,ARowsByPage);
end;

function TSessionObjectSet<M>.Find: TObjectList<M>;
begin
  Result := inherited;
end;

function TSessionObjectSet<M>.FindWhere(const AWhere, AOrderBy: string): TObjectList<M>;
begin
  Result := inherited;
end;

procedure TSessionObjectSet<M>.Insert(const AObjectList: TObjectList<M>);
begin
  inherited;
end;

procedure TSessionObjectSet<M>.Insert(const AObject: M);
begin
  inherited;
end;
end.
