Program Update;

Uses Crt, CASeUnit;

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
{ Datos de un socio (estructura antigua) }
  OldTSocio = Record
    Nombre,
    Apellido  : String[25];
    Direccion : String[50];
    Telefono,
    FechaIng  :	String[10];
    MesPagado :	Word;   { el £ltimo mes que pag¢ }
    Categoria :	Char;
    Horario   : THorario;
    Borrado   : Boolean;
  end;

{ Datos de un socio (nueva estructura) }
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

var OldFile : File of OldTSocio;
    NewFile : File of TSocio;
    OldSoc  : OldTSocio;
    NewSoc  : TSocio;

begin
  ClrScr;
  CentText(2, 'SyCASe! UpDate');
  CentText(3, '==============');
  CentText(5, 'Programa actualizador de la base de datos del');
  CentText(6, 'Programa Administrativo de la Escuela de Nataci¢n del Club Las Heras');
  CentText(7, '<think: que te recontra>');
  WriteLn;
  Vueltas(10, 40);
  WriteLn;
  If ParamCount = 0
    then
      begin
        WriteLn('Uso:  UPDATE.EXE <oldfile>');
        WriteLn;
        WriteLn('Donde <oldfile> es el archivo a actualizar. No debe indicar la extensi¢n');
        Halt(0);
      end;
  ReadKey;
  ClrScr;
  Assign(OldFile, ParamStr(1)+'.SCA');
  Reset(OldFile);
  Assign(NewFile, ParamStr(1)+'.NEW');
  ReWrite(NewFile);
  WriteLn('UpDating (please wait a couple of hours)...');
  While not EoF(OldFile) do
    begin
      Read(OldFile, OldSoc);
      With OldSoc do
        begin
          Write('Updating...', Nombre);
          Vueltas(1, 30);
          WriteLn;
          NewSoc.Nombre    := Nombre;
          NewSoc.Apellido  := Apellido;
          NewSoc.Edad      := 0;
          NewSoc.Direccion := Direccion;
          NewSoc.Telefono  := Telefono;
          NewSoc.FechaIng  := FechaIng;
          NewSoc.MesPagado := MesPagado;
          NewSoc.Categoria := Categoria;
          NewSoc.Horario   := Horario;
          NewSoc.Borrado   := Borrado;
        end;
      Write(NewFile, NewSoc);
    end;
  WriteLn('Actualizaci¢n finalizada.');
  Close(NewFile);
  Close(OldFile);
  WriteLn('Creando copia de seguridad...');
  Rename(OldFile, ParamStr(1)+'.CDS');
  WriteLn('Creando nuevo archivo de lista...');
  Rename(NewFile, ParamStr(1)+'.SCA');
end.