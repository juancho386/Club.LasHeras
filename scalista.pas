Unit SCALista;

INTERFACE

Uses SCATypes, Interfaz;


{ ­­­CUIDADO!!! antes de llamar por primera vez a estas dos funciones, el }
{ programa principal deber¡a inicializar los punteros de la lista; de lo  }
{ contrario puede llegar a perder informaci¢n o hasta colgar la m quina.  }

Procedure DeshacerLista(var Primero, Ultimo : PElem);

Function ArmarLista(var F : SocioFile; var Primero, Ultimo : PElem): Byte;




IMPLEMENTATION


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
end; { --- DeshacerLista --- }




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
        DelayBar(5, 100);   { hacemos creer que el programa trabaja mucho }
        ArmarLista := 1; { Lista vac¡a }
      end
    else       { si HAY socios en el archivo }
      begin
        New(Primero);               { crea el primero }
        Repeat                      { lee el dato del primer socio }
          Read(F, Primero^.Soc);
        Until (Primero^.Soc.Borrado = False)  { si no est  borrado }
                  or Eof(F);        { o lleg¢ al final del archivo }
        If (Primero^.Soc.Borrado = False)
          then         { si no tiene el atributo de 'Borrado' }
            begin
              Primero^.Sig := nil;        { el siguiente es nil }
              Primero^.Ant := nil;        { en el anterior no hay nada }
              Ultimo       := Primero;    { el £ltimo es el primero porque es }
                                          { el £nico hasta ahora }
            end
          else
            begin
              ArmarLista := 1; { Lista vac¡a }
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
            Until (Auxiliar^.Soc.Borrado = False)  { si no est  borrado }
                  or Eof(F);             { o lleg¢ al final del archivo }
            If (Auxiliar^.Soc.Borrado = False)
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
      ArmarLista := 3; { No alcanz¢ la memoria }
end; { --- ArmarLista --- }







BEGIN
END.