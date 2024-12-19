Unit SCMatrix;


INTERFACE

Uses SCATypes;

{ Matriz de Horarios, devuelve un puntero a una cadena de horario para ser }
{ almacenada en el archivo de la base de datos. Para ser interpretada debe }
{ utilizarse la funci¢n Cadena2Str que devuelve un String descriptivo de   }
{ una cadena de horario.                                                   }
Function Matrix : PCadenaH;

{ Convierte una Cadena de Horario en el String Descriptivo, tal como }
{ figura en la Matriz de Horarios del archivo MATRIX.SCA             }
Function Cadena2Str(Cad : CadenaH) : String;

{ Convierte el caracter de Categor¡a en su String descriptivo }
Function Categoria2Str(Cat : Char) : String;


{ ---=== Funciones de Listado de Socios por Horarios ===--- }

{ Lista los socios que concurren en un determinado horario }
Function ListaPorHorarios(PCH : PCadenaH): Byte;




IMPLEMENTATION

Uses Crt, Drivers,
     Interfaz, Mensajes, CASeUnit, Selector, SCConfig, ClubMain, ClubList;



Procedure Mat2Scr;
Var M : text;
    Line :string [80];
Begin
  If not Encuentra('MATRIX.SCA')
    then
      ShowError;
  Assign(M, 'MATRIX.SCA');
  Reset(M);
  ClrScr;
    While not EoF(M) do
      begin
	ReadLn(M, Line);
	WriteLn(Line);
      end;
  Close (M);
End;



Function Matrix : PCadenaH;
var
  MatAuxil : PCadenaH;
  MatXPos, MatYPos : Byte;
  Tec : Char;
  P   : Screen;
begin
  P := Pantalla^; { guarda la pantalla }
  InitVideo;
  Colorea(TextoNormal, FondoNormal);
  Mat2Scr;
  Select(14, 6, 14, 6, 7); {la matriz tiene registros de 7 chars}
  Repeat
    Tec := ReadKey;
    CASe Tec of
      #13 : { Enter }
        begin
          MatXPos := WhereX;
          MatYPos := WhereY;
          CASe MatXPos of
            14 : MatAuxil^.D :=1; { Lunes }
            25 : MatAuxil^.D :=2; { Martes }
            36 : MatAuxil^.D :=3; { Mi‚rcoles }
            47 : MatAuxil^.D :=4; { Jueves }
            58 : MatAuxil^.D :=5; { Viernes }
            69 : MatAuxil^.D :=6; { S bado }
          end;
          MatAuxil^.F := MatYPos;
          MatAuxil^.C := MatXPos;
        end;

      #00 : { Teclas especiales }
        CASe ReadKey of
{ flecha arriba }
          #72 :
            CASe WhereY of
              23 : Select(WhereX, WhereY, WhereX, 22, 7); { Cat "E" }
              22 : Select(WhereX, WhereY, WhereX, 21, 7);
              21 : Select(WhereX, WhereY, WhereX, 19, 7);
              19 : Select(WhereX, WhereY, WhereX, 18, 7); { Cat "D" }
              18 : Select(WhereX, WhereY, WhereX, 17, 7);
              17 : Select(WhereX, WhereY, WhereX, 15, 7);
              15 : Select(WhereX, WhereY, WhereX, 14, 7); { Cat "C" }
              14 : Select(WhereX, WhereY, WhereX, 13, 7);
              13 : Select(WhereX, WhereY, WhereX, 11, 7);
              11 : Select(WhereX, WhereY, WhereX, 10, 7); { Cat "B" }
              10 : Select(WhereX, WhereY, WhereX,  9, 7);
               9 : Select(WhereX, WhereY, WhereX,  7, 7);
               7 : Select(WhereX, WhereY, WhereX,  6, 7); { Cat "A" }
               6 : Select(WhereX, WhereY, WhereX,  5, 7);
               5 : Select(WhereX, WhereY, WhereX, 23, 7);
              else
                ShowError;
            end;
{ flecha arriba }
          #80 :
            CASe WhereY of
              5  : Select(WhereX,  5, WhereX,  6, 7); { Cat "A" }
              6  : Select(WhereX,  6, WhereX,  7, 7);
              7  : Select(WhereX,  7, WhereX,  9, 7);
              9  : Select(WhereX,  9, WhereX, 10, 7); { Cat "B" }
              10 : Select(WhereX, 10, WhereX, 11, 7);
              11 : Select(WhereX, 11, WhereX, 13, 7);
              13 : Select(WhereX, 13, WhereX, 14, 7); { Cat "C" }
              14 : Select(WhereX, 14, WhereX, 15, 7);
              15 : Select(WhereX, 15, WhereX, 17, 7);
              17 : Select(WhereX, 17, WhereX, 18, 7); { Cat "D" }
              18 : Select(WhereX, 18, WhereX, 19, 7);
              19 : Select(WhereX, 19, WhereX, 21, 7);
              21 : Select(WhereX, 21, WhereX, 22, 7); { Cat "E"}
              22 : Select(WhereX, 22, WhereX, 23, 7);
              23 : Select(WhereX, 23, WhereX,  5, 7);
              else
                ShowError;
            end; { #80 (abajo) }
{ flecha izquierda }
          #75 :
            CASe WhereX of
              14 : Select(WhereX, WhereY, 69, WhereY, 7); { Lunes }
              25 : Select(WhereX, WhereY, 14, WhereY, 7); { Martes }
              36 : Select(WhereX, WhereY, 25, WhereY, 7); { Mi‚rcoles }
              47 : Select(WhereX, WhereY, 36, WhereY, 7); { Jueves }
              58 : Select(WhereX, WhereY, 47, WhereY, 7); { Viernes }
              69 : Select(WhereX, WhereY, 58, WhereY, 7); { S bado }
              else
                ShowError;
            end; { #75 (izquierda) }
{ flecha derecha }
          #77 :
            CASe WhereX of
              14 : Select(WhereX, WhereY, 25, WhereY, 7); { Lunes }
              25 : Select(WhereX, WhereY, 36, WhereY, 7); { Martes }
              36 : Select(WhereX, WhereY, 47, WhereY, 7); { Mi‚rcoles }
              47 : Select(WhereX, WhereY, 58, WhereY, 7); { Jueves }
              58 : Select(WhereX, WhereY, 69, WhereY, 7); { Viernes }
              69 : Select(WhereX, WhereY, 14, WhereY, 7); { S bado }
              else
                ShowError;
            end; { #77 (derecha) }
          else
            ErrorBip(TeclaMala);
        end; { Case ReadKey / #00 (Teclas Especiales) }

      else
        ErrorBip(TeclaMala);
    end; { Case Tec (principal) }

  Until (Tec = #13) or (Tec = #27);

  If (Tec = #27)      { si apret¢ escape, }
    then
      Matrix := nil  { no devuelve nada }
    else
      Matrix := MatAuxil;

  DoneVideo;

  Pantalla^ := P; { restaura la pantalla }
end;




Function Cadena2Str(Cad : CadenaH) : String;
var
   Scr1 : Screen;
   Aux  : String;
   X    : Byte;
begin
  Scr1 := Pantalla^;
  Colorea(FondoNormal, FondoNormal);
  Mat2Scr;
  Colorea(TextoNormal, FondoNormal);
  CASe Cad.D of
    1 : Aux := 'Lunes ';
    2 : Aux := 'Martes ';
    3 : Aux := 'Mi‚rcoles ';
    4 : Aux := 'Jueves ';
    5 : Aux := 'Viernes ';
    6 : Aux := 'S bado ';
    else
      begin
	Cadena2Str := '';
	Pantalla^ := Scr1;
	Exit;
      end;
  end;
  For X := Cad.C to Cad.C + 7 do
    begin
      Aux := Aux + Char(Pantalla^[Cad.F, X].Caracter);
    end;
  Cadena2Str := Aux;
  Pantalla^ := Scr1;
end;


Function Categoria2Str(Cat : Char) : String;
begin
  Case Cat of
    'A' : Categoria2Str := 'De 3 a 5 a¤os';
    'B' : Categoria2Str := 'De 6 a 12 a¤os';
    'C' : Categoria2Str := 'Adultos';
    'D' : Categoria2Str := 'Equipo';
    'E' : Categoria2Str := 'Otros';
    'F' : Categoria2Str := 'Pileta Libre';
    else
      ShowError;
  end;

end;



{ ---=== LISTADO ===--- }


Procedure DesListaHora(var Primero, Ultimo : PElem);
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
end; { --- DeshacerLista --- }



Function ArmListaHora(var F : SocioFile; var Primero, Ultimo : PElem; CadH : CadenaH): Byte;
{   Primero chequea si hay elementos en la lista; si los hay los libera }
{ Luego, si el archivo est  vac¡o, asigna NIL a los punteros; de lo     }
{ contrario, arma la lista leyendo todo el archivo o hasta quedarse con }
{ menos de 64Kb de memoria convencional, que se reservan para poder     }
{ realizar otras operaciones. Puede devolver los siguientes valores :   }
var                                               {  0 : Todo Ok!       }
  Auxiliar : PElem;                               {  1 : Lista vac¡a.   }
  H : Byte;                                       {  2 : No hay memoria.}
  EmbocaHorario : Boolean;
begin
  ArmListaHora := 0; { por ahora, todo Ok! }
  If (Primero <> nil)
    then                                { Si hay elementos en lista }
      DesListaHora(Primero, Ultimo);   { los libera }
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
        ArmListaHora := 1; { Lista vac¡a }
      end
    else       { si HAY socios en el archivo }
      begin
        New(Primero);               { crea el primero }
        Repeat                      { lee el dato del primer socio }
          Read(F, Primero^.Soc);
          EmbocaHorario := False;
          For H := 1 to 3 do       { Chequea que coincida el horario }
           If (Primero^.Soc.Horario[H].D = CadH.D) and
              (Primero^.Soc.Horario[H].F = CadH.F) and
              (Primero^.Soc.Horario[H].C = CadH.C)
             then EmbocaHorario := True;
        Until (EmbocaHorario
              and (not Primero^.Soc.Borrado)) { si no est  borrado }
              or Eof(F);        { o lleg¢ al final del archivo }

        If EmbocaHorario and (not Primero^.Soc.Borrado)
          then         { si no tiene el atributo de 'Borrado' }
            begin
              Primero^.Sig := nil;        { el siguiente es nil }
              Primero^.Ant := nil;        { en el anterior no hay nada }
              Ultimo       := Primero;    { el £ltimo es el primero porque es }
                                          { el £nico hasta ahora }
            end
          else
            begin
              ArmListaHora := 1; { Lista vac¡a }
              Dispose(Primero);
              Primero := nil;  { el primero es nulo }
              Ultimo  := nil;  { y el £ltimo tambi‚n }
            end;

        While not EoF(F) and { Hasta llegar al final del archivo... }
              (MaxAvail > 16*1024) do { o hasta agotar la memoria. }
          begin
            New(Auxiliar);           { se crea uno nuevo }
            Repeat
              Read(F, Auxiliar^.Soc);              { lee el dato del socio }
              EmbocaHorario := False;
              For H := 1 to 3 do   { Chequea que coincida el horario }
                If (Auxiliar^.Soc.Horario[H].D = CadH.D) and
                   (Auxiliar^.Soc.Horario[H].F = CadH.F) and
                   (Auxiliar^.Soc.Horario[H].C = CadH.C)
                  then EmbocaHorario := True;
            Until (EmbocaHorario
              and (not Auxiliar^.Soc.Borrado)) { si no est  borrado }
              or Eof(F);        { o lleg¢ al final del archivo }

            If EmbocaHorario and (not Auxiliar^.Soc.Borrado)
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
      ArmListaHora := 3; { No alcanz¢ la memoria }
end; { --- ArmarLista --- }





Function ListaPorHorarios(PCH : PCadenaH): Byte;
var F : SocioFile;
    Prime, Ultim : PElem;

begin
  Prime := nil;
  Ultim := nil;
  Presenta;
{  CentText(3, '>> Consulta de Socios por Horarios <<'); }
  If (PCH <> nil)
    then
      begin
        CentText(5, 'Buscando...');
        Vueltas(5,30);
      end;
  If (PCH <> nil) and (Encuentra('SOCIOS.SCA'))
    then
      begin
        Assign(F, 'SOCIOS.SCA');
        Reset(F);
        Case ArmListaHora(F, Prime, Ultim, PCH^) of
          0 : { todo Ok! }
            begin
              CentText(5, Espacios(12));
              CentText(5, 'Leyendo...');
              Vueltas(5, 30);
              CentText(5, Espacios(10));
              Close(F);
              Listar(True, Prime, Ultim);
            end;
          1 : { Lista vac¡a }
            begin
              Close(F);
              ErrorBip(ErrorDeUsuario);
              MostrarMensaje(' ­ E R R O R   F A T A L ! ',
                             'No hay socios que concurran al horario especificado'+#13+
                             'por el usuario!. Para agregar un registro, use el'+#13+
                             'Listado de Escuela de Nataci¢n');
            end;
          2 : { No alcanz¢ la memoria }
            begin
              Close(F);
              ErrorBip(NoHayMemoria);
              MostrarMensaje(' ­ERROR DE ASIGNACION DE MEMORIA! ',
                             'No alcanza la RAM convencional para crear la lista'+#13+
                             'Trate de liberar memoria convencional para el'+#13+
                             'programa o llame al Servicio de Soporte SyCASe!');
            end;
          else
            If (PCH <> nil)
              then
                MostrarMensaje('­ E R R O R   F A T A L !',
                               'No se encuentra el archivo SOCIOS.SCA');
        end; { case }
      end; { begin }

  DesListaHora(Prime, Ultim);
end;




BEGIN
END.