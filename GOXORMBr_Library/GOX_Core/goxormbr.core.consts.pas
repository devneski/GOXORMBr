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



unit goxormbr.core.consts;

interface

uses
  TypInfo;

const
  cENUMERATIONSTYPEERROR = 'Invalid type. Type enumerator supported [ftBoolean, ftInteger, ftFixedChar, ftString]';
  cMESSAGEPKNOTFOUND = 'PrimaryKey not found on your model!';
  cMESSAGECOLUMNNOTFOUND = 'Nenhum atributo [Column()] foi definido nas propriedades da classe [ %s ]';
  cPROPERTYTYPES_1 = [tkUnknown,
                      tkInterface,
                      tkClass,
                      tkClassRef,
                      tkPointer,
                      tkProcedure];

  cPROPERTYTYPES_2 = [tkUnknown,
                      tkInterface,
                      tkClassRef,
                      tkPointer,
                      tkProcedure];

  cFIELDEVENTS = '%s event required in column [%s]!';
  cNOTFIELDTYPEBLOB = 'Column [%s] must have blob value';
  cCREATEBINDDATASET = 'Access class %s by method %s';


//---------------------------------------------------
  cMask_CEP            = '99\.999\-999;0; ';
  cMask_DDDFone        = '99\ 9999\-9999;0; ';
  cMask_DDDCelular     = '99\ 99999\-9999;0; ';
  cMask_PlacaVeiculo   = 'lll\-9999;0; ';
  cMask_CFOP           = '9\.999;0; ';
  cMask_CPF            = '999\.999.999\-99;0; ';
  cMask_CNPJ           = '99\.999.999\/9999\-99;0; ';
  cMask_Data           = '99\/99\/9999;0; ';
  cMask_DataJSON       = '99\/99\/9999;1; ';
  cMask_DataHora       = '99\/99\/9999\ 99\:99\:99;0; ';
  cMask_DataHHMM       = '99\/99\/9999\ 99\:99;0; ';
  cMask_HoraHHMM       = '99\:99;0; ';
  cMask_HoraHHMMSS     = '99\:99\:99;0; ';
  cMask_MesAno         = '99\-9999;0; ';

  cfmt_DateUTC         = 'YYYY-MM-DD';
  cfmt_DateTimeUTC     = 'YYYY-MM-DD HH:MM:SS';
  cfmt_DateFormat      = 'DD/MM/YYYY';

  cfmt_Valor2Decimal   = '######0.00'; // 100000,00
  cfmt_Valor3Decimal   = '######0.000';
  cfmt_Valor4Decimal   = '######0.0000';
  cfmt_Valor5Decimal   = '######0.00000';
  cfmt_Valor6Decimal   = '######0.000000';
  cfmt_Valor7Decimal   = '######0.0000000';
  cfmt_Valor8Decimal   = '######0.00000000';
  cfmt_Valor9Decimal   = '######0.000000000';
  cfmt_Valor10Decimal  = '######0.0000000000';

  cfmt_Valor2DecimalSeparadorMilhar = '###,##0.#0'; // 100.000,00

  cfmt_Percentual2Decimal = '0.00';
  cfmt_Percentual3Decimal = '0.000';
  cfmt_Percentual4Decimal = '0.0000';
  cfmt_Percentual5Decimal = '0.00000';
  cfmt_Percentual6Decimal = '0.000000';


implementation

end.

