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

unit goxormbr.core.mapping.register;
interface
uses
  SysUtils,
  Rtti,
  Generics.Collections;
type
  TRegisterClass = class
  strict private
    class var
    FEntitys: TList<TClass>;
    FViews: TList<TClass>;
    FTriggers: TList<TClass>;
  public
    class constructor Create;
    class destructor Destroy;
    ///
    class function GetAllEntityClass: TArray<TClass>;
    class function GetAllViewClass: TArray<TClass>;
    class function GetAllTriggerClass: TArray<TClass>;
    ///
    class procedure RegisterEntity(AClass: TClass);
    class procedure RegisterView(AClass: TClass);
    class procedure RegisterTrigger(AClass: TClass);
    ///
    class property EntityList: TList<TClass> read FEntitys;
    class property ViewList: TList<TClass> read FViews;
    class property TriggerList: TList<TClass> read FTriggers;
  end;
implementation
{ TMappedClasses }
class constructor TRegisterClass.Create;
begin
  FEntitys := TList<TClass>.Create;
  FViews := TList<TClass>.Create;
  FTriggers := TList<TClass>.Create;
end;
class destructor TRegisterClass.Destroy;
begin
  FEntitys.Free;
  FViews.Free;
  FTriggers.Free;
end;
class function TRegisterClass.GetAllEntityClass: TArray<TClass>;
var
  LFor: Integer;
begin
  try
    SetLength(Result, FEntitys.Count);
    for LFor := 0 to FEntitys.Count -1 do
      Result[LFor] := FEntitys[LFor];
  finally
    FEntitys.Clear;
  end;
end;
class function TRegisterClass.GetAllTriggerClass: TArray<TClass>;
var
  LFor: Integer;
begin
  try
    SetLength(Result, FTriggers.Count);
    for LFor := 0 to FTriggers.Count -1 do
      Result[LFor] := FTriggers[LFor];
  finally
    FTriggers.Clear;
  end;
end;
class function TRegisterClass.GetAllViewClass: TArray<TClass>;
var
  LFor: Integer;
begin
  try
    SetLength(Result, FViews.Count);
    for LFor := 0 to FViews.Count -1 do
      Result[LFor] := FViews[LFor];
  finally
    FViews.Clear;
  end;
end;
class procedure TRegisterClass.RegisterEntity(AClass: TClass);
begin
  if not FEntitys.Contains(AClass) then
    FEntitys.Add(AClass);
end;
class procedure TRegisterClass.RegisterTrigger(AClass: TClass);
begin
  if not FTriggers.Contains(AClass) then
    FTriggers.Add(AClass);
end;
class procedure TRegisterClass.RegisterView(AClass: TClass);
begin
  if not FViews.Contains(AClass) then
    FViews.Add(AClass);
end;
end.



