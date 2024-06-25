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

unit goxormbr.core.mapping.exceptions;
interface
uses
  SysUtils,
  Rtti;
type
  EClassNotRegistered = class(Exception)
  public
    constructor Create(AClass: TClass);
  end;
  EFieldNotNull = class(Exception)
  public
    constructor Create(const ADisplayLabel: String);
  end;
  EFieldValidate = class(Exception)
  public
    constructor Create(const AField: string; const AMensagem: string);
  end;
  EMinimumValueConstraint = class(Exception)
  public
    constructor Create(const ADisplayLabel: String;
      const AValue: Double);
  end;
  EMaximumValueConstraint = class(Exception)
  public
    constructor Create(const ADisplayLabel: String; const AValue: Double);
  end;
  ENotEmptyConstraint = class(Exception)
  public
    constructor Create(const ADisplayLabel: String);
  end;
  EMaxLengthConstraint = class(Exception)
  public
    constructor Create(const ADisplayLabel: String; const MaxLength: Integer);
  end;
  EMinLengthConstraint = class(Exception)
  public
    constructor Create(const ADisplayLabel: String; const MinLength: Integer);
  end;
  EDefaultExpression = class(Exception)
  public
    constructor Create(const ADefault, AColumnName, AClassName: string);
  end;
implementation

{ EClassNotRegistered }
constructor EClassNotRegistered.Create(AClass: TClass);
begin
   inherited CreateFmt('Classe %s n�o registrada. Registre no Initialization usando TRegisterClasses.GetInstance.RegisterClass(%s)',
                       [AClass.ClassName]);
end;
{ EFieldNotNull }
constructor EFieldNotNull.Create(const ADisplayLabel: String);
begin
  inherited CreateFmt('Campo [ %s ] n�o pode ser vazio',
                      [ADisplayLabel]);
end;
{ EHighestConstraint }
constructor EMinimumValueConstraint.Create(const ADisplayLabel: String;
  const AValue: Double);
begin
  inherited CreateFmt('O valor m�nimo do campo [ %s ] permitido � [ %s ]!',
                      [ADisplayLabel, FloatToStr(AValue)]);
end;
{ EFieldValidate }
constructor EFieldValidate.Create(const AField: string; const AMensagem: string);
begin
  inherited CreateFmt('[ %s ] %s',
                      [AField, AMensagem]);
end;
{ EDefaultExpression }
constructor EDefaultExpression.Create(const ADefault, AColumnName, AClassName: string);
begin
  inherited CreateFmt('O valor Default [ %s ] do campo [ %s ] na classe [ %s ], � inv�lido!',
                      [ADefault, AColumnName, AClassName]);
end;
{ EMaximumValueConstraint }
constructor EMaximumValueConstraint.Create(const ADisplayLabel: String; const AValue: Double);
begin
  inherited CreateFmt('O valor m�ximo do campo [ %s ] permitido � [ %s ]!',
                      [ADisplayLabel, FloatToStr(AValue)]);
end;
{ ENotEmptyConstraint }
constructor ENotEmptyConstraint.Create(const ADisplayLabel: String);
begin
  inherited CreateFmt('O campo [ %s ] n�o pode ser vazio!', [ADisplayLabel]);
end;
{ EMaxLengthConstraint }
constructor EMaxLengthConstraint.Create(const ADisplayLabel: String; const MaxLength: Integer);
begin
  inherited CreateFmt('O campo [ %s ] n�o pode ter o tamanho maior que %s!', [ADisplayLabel, IntToStr(MaxLength)]);
end;
{ EMinLengthConstraint }
constructor EMinLengthConstraint.Create(const ADisplayLabel: String; const MinLength: Integer);
begin
  inherited CreateFmt('O campo [ %s ] n�o pode ter o tamanho menor que %s!', [ADisplayLabel, IntToStr(MinLength)]);
end;
end.
