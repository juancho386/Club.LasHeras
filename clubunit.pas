Unit ClubUnit;{ SyCASe! Club Unit }

INTERFACE


{ ---=== Tipos de datos utilizados por la Base de Datos ===--- }

Type
  PCadenaH = ^CadenaH;
  CadenaH = Record
    D : Byte; { La columna del D¡a }
    F : Byte; { La fila }
    C : Byte; { La columna }
  end;

  THorario = Array[1..3] of CadenaH;
  { los d¡as y el horario que va el chab¢n. XEj:'MiB3' }


Type
{ Puntero a un socio }
  PSocio = ^TSocio;
{ Datos de un socio }
  TSocio = Record
    Nombre,
    Apellido  : String[25];
    Direccion : String[40];
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



{ ---=== Funciones y Procedimientos P£blicos de esta Unidad ===--- }

{ Funci¢n principal para el manejo de la lista }
Function ListaPrincipal(Socios : Boolean): Byte;
{ Si Socios es True, mostrar  la lista de Socios }
{ Si Socios es False, mostrar  la lista de los que concurren a pileta libre }


IMPLEMENTATION

Uses Dos, Crt, Drivers, ClubMain, Interfaz, CASeUnit, Selector;


{ ­­­CUIDADO!!! antes de llamar por primera vez a estas dos funciones, el }
{ programa principal deber¡a inicializar los punteros de la lista; de lo  }
{ contrario puede llegar a perder informaci¢n o hasta colgar la m quina.  }

Procedure DeshacerLista(var Primero, Ultimo : PElem);
{ Primero chequea si los punteros Primero y Ultimo son distintos. Si es as¡ }
{ asume que hay MAS de UN elemento, y mientras sea as¡, va a ir liberando   }
{ el que est‚ £ltimo en la lista. Luego pasa a preguntar si el Primero      }
{ apunta a NIL, lo que significa que NO HAY elementos; sino, al haber pasado}
{ por el bucle anterior, habr¡a quedado UNO SOLO que es liberado ahora.     }
{ Por £ltimo asigna el valor NIL a Primero y a Ultimo.                      }
begin
  While (Primero <> Ultimo) do  { Mientras haya m s de un dato }
    begin                       { en la lista }
      Ultimo := Ultimo^.Ant;    { se mueve uno antes }
      Dispose(Ultimo^.Sig);     { Deposita el £ltimo }
    end;
  If (Primero <> nil)           { Si queda uno }
    then
      begin
        Dispose(Primero);       { lo libera }
      end;
  Primero := nil;
  Ultimo := nil;
end;




Function ArmarLista(var F : SocioFile; var Primero, Ultimo : PElem): Byte;
{   Primero chequea si hay elementos en la lista; si los hay los libera }
{ Luego, si el archivo est  vac¡o, asigna NIL a los punteros; de lo     }
{ contrario, arma la lista leyendo todo el archivo o hasta quedarse con }
{ menos de 64Kb de memoria convencional, que se reservan para poder     }
{ realizar otras operaciones. Puede devolver los siguientes valores :   }
var                                               {  0 : Todo Ok!       }
  Auxiliar : PElem;                               {  1 : Lista vac¡a.   }
begin                                             {  2 : No hay memoria.}
  ArmarLista := 0; { por ahora, todo Ok! }
  If (Primero <> nil)
    then                                { Si hay elementos en lista }
      DeshacerLista(Primero, Ultimo);   { los libera }
{ El archivo ya debe estar asignado, y su existencia asegurada }
{ De lo contrario puede producirse un error Run-Time y un usuario no }
{ avisado (que sea un nabo) puede morirse de un infarto              }
  Reset(F);      { se sit£a al comienzo del archivo }
  If (FileSize(F) = 0)
    then                     { Si NO hay registros en archivo }
      begin
        Primero      := nil;       { el primero es nulo }
        Ultimo       := Primero;   { y el £ltimo tambi‚n }
        Vueltas(5,30);   { hacemos creer que el programa trabaja mucho }
        ArmarLista := 1; { Lista vac¡a }
      end
    else       { si HAY socios en el archivo }
      begin
        New(Primero);               { crea el primero }
        Primero^.Sig := nil;        { el siguiente es nil }
        Primero^.Ant := nil;        { en el anterior no hay nada }
        Read(F, Primero^.Soc);      { lee el primer socio }
        Ultimo       := Primero;    { el £ltimo es el primero porque es }
                                    { el £nico hasta ahora }
        While not EoF(F) and { Hasta llegar al final del archivo... }
              (MaxAvail > 16*1024) do { o hasta agotar la memoria. }
          begin
            New(Auxiliar);           { se crea uno nuevo }
            Ultimo^.Sig := Auxiliar; { le sigue al que antes era el }
                                                           { £ltimo }
            Auxiliar^.Ant := Ultimo; { el anterior es el que antes era el }
                                                           { £ltimo }
            Repeat
              Read(F, Auxiliar^.Soc);              { lee el dato del socio }
            Until (Auxiliar^.Soc.Borrado = False)  { si no est  borrado }
                  or Eof(F);             { o lleg¢ al final del archivo }
            Ultimo := Auxiliar;      { ahora el nuevo es el £ltimo }
            Auxiliar^.Sig := nil;    { y no le sigue nada por ahora }
          end;
          Vueltas(10, 30);   { hacemos creer que el programa trabaja mucho }
      end; { If FileSize(F) }
  If (MaxAvail < 16*1024)
    then
      ArmarLista := 3; { No alcanz¢ la memoria }
end;




Function AgregaSoc(Socios : Boolean; var Prim, Ulti : PElem) : Boolean;
var
  Reg : TSocio;
  Anio, Mes, Dia, DiaSem : Word;
  F1  : SocioFile;
  Tec : char;
  Archivo : NameStr;
  Escrin : Screen;
begin
  Presenta;
  With Reg do
    begin
      Borrado := False;
      CentText(3, '>>Ficha de ingreso de socios a la escuela de nataci¢n<<');
      TextXY(11, 5, ' Apellido :');
      TextXY(11, 6, '   Nombre :');
      TextXY(11, 7, 'Direcci¢n :');
      TextXY(11, 8, ' Tel‚fono :');

      GotoXY(23, 5); ReadLn(Apellido);
      GotoXY(23, 6); ReadLn(Nombre);
      GotoXY(23, 7); ReadLn(Direccion);
      GotoXY(23, 8); ReadLn(Telefono);

     { levanta la fecha del sistema }
      Getdate(Anio, Mes, Dia, DiaSem);
      FechaIng :=  IntAStr(Dia) + '/'
                 + IntAStr(Mes) + '/'
                 + IntAStr(Anio);
      TextXY(11, 9, 'Fecha de Ingreso: ' + FechaIng);

      TextXY (13, 11, 'El sistema deduce que el socio ' + Apellido + ', ' + Nombre);
      TextXY (13, 12, 'ya ha pagado el corriente mes.');
      MesPagado := Mes;

      Escrin := Pantalla;

      If Socios
        then
          begin
            Assign(F1, 'SOCIOS.SCA');
            TextXY (10, 14, 'Seleccione una Categor¡a: De 3 a 5 a¤os');
            TextXY                           (36, 15, 'De 6 a 12 a¤os');
            TextXY                           (36, 16, 'Adultos');
            TextXY                           (36, 17, 'Equipo');
            TextXY                           (36, 18, 'Otros');
            Select(35, 14, 35, 14, 15);
            Repeat
              Tec := ReadKey;
              CASe Tec of
                #00 :
                  begin
                    CASe ReadKey of
                      #80 : CASe WhereY of
                              14 : select(35,14,35,15,15);
                              15 : select(35,15,35,16,15);
                              16 : select(35,16,35,17,15);
                              17 : select(35,17,35,18,15);
                              18 : select(35,18,35,14,15);
                              else
                                sonido (80,100);
                            end;
                      #72 : CASe WhereY of
                              18 : select(35,18,35,17,15);
                              17 : select(35,17,35,16,15);
                              16 : select(35,16,35,15,15);
                              15 : select(35,15,35,14,15);
                              14 : select(35,14,35,18,15);
                              else
                                sonido (80,100);
                            end;
                      else
                        ErrorBip(TeclaMala);
                    end;
                  end; { #00 }
                #13 : CASe WhereY of
                        14 : categoria := 'A';
                        15 : categoria := 'B';
                        16 : categoria := 'C';
                        17 : categoria := 'D';
                        18 : categoria := 'E';
                        else
                          ShowError;
                      end; {CASe #13}
                else
                  Sonido(80,100);
              end;
            Until (Tec = #13);
          end
        else
          begin
            Assign(F1, 'PLIBRE.SCA');
            Categoria := 'F';
          end;
      Colorea (7,6);

      Pantalla := Escrin;
      TextXY(11, 14, 'Categor¡a : "' + Reg.Categoria + '"');
      Vueltas(3, 30);
      Escrin := Pantalla;
      TextXY(30, 14, 'Horarios :');
      Vueltas(10,30);
      Horario[1] := Matrix^;
      Pantalla := Escrin;
      TextXY(30, 14, Cadena2Str(Horario[1]));
      Vueltas(10,30);
      Escrin := Pantalla;
      Horario[2] := Matrix^;
      Pantalla := Escrin;
      TextXY(30, 15, Cadena2Str(Horario[2]));
      Vueltas(10,30);
      Escrin := Pantalla;
      Horario[3] := Matrix^;
      Pantalla := Escrin;
      TextXY(30, 16, Cadena2Str(Horario[3]));
      Vueltas(10,30);

    end; { with Reg }
  TextXY (10, 20, '¨Desea aceptar los datos ingresados? (S/N): ');
  Tec := Readkey;
  Reset(F1);
  Seek(F1, FileSize(F1));
  If UpCASe (Tec) = 'S'
    then
      begin
        Write('S¡!');
        Write(F1, Reg); { graba el registro en el archivo }
        AgregaSoc := True;
        ArmarLista(F1, Prim, Ulti);
      end
    else
      begin
        Write('Ehmmm,...no, mejor no.');
        Delay(1000);
        AgregaSoc := False;
      end;
  Close(F1);     { Se cierra el archivo de }
end;







Procedure MostrarSocio(Selec : Boolean; Linea : Byte; const Soc : TSocio);
begin
  If Selec then Colorea(7, 8);
  TextXY(3, Linea, Espacios(75));
  TextXY(5, Linea, Soc.Apellido+',');
  TextXY(32, Linea, Soc.Nombre+'.');
  TextXY(60, Linea, Soc.Categoria);
  TextXY(65, Linea, MesesStr[Soc.MesPagado]);
  If Selec then Colorea(7, 6);
end;



Procedure Mostrar10(P : PElem);
var
  L : Byte;
begin
  Colorea(7,6);
  L := 8;
  While (L <= 18) do
    begin
      If (P <> nil)
        then
          begin
            MostrarSocio(False, L, P^.Soc);
            P := P^.Sig;
            L := L + 1;
          end
        else
          begin
            TextXY(5, L, Espacios(70));
            L := L + 1;
          end;
    end;
end;



Procedure Arriba(var Linea : Byte; var P : PElem);
begin
  If (P^.Ant = nil)
    then
      ErrorBip(TeclaMala)
    else
      begin
        If (Linea > 8)
          then
            begin
              MostrarSocio(False, Linea, P^.Soc);
              P := P^.Ant;
              Linea := Linea - 1;
              MostrarSocio(True, Linea, P^.Soc);
            end
          else
            begin
              P := P^.Ant;
              Mostrar10(P);
              MostrarSocio(True, Linea, P^.Soc);
            end;
      end;
end;



Procedure Abajo(var Linea : Byte; var P : PElem);
begin
  If (P^.Sig = nil)
    then
      ErrorBip(TeclaMala)
    else
      begin
        If (Linea < 18)
          then
            begin
              MostrarSocio(False, Linea, P^.Soc);
              P := P^.Sig;
              Linea := Linea + 1;
              MostrarSocio(True, Linea, P^.Soc);
            end
          else
            begin
              P := P^.Sig;
              Mostrar10(P^.Ant^.Ant^.Ant^.Ant^.Ant^.Ant^.Ant^.Ant^.Ant^.Ant);
                      {     1    2    3    4    5    6    7    8    9   10 }
              MostrarSocio(True, Linea, P^.Soc);
            end;
      end;
end;


Procedure PageUp(var P : PElem; var Linea : Byte);
var X : Byte;
begin
  X := 0;
  While (P^.Ant <> nil) and (X < 10) do
    begin
      Delay(10);
      Arriba(Linea, P);
      X := X + 1;
    end;
end;



Procedure PageDown(var P : PElem; var Linea : Byte);
var X : Byte;
begin
  X := 0;
  While (P^.Sig <> nil) and (X < 10) do
    begin
      Delay(10);
      Abajo(Linea, P);
      X := X + 1;
    end;
end;




Procedure Inicio(var Linea : Byte; var P : PElem);
begin
  While (P^.Ant <> nil) do Arriba(Linea, P);
end;


Procedure Final(var Linea : Byte; var P : PElem);
begin
  While (P^.Sig <> nil) do Abajo(Linea, P);
end;



Procedure PagarMes(var P : PElem);
begin

end;




Procedure Listar(Socios : Boolean; var Prim, Ulti : PElem);
var
  Auxi  : PElem;
  Salir : Boolean;
  Linea : Byte;
  Scr   : ^Screen;
begin
  Salir := False;
  Auxi := Prim;
  Linea := 8;
  If (Auxi <> nil)
    then
      begin
        Mostrar10(Auxi);
        MostrarSocio(True, Linea, Auxi^.Soc);
      end;

  Repeat

    Case ReadKey of

      #27 : { Escape }
        begin
          Salir := True;
        end;

      #13 : { Enter }
        begin
          ErrorBip(ErrorDeUsuario);
        end;

{ P } #112,
      #80 :
        begin
          If (Auxi <> nil)
            then
              begin
                New(Scr);
                Scr^ := Pantalla;
                PagarMes(Auxi);
                MostrarSocio(True, Linea, Auxi^.Soc);
                Pantalla := Scr^;
                Dispose(Scr);
              end
            else
              ErrorBip(ErrorDeUsuario);
        end;

      #00 : { teclas especiales }
        begin
          Case ReadKey of
            #82 : { Insert }
              begin
                 New(Scr);
                 Scr^ := Pantalla;
                 DoneVideo;
                 AgregaSoc(Socios, Prim, Ulti);
                 InitVideo;
                 Pantalla := Scr^;
                 Dispose(Scr);
                 Auxi := Prim;
                 Linea := 8;
                 Mostrar10(Auxi);
                 If (Auxi = Ulti)
                   then
                     ErrorBip(TeclaMala)
                   else
                     If (Auxi <> nil)
                       then
                         begin
                           Final(Linea, Auxi);
                         end
                       else
                         ErrorBip(TeclaMala);
               end;
            #83 : { Delete }
              begin
              end;
            #72 : { Arriba }
              begin
                If (Auxi <> nil)
                  then
                    Arriba(Linea, Auxi)
                  else
                    ErrorBip(TeclaMala);
              end;
            #80 : { Abajo }
              begin
                If (Auxi <> nil)
                  then
                    Abajo(Linea, Auxi)
                  else
                    ErrorBip(TeclaMala);
              end;
            #73 : { Page Up }
              begin
                If (Auxi = Prim)
                  then
                    ErrorBip(TeclaMala)
                  else
                    If (Auxi <> nil)
                      then
                        begin
                          PageUp(Auxi, Linea);
                        end
                      else
                        ErrorBip(TeclaMala);
              end;
            #81 : { Page Down }
              begin
                If (Auxi = Ulti)
                  then
                    ErrorBip(TeclaMala)
                  else
                    If (Auxi <> nil)
                      then
                        begin
                          PageDown(Auxi, Linea);
                        end
                      else
                        ErrorBip(TeclaMala);
              end;
            #71 : { Home }
              begin
                If (Auxi = Prim)
                  then
                    ErrorBip(TeclaMala)
                  else
                    If (Auxi <> nil)
                      then
                        begin
                          Inicio(Linea, Auxi);
                        end
                      else
                        ErrorBip(TeclaMala);
              end;
            #79 : { End }
              begin
                If (Auxi = Ulti)
                  then
                    ErrorBip(TeclaMala)
                  else
                    If (Auxi <> nil)
                      then
                        begin
                          Final(Linea, Auxi);
                        end
                      else
                        ErrorBip(TeclaMala);
              end;
            else
              ErrorBip(TeclaMala);
          end;

        end; { #00 }

      else
        ErrorBip(TeclaMala);
    end;

  Until Salir;
end;








Function ListaPrincipal(Socios : Boolean): Byte;
var
  F1       : SocioFile; Archivo : NameStr;
  Pri, Ult : PElem;
begin
  Pri := nil; { Inicializamos los punteros }
  Ult := nil; { ...por si las moscas... }
  Presenta;
  If Socios
    then
      begin
        Archivo := 'SOCIOS';   { Archivo de Socios }
        CentText(3, '>>Lista de socios que concurren a' +
                    ' la Escuela de Nataci¢n<<')
      end
    else
      begin
        Archivo := 'PLIBRE';  { Archivo de Pileta Libre }
        CentText(3, '>>Lista de los que concurren a' +
                    ' Pileta Libre<<')
      end;
  Assign(F1, Archivo + '.SCA');
  CentText(5, 'Buscando...');
  Vueltas(5,30);
  If not ExisteArchivo(Archivo + '.SCA', Archive)
    then
      begin
        CentText(5, '­No se encontr¢ el archivo de la base de datos!');
        ErrorBip(FaltaArchivo);
        CentText(6, 'Creando un nuevo archivo de base de datos.');
        Vueltas(20,30);
        ReWrite(F1);
      end
    else
      begin         {si existe}
   	Reset(F1);  {lo abre}
      end;

  CentText(5, '                                                          ');
  CentText(6, '                                                          ');
  CentText(5, ' Leyendo... ');
  Vueltas(5, 30);
  Case ArmarLista(F1, Pri, Ult) of
    0 : { todo Ok! }
      begin
        CentText(5, '                  ');
        Close(F1);
        Listar(Socios, Pri, Ult);
      end;
    1 : { Lista vac¡a }
      begin
        CentText(5, 'No hay registros en el archivo '+ Archivo + '.SCA');
        CentText(6, 'Use la tecla INSERT para agregar.');
        Vueltas(60, 30);
        CentText(5, '                                                  ');
        CentText(6, '                                                  ');
        Close(F1);
        Listar(Socios, Pri, Ult);
      end;
    2 : { No alcanz¢ la memoria }
      begin
        Close(F1);
        CentText(5, 'No hay memoria suficiente para crear '+
                    'la lista completa.');
        CentText(7, 'Trate de liberar memoria convencional o '+
                    'llame al Servicio de Soporte SyCASe!');
        ErrorBip(NoHayMemoria);
        Vueltas(100, 30);
        CentText(5, '                                        '+
                    '                                     ');
        CentText(7, '                                        '+
                    '                                     ');
      end;
    else
      ShowError;
  end; { Case ArmarLista }
  DeshacerLista(Pri, Ult);
end;




BEGIN
END.  { SyCASe! ClubUnit - CLUBUNIT.PAS }
