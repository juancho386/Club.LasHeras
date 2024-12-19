Unit CLubAlq; { SyCASe! Club-Alq Unit }
{ CLUBALQ.PAS }

INTERFACE

Type
  PAlquiler = ^TAlquiler;
{ Registro de la lista de alquileres }
  TAlquiler = Record
    Nombre       : String[35];
    VecesXSemana : Byte;
    CantChabones : Array[1..3] of Word;
    Borrado      : Boolean;
  end;

Type { elementos de la lista }
  PElem = ^TElem;

  TElem = Record
    Ant : PElem;
    Reg : TAlquiler;
    Sig : PElem;
  end;


Type
  AlquilerFile = File of TAlquiler;


{ Hace la lista de alquileres }
Procedure ListaAlquileres;


IMPLEMENTATION

Uses Dos, Crt, ClubMain, CASeUnit, Interfaz, Selector,
     Drivers, Mensajes, SCConfig;


{ ­­­CUIDADO!!! antes de llamar por primera vez a estas dos funciones, el }
{ programa principal deber¡a inicializar los punteros de la lista; de lo  }
{ contrario puede llegar a perder informaci¢n o hasta colgar la m quina.  }

Procedure Deshacer(var Primero, Ultimo : PElem);
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



Function Armar(var F : AlquilerFile; var Primero, Ultimo : PElem): Byte;
{   Primero chequea si hay elementos en la lista; si los hay los libera }
{ Luego, si el archivo est  vac¡o, asigna NIL a los punteros; de lo     }
{ contrario, arma la lista leyendo todo el archivo o hasta quedarse con }
{ menos de 64Kb de memoria convencional, que se reservan para poder     }
{ realizar otras operaciones. Puede devolver los siguientes valores :   }
var                                               {  0 : Todo Ok!       }
  Auxiliar : PElem;                               {  1 : Lista vac¡a.   }
begin                                             {  2 : No hay memoria.}
  Armar := 0; { por ahora, todo Ok! }
  If (Primero <> nil)
    then                                { Si hay elementos en lista }
      Deshacer(Primero, Ultimo);   { los libera }
{ El archivo ya debe estar asignado, y su existencia asegurada }
{ De lo contrario puede producirse un error Run-Time y un usuario no }
{ avisado (que sea un nabo) puede morirse de un infarto              }
  Reset(F);      { se sit£a al comienzo del archivo }
  If (FileSize(F) = 0)
    then                     { Si NO hay registros en archivo }
      begin
        Primero      := nil;       { el primero es nulo }
        Ultimo       := Primero;   { y el £ltimo tambi‚n }
        DelayBar(5, 100);   { hacemos creer que el programa trabaja mucho }
        Armar := 1; { Lista vac¡a }
      end
    else       { si HAY socios en el archivo }
      begin
        New(Primero);               { crea el primero }
        Repeat                      { lee el dato del primer socio }
          Read(F, Primero^.Reg);
        Until (Primero^.Reg.Borrado = False)  { si no est  borrado }
                  or Eof(F);        { o lleg¢ al final del archivo }
        If (Primero^.Reg.Borrado = False)
          then         { si no tiene el atributo de 'Borrado' }
            begin
              Primero^.Sig := nil;        { el siguiente es nil }
              Primero^.Ant := nil;        { en el anterior no hay nada }
              Ultimo       := Primero;    { el £ltimo es el primero porque es }
                                          { el £nico hasta ahora }
            end
          else
            begin
              Armar := 1; { Lista vac¡a }
              Dispose(Primero);
              Primero := nil;  { el primero es nulo }
              Ultimo  := nil;  { y el £ltimo tambi‚n }
            end;

        While not EoF(F) and { Hasta llegar al final del archivo... }
              (MaxAvail > 16*1024) do { o hasta agotar la memoria. }
          begin
            New(Auxiliar);           { se crea uno nuevo }
            Repeat
              Read(F, Auxiliar^.Reg);              { lee el dato del socio }
            Until (Auxiliar^.Reg.Borrado = False)  { si no est  borrado }
                  or Eof(F);             { o lleg¢ al final del archivo }
            If (Auxiliar^.Reg.Borrado = False)
              then
                begin
                  Ultimo^.Sig := Auxiliar; { le sigue al que antes era el }
                                                                 { £ltimo }
                  Auxiliar^.Ant := Ultimo; { el anterior es el que antes }
                                                         { era el £ltimo }
                  Ultimo := Auxiliar;      { ahora el nuevo es el £ltimo }
                  Auxiliar^.Sig := nil;    { y no le sigue nada por ahora }
                end;
            DelayBar(1, 10);   { hacemos creer que el programa trabaja mucho }
          end;
      end; { If FileSize(F) }
  DelayBar(5, 100);   { ­Chau!, ­c¢mo labura este programa!!! (verso total) }
  If (MaxAvail < 16*1024)
    then
      Armar := 3; { No alcanz¢ la memoria }
end; { --- Armar --- }





Function Iguales(const Reg1, Reg2 : TAlquiler) : Boolean;
begin
  Iguales :=
          (Reg1.Nombre          = Reg2.Nombre)          and
          (Reg1.VecesXSemana    = Reg2.VecesXSemana)    and
          (Reg1.CantChabones[1] = Reg2.CantChabones[1]) and
          (Reg1.CantChabones[2] = Reg2.CantChabones[2]) and
          (Reg1.CantChabones[3] = Reg2.CantChabones[3]) and
          (Reg1.Borrado         = Reg2.Borrado);
end; { --- Iguales --- }





{ Agrega un registro de Alquileres }
Function Agrega(var Prim, Ulti : PElem) : Boolean;
var
  Reg : TAlquiler;
  F1  : AlquilerFile;
  Tec : Char; Vez : Byte;
  Lee : Boolean;
  Scr, Scr2 : Screen;
begin
  Scr := Pantalla^;
  DoneVideo;
  Presenta;
  With Reg do
    begin
      Borrado := False;
      CentText(3, '>> Ficha de Alquileres de Pileta <<');
      TextXY(10, 6, '         Escuela :');
      TextXY(10, 8, 'Veces por Semana :');
      GotoXY(30, 6); ReadLn(Nombre);

      TextXY(30, 8, '1   2   3');
      Select(29, 8, 29, 8, 2);
      Repeat

        Tec := ReadKey;
        Case Tec of

          #13 : Case WhereX of
                  29 : VecesXSemana := 1;
                  33 : VecesXSemana := 2;
                  37 : VecesXSemana := 3;
                  else ShowError;
                end;

          #00 : Case ReadKey of
                  #75 : { <- Izquierda }
                    Case WhereX of
                      29 : Select(29, 8, 37, 8, 2);
                      33 : Select(33, 8, 29, 8, 2);
                      37 : Select(37, 8, 33, 8, 2);
                      else ShowError;
                    end;

                  #77 : { Derecha -> }
                    Case WhereX of
                      37 : Select(37, 8, 29, 8, 2);
                      33 : Select(33, 8, 37, 8, 2);
                      29 : Select(29, 8, 33, 8, 2);
                      else ShowError;
                    end;

                  else
                    ErrorBip(TeclaMala);
                end; { Case ReadKey }
          else
            ErrorBip(TeclaMala);
        end; { Case Tec }

      Until (Tec = #13);

    Colorea(TextoNormal, FondoNormal);
    TextXY(10, 10, 'Cantidad de Alumnos que concurren a la Pileta:')  ;

    For Vez := 1 to VecesXSemana do
      begin
        Repeat
          GotoXY(12, 10 + Vez);
          Write('La ', Vez, '¦ vez: ');
          Scr2 := Pantalla^;
{$I-}
          ReadLn(CantChabones[Vez]);
{$I+}
          Lee := (IOResult = 0);
          If not Lee
            then MostrarMensaje('­ERROR FATAL INESPERADO DE EJECUCION!',
                                'C¢digo de Error N§: '+IntAStr(Random(500))+
                                #13#13+
                                'Ingrese s¢lo n£meros (0..255).');
          Pantalla^ := Scr2;
          GotoXY(12, 10 + Vez);
          Write('La ', Vez, '¦ vez: ');
          If Lee then WriteLn(CantChabones[Vez]);
        Until Lee;

        CASe Vez of
          1 :
            begin
              CantChabones[2] := 0;
              CantChabones[3] := 0;
            end;
          2 : CantChabones[3]:=0;
        end { CASe Vez }
      end;


    end; { with Reg }

  Assign(F1, 'ALQUILER.SCA');

  Reset(F1);
  Seek(F1, FileSize(F1)); { se prepara para escribir }

  GotoXY(10, 20);
  Vueltas(3, 30);
  If RespondeSi('¨Desea aceptar los datos ingresados?: ')
    then
      begin
        Write('S¡!');
        Write(F1, Reg); { graba el registro en el archivo y }
        Agrega := True;
        Armar(F1, Prim, Ulti); { re-arma la lista }
      end
    else
      begin
        Write('Ehmmm,...no, mejor no.'); { ...ehmmm, no hace nada (creo) }
        Delay(1000);
        Agrega := False;
      end;
  Close(F1);     { Se cierra el archivo }
  InitVideo;
  Pantalla^ := Scr;
end;  { --- AgregaSoc --- }






{ Escribe un registro en los campos de la l¡nea especificada }
{ Tambi‚n se puede especificar si se desea que aparezca seleccionado }
Procedure Mostrar(Selec : Boolean; Linea : Byte; const Rec : TAlquiler);
begin
  If Selec then Colorea(TextoSelec, FondoSelec);
  TextXY(3, Linea, Espacios(75));       { limpia los campos de la tabla }
  TextXY(5, Linea, Rec.Nombre);                 { escribe }
  TextXY(45, Linea, IntAStr(Rec.VecesXSemana));            { los }
  TextXY(57, Linea, IntAStr(Rec.CantChabones[1]));        { datos }
  TextXY(65, Linea, IntAStr(Rec.CantChabones[2]));
  TextXY(73, Linea, IntAStr(Rec.CantChabones[3]));
  If Selec then Colorea(TextoNormal, FondoNormal);
end; { --- Mostrar --- }



{ Muestra los 12 registros que caben en la ventana de la lista }
Procedure Mostrar12(P : PElem);
var
  L : Byte;
begin
  Colorea(TextoNormal, FondoNormal);
  L := 8;
  While (L < 20) do
    begin
      If (P <> nil)
        then
          begin
            Mostrar(False, L, P^.Reg);
            P := P^.Sig;
            L := L + 1;
          end
        else
          begin
            TextXY(3, L, Espacios(75));
            L := L + 1;
          end;
    end;
end; { --- Mostrar10 --- }



{ Sube un registro en la lista }
Procedure Arriba(var Linea : Byte; var P : PElem);
begin
  Sound(50);
  If (P^.Ant = nil)
    then
      ErrorBip(TeclaMala)
    else
      begin
        If (Linea > 8)
          then
            begin
              Mostrar(False, Linea, P^.Reg);
              P := P^.Ant;
              Linea := Linea - 1;
              Mostrar(True, Linea, P^.Reg);
            end
          else
            begin
              P := P^.Ant;
              Mostrar12(P);
              Mostrar(True, Linea, P^.Reg);
            end;
      end;
  NoSound;
end; { --- Arriba --- }



{ Baja un registro en le lista }
Procedure Abajo(var Linea : Byte; var P : PElem);
begin
  Sound(50);
  If (P^.Sig = nil)
    then
      ErrorBip(TeclaMala)
    else
      begin
        If (Linea < 19)
          then
            begin
              Mostrar(False, Linea, P^.Reg);
              P := P^.Sig;
              Linea := Linea + 1;
              Mostrar(True, Linea, P^.Reg);
            end
          else
            begin
              P := P^.Sig;
              Mostrar12(P^.Ant^.Ant^.Ant^.Ant^.Ant^.
                      { 1    2    3    4    5    6 }
                      Ant^.Ant^.Ant^.Ant^.Ant^.Ant);
                      { 7    8    9   10   11   12 }
              Mostrar(True, Linea, P^.Reg);
            end;
      end;
  NoSound;
end; { --- Abajo --- }




{ Se sit£a al comienzo de la lista }
Procedure Inicio(var Linea : Byte; var P : PElem);
begin
  While (P^.Ant <> nil) do Arriba(Linea, P);
end; { --- Inicio --- }



{ Sube hasta 12 registros en la lista (de un saque) }
Procedure PageUp(var P : PElem; var Linea : Byte);
var X : Byte;
begin
  X := 1;
  While (P^.Ant <> nil) and (X < 12) do
    begin
      Delay(10);
      Arriba(Linea, P);
      X := X + 1;
    end;
end; { --- PageUp --- }


{ Baja hasta 12 registros en la lista (de un saque) }
Procedure PageDown(var P : PElem; var Linea : Byte);
var X : Byte;
begin
  X := 1;
  While (P^.Sig <> nil) and (X < 12) do
    begin
      Delay(10);
      Abajo(Linea, P);
      X := X + 1;
    end;
end; { --- PageDown --- }



{ Se sit£a al fibal de la lista }
Procedure Final(var Linea : Byte; var P : PElem);
begin
  While (P^.Sig <> nil) do Abajo(Linea, P);
end; { --- Final --- }




{ Elimina el registro de la lista, asign ndole el atributo de borrado y }
{ volviendo a armar la lista }
Procedure Borrar(var Pri, Ult, Aux : PElem; var Linea : Byte);
var Scr     : Screen;
    Arch    : AlquilerFile;
    Reg1    : TAlquiler;
begin
  Scr := Pantalla^; { guarda la pantalla }
  Window(5, 9, 75, 16); { crea un cuadro de di logo }
  Colorea(TextoSelec, FondoSelec);
  ClrScr;
  TextXY(9, 1, '>>>>>>>>>>>>>>>> ­­­ C U I D A D O !!! <<<<<<<<<<<<<<<<');
  ErrorBip(ErrorDeUsuario);     { por si es ciego, para que escuche }
  TextXY(3, 3, '­El registro de '+ Aux^.Reg.Nombre);
  TextXY(3, 4, 'est  a punto de ser eliminado!!!.');
  TextXY(10, 6, '');
  If RespondeSi('¨ Est  usted seguro ?')
    then
      begin { Borra el socio, noma'... }
        Write('S¡...');

        If not ExisteArchivo('ALQUILER.SCA', Archive)
          then                            { avisa en caso de error }
            ShowError;
        Assign(Arch, 'ALQUILER.SCA');
        Reset(Arch);             { abre el archivo }

        Repeat
          If EoF(Arch) { busca el registro del socio actual }
            then       { ­ERROR FATAL!: El socio estaba en la lista, }
              ShowError;               { pero no en el archivo!!! }
          Read(Arch, Reg1);
        Until Iguales(Reg1, Aux^.Reg);

        Seek(Arch, FilePos(Arch) - 1);  { Retrocede un registro }
                                        { para actualizarlo }
        Reg1.Borrado := True; { le asigna el atributo de Borrado }
        Write(Arch, Reg1);      { y lo escribe en el archivo }

        Armar(Arch, Pri, Ult); { vuelve a armar la lista }
        Close(Arch);   { cierra el archivo }

        Aux := Pri;    { nos situamos al comiemzo de la lista }

        Colorea(TextoNormal, FondoNormal);
        Window(1,1,80,25); { restaura la ventana }
        Pantalla^ := Scr; { restaura la pantalla }
        Linea := 8;
        Mostrar12(Aux);
        If (Aux <> nil)
          then
            begin
              Mostrar(True, Linea, Aux^.Reg);
            end;
      end
    else
      begin  { ...ehmmm, no hace nada (creo) }
        Write('Ehmmm,...­­­no, mejor no!!!');
        DelayBar(5, 100); { para que el usuario tenga tiempo de leer }
        Colorea(TextoNormal, FondoNormal);
        Window(1,1,80,25); { restaura la ventana }
        Pantalla^ := Scr; { restaura la pantalla }
      end;
end; { --- BorrarSocio --- }







{ Listado de Alquileres }
Procedure Listar(var Prim, Ulti : PElem);
var
  Auxi  : PElem;
  Salir : Boolean;
  Linea : Byte;
begin
  TextXY(5, 6, 'Nombre de la Escuela');
  TextXY(41, 5, 'Veces por');
  TextXY(42, 6, 'semana');
  TextXY(55, 5, 'Cantidad de Alumnos');
  TextXY(54, 6, '1¦ vez');
  TextXY(62, 6, '2¦ vez');
  TextXY(70, 6, '3¦ vez');
  TextXY(1, 7, 'ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ'+
               'ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶');
  Salir := False;
  Auxi := Prim;
  Linea := 8;
  Mostrar12(Auxi);
  If (Auxi <> nil)
    then
      begin
        Mostrar(True, Linea, Auxi^.Reg);
      end;

  Repeat

    Case ReadKey of

      #27 : { Escape }
        begin
          Salir := True;
        end;

(*      #13 : { Enter }          Por ahi, en algun momento lo necesitemos,
        begin                    pero en este momento NO!
          If (Auxi <> nil)
            then
{              MostrarFicha(Auxi^.Soc) }
            else
              ErrorBip(ErrorDeUsuario);
        end;
                                                         *)
(* P  #112,
  p  #80 :
        begin
          If (Auxi <> nil)
            then            Como no hay que pagar nada, lo hacemos volar
              begin
                PagarCuota(Auxi);
                Mostrar(True, Linea, Auxi^.Reg);
              end
            else
              ErrorBip(ErrorDeUsuario);
        end;                      *)

      #00 : { teclas especiales }
        begin
          Case ReadKey of
            #82 : { Insert }
              begin
                 If Agrega(Prim, Ulti)
                   then
                     begin
                       Auxi := Prim;
                       Linea := 8;
                       Mostrar12(Auxi);
                       Mostrar(True, Linea, Auxi^.Reg);
                       Final(Linea, Auxi);
                     end
                   else
                     ErrorBip(TeclaMala);
               end;
            #83 : { Delete }
              begin
                If (Auxi <> nil)
                  then
                    Borrar(Prim, Ulti, Auxi, Linea)
                  else
                    ErrorBip(ErrorDeUsuario);
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












Procedure ListaAlquileres;
var
  F1       : AlquilerFile;
  Pri, Ult : PElem;
begin
  Pri := nil; { Inicializamos los punteros }
  Ult := nil; { ...por si las moscas... }
  Presenta;
  CentText(3, '>> Lista de Alquileres <<');
  Assign(F1, 'ALQUILER.SCA');
  CentText(5, 'Buscando...');
  Vueltas(5,30);
  If not ExisteArchivo('ALQUILER.SCA', Archive)
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
  Case Armar(F1, Pri, Ult) of
    0 : { todo Ok! }
      begin
        CentText(5, '                  ');
        Close(F1);
        Listar(Pri, Ult);
      end;
    1 : { Lista vac¡a }
      begin
        CentText(5, 'No hay registros activos en ALQUILER.SCA');
        CentText(6, 'Use la tecla INSERT para agregar.');
        Vueltas(60, 30);
        CentText(5, '                                                  ');
        CentText(6, '                                                  ');
        Close(F1);
        Listar(Pri, Ult);
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
  Deshacer(Pri, Ult);
end;



BEGIN
END.
{ CLUBALQ.PAS }