unit Dto.VW_ACCOUNT_PERMISISON;

interface

uses
  System.SysUtils, 
  System.Classes, 
  Vcl.Graphics, 
  Data.DB, 
  Generics.Collections, 

  //goxormbr 
  goxormbr.core.consts,
  goxormbr.core.types.blob,
  goxormbr.core.types.mapping,
  goxormbr.core.mapping.classes,
  goxormbr.core.mapping.register,
  goxormbr.core.mapping.attributes,
  //Application 
  Core.Mapping.Attributes;

type
  [Entity]
  [Table('VW_ACCOUNT_PERMISISON', '')]
  TDtoVW_ACCOUNT_PERMISISON = class
  private
    { Private declarations } 
    FACC_CODIGO_PERMISSION: Integer;
    FMEN_CODIGO: Integer;
    FCOM_CODIGO: Integer;
    FAPE_TYPE: String;
    FACC_CODIGO: Integer;
    FACG_CODIGO: Integer;
    FAPE_CONSULT: String;
    FAPE_INSERT: String;
    FAPE_UPDATE: String;
    FAPE_DELETE: String;
    FAPE_ID: Integer;
  public 
    { Public declarations } 
    const Table      = 'VW_ACCOUNT_PERMISISON';

    [Restrictions([NoValidate, NotNull])]
    [Column('ACC_CODIGO_PERMISSION', ftInteger)]
    [ColumnDBGrid('ACC_CODIGO_PERMISSION', 'ACC_CODIGO_PERMISSION', 100, 'Arial', 10, clWindowText, False, taCenter, 'PSQ;')]
    [Dictionary('ACC_CODIGO_PERMISSION', 'Divergente do valor esperado.', '0', '', '', taCenter)]
    property ACC_CODIGO_PERMISSION: Integer read FACC_CODIGO_PERMISSION write FACC_CODIGO_PERMISSION;

    [Restrictions([NoValidate])]
    [Column('MEN_CODIGO', ftInteger)]
    [ColumnDBGrid('MEN_CODIGO', 'MEN_CODIGO', 100, 'Arial', 10, clWindowText, False, taCenter, 'PSQ;')]
    [Dictionary('MEN_CODIGO', 'Divergente do valor esperado.', '0', '', '', taCenter)]
    property MEN_CODIGO: Integer read FMEN_CODIGO write FMEN_CODIGO;

    [Restrictions([NoValidate, NotNull])]
    [Column('COM_CODIGO', ftInteger)]
    [ColumnDBGrid('COM_CODIGO', 'COM_CODIGO', 100, 'Arial', 10, clWindowText, False, taCenter, 'PSQ;')]
    [Dictionary('COM_CODIGO', 'Divergente do valor esperado.', '0', '', '', taCenter)]
    property COM_CODIGO: Integer read FCOM_CODIGO write FCOM_CODIGO;

    [Restrictions([NoValidate])]
    [Column('APE_TYPE', ftString, 3)]
    [ColumnDBGrid('APE_TYPE', 'APE_TYPE', 100, 'Arial', 10, clWindowText, False, taLeftJustify, 'PSQ;')]
    [Dictionary('APE_TYPE', 'Divergente do valor esperado.', '', '', '', taLeftJustify)]
    property APE_TYPE: String read FAPE_TYPE write FAPE_TYPE;

    [Restrictions([NoValidate])]
    [Column('ACC_CODIGO', ftInteger)]
    [ColumnDBGrid('ACC_CODIGO', 'ACC_CODIGO', 100, 'Arial', 10, clWindowText, False, taCenter, 'PSQ;')]
    [Dictionary('ACC_CODIGO', 'Divergente do valor esperado.', '0', '', '', taCenter)]
    property ACC_CODIGO: Integer read FACC_CODIGO write FACC_CODIGO;

    [Restrictions([NoValidate])]
    [Column('ACG_CODIGO', ftInteger)]
    [ColumnDBGrid('ACG_CODIGO', 'ACG_CODIGO', 100, 'Arial', 10, clWindowText, False, taCenter, 'PSQ;')]
    [Dictionary('ACG_CODIGO', 'Divergente do valor esperado.', '0', '', '', taCenter)]
    property ACG_CODIGO: Integer read FACG_CODIGO write FACG_CODIGO;

    [Restrictions([NoValidate])]
    [Column('APE_CONSULT', ftString, 1)]
    [ColumnDBGrid('APE_CONSULT', 'APE_CONSULT', 100, 'Arial', 10, clWindowText, False, taLeftJustify, 'PSQ;')]
    [Dictionary('APE_CONSULT', 'Divergente do valor esperado.', '', '', '', taLeftJustify)]
    property APE_CONSULT: String read FAPE_CONSULT write FAPE_CONSULT;

    [Restrictions([NoValidate])]
    [Column('APE_INSERT', ftString, 1)]
    [ColumnDBGrid('APE_INSERT', 'APE_INSERT', 100, 'Arial', 10, clWindowText, False, taLeftJustify, 'PSQ;')]
    [Dictionary('APE_INSERT', 'Divergente do valor esperado.', '', '', '', taLeftJustify)]
    property APE_INSERT: String read FAPE_INSERT write FAPE_INSERT;

    [Restrictions([NoValidate])]
    [Column('APE_UPDATE', ftString, 1)]
    [ColumnDBGrid('APE_UPDATE', 'APE_UPDATE', 100, 'Arial', 10, clWindowText, False, taLeftJustify, 'PSQ;')]
    [Dictionary('APE_UPDATE', 'Divergente do valor esperado.', '', '', '', taLeftJustify)]
    property APE_UPDATE: String read FAPE_UPDATE write FAPE_UPDATE;

    [Restrictions([NoValidate])]
    [Column('APE_DELETE', ftString, 1)]
    [ColumnDBGrid('APE_DELETE', 'APE_DELETE', 100, 'Arial', 10, clWindowText, False, taLeftJustify, 'PSQ;')]
    [Dictionary('APE_DELETE', 'Divergente do valor esperado.', '', '', '', taLeftJustify)]
    property APE_DELETE: String read FAPE_DELETE write FAPE_DELETE;

    [Restrictions([NoValidate, NotNull])]
    [Column('APE_ID', ftInteger)]
    [ColumnDBGrid('APE_ID', 'APE_ID', 100, 'Arial', 10, clWindowText, False, taCenter, 'PSQ;')]
    [Dictionary('APE_ID', 'Divergente do valor esperado.', '0', '', '', taCenter)]
    property APE_ID: Integer read FAPE_ID write FAPE_ID;
  end;

implementation

initialization
  TRegisterClass.RegisterEntity(TDtoVW_ACCOUNT_PERMISISON)

end.
