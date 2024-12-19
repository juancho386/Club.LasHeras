Unit SCATypes;

INTERFACE

{ ---=== Tipos de datos utilizados por la Base de Datos ===--- }

Type
  PCadenaH = ^CadenaH;
  CadenaH = Record
    D : Byte; { La columna del D¡a }
    F : Byte; { La fila }
    C : Byte; { La columna }
  end;

  { los d¡as y el horario que va el chab¢n. }
  { XEj:(2,3,1) significa: Martes, Categor¡a "C", Horario 1 }

  THorario = Array[1..3] of CadenaH;


Type
{ Puntero a un socio }
  PSocio = ^TSocio;
{ Datos de un socio }
  TSocio = Record
    Nombre,
    Apellido  : String[25];
    Edad      : Byte;
    Direccion : String[50];
    Telefono,
    FechaIng  :	String[10];
    MesPagado :	Word;   { el £ltimo mes que pag¢ }
    Categoria :	Char;
    Horario   : THorario;
    Borrado   : Boolean;
  end;

Type
{ Puntero a un elemento de lista }
  PElem = ^TElem;
{ Elemento de Lista }
  TElem = Record
    Ant : PElem;  { Elemento anterior en la lista }
    Soc : TSocio; { Dato propiamente dicho }
    Sig : PElem;  { Siguiente elemento }
  end;

Type { Archivo de Base de Datos de los Socios }
  SocioFile = File of TSocio;




IMPLEMENTATION


BEGIN
END.