Unit Interfaz;
{ INTERFAZ.PAS }

INTERFACE

Uses Dos;


{ Devuelve TRUE si existe el archivo, o FALSE si no se encuentra }
Function ExisteArchivo(Archivo: String; Atributos: Word) : Boolean;

{ Constantes de Atributos de Archivo usadas por ExisteArchivo, son las }
{ mismas de la unidad DOS de Borland Pascal 7.0                        }


{ Copia un archivo desde Desde hasta Hasta }
Function CopiaArchivo(Desde, Hasta : PathStr) : Byte;



{ Meses del A¤o }
Const MesesStr : Array[0..13] of String[10] = ('Ninguno',
                                               'Enero', 'Febrero',
                                               'Marzo', 'Abril',
{ Estas constantes se usan como funci¢n }      'Mayo', 'Junio',
{ para obtener el nombre del mes a partir }    'Julio', 'Agosto',
{ del n£mero }                                 'Septiembre', 'Octubre',
                                               'Noviembre', 'Diciembre',
{ El mes de Enero lo puse al final otra vez  } 'Enero');
{ para evitar errores al ejecutar una operaci¢n como la siguiente:  }
{   Write(MesesStr[Mes + 1]);                                       }
{ Donde Mes puede tener el valor 12, y si esto ocurre producir¡a un }
{ error que no afectar¡a a la ejecuci¢n pero no quedar¡a muy lindo. }
{ El resto de los problemas debe chequearlos el programador.        }

{ D¡as de la Semana (Abreviados) }
Const DiaSemAv : Array[0..8] of String[3] = ('---',
                                             'Dom', 'Lun', 'Mar', 'Mi‚',
{ Lo mismo que con los meses }               'Jue', 'Vie', 'Sab', 'Dom');

{ Hace sonar un mensaje de error seg£n el c¢digo (ver constantes) }
Procedure ErrorBip(Codigo: Byte);

const { Constantes de ErrorBip }
      Beep           = 0;
      TeclaMala      = 1;
      FaltaArchivo   = 2;
      NoHayMemoria   = 3;
      ErrorDeUsuario = 4;
   { otro valor hace un beep est ndard de caracter #007 (agente secreto) }

{ Devuelve True si el usuario responde de forma afirmativa a la Pregunta }
{ formulada.                                                             }
Function RespondeSi(Pregunta : String) : Boolean;
{ Acepta las teclas 'S', 's' y 'Enter' como respuesta afirmativa; y las }
{ teclas 'N', 'n' y 'Esc' como respuesta negativa.                      }

{ Cumple la misma funci¢n que el Delay de la unidad Crt, pero es m s lindo }
{ porque se ve una barrita dando vueltas.                                  }
Procedure DelayBar(Vueltas, Tiempo : LongInt);
 { Tiempo es lo que dura cada vuelta, y Vueltas es la cantidad de vueltas }
 { que tiene que dar la barrita.                                          }

{ Igual que la anterior pero con un pulsar de estrella...­y sonido! }
Procedure DelayStar(Pulsos, Tiempo : LongInt);
{ Pulsos es la cantidad de ciclos de la animaci¢n }
{ Tiempo, lo que dura cada ciclo                  }



type { el texto m s largo que puede centrar TextoCentrado }
  String80 = String[80];

{ Muestra una cadena de texto centrada en la l¡nea especificada }
Function TextoCentrado(Const Texto : String80; Linea : Byte): Byte;
 { puede devolver los siguientes valores :                        }
 { 0 = fue necesario truncar la cadena para que entre en pantalla }
 { otro valor es la columna en la que qued¢ centrado el texto     }

{ Devuelve un String de espacios de la longitud especificada }
Function Espacios(Cant : Byte) : String;




IMPLEMENTATION

Uses Crt, Drivers;


Function ExisteArchivo(Archivo: String; Atributos: Word) : Boolean;
var R : SearchRec;
begin
     FindFirst(Archivo, Atributos, R);
     If (DosError <> 0) or (R.Name <> Archivo)  { si se produce un error }
           then                    { o no coincide el nombre del archivo }
             ExisteArchivo := False       { significa que no se encontr¢ }
           else
             ExisteArchivo := True;
end; { ---  ExisteArchivo  --- }



Function CopiaArchivo(Desde, Hasta : PathStr) : Byte;
var
  Orig, Dest : File of Byte;
  Bait : Byte;
  Code : Byte;
{
 2  ³ File not found
 3  ³ Path not found
 5  ³ Access denied
 6  ³ Invalid handle
 8  ³ Not enough memory
10  ³ Invalid environment
11  ³ Invalid format
18  ³ No more files
}
begin
  If not ExisteArchivo(Desde, Archive)
    then
      begin
        CopiaArchivo := 2;
        Exit;
      end
    else
      begin
        Assign(Orig, Desde);
        Assign(Dest, Hasta);
        Reset(Orig);
{$I-}
        Rewrite(Dest);
{$I+}
        Code := IOResult;
        If (Code <> 0)
          then
            begin
              CopiaArchivo := Code;
              Close(Orig);
              Exit;
            end;
        While not EoF(Orig) do
          begin
{$I-}
            Read(Orig, Bait);
            Write(Dest, Bait);
{$I+}
            Code := IOResult;
            If (Code <> 0)
              then
                begin
                  CopiaArchivo := Code;
                  Close(Orig);
                  Close(Dest);
                  Exit;
                end;
          end;
        Close(Orig);
        Close(Dest);
        CopiaArchivo := 0;
      end;
end;



Procedure ErrorBip(Codigo: Byte);
var                                     { Constantes de ErrorBip  }
   i, j : Integer;                      {   Beep           = 0;   }
begin                                   {   TeclaMala      = 1;   }
     Case Codigo of                     {   FaltaArchivo   = 2;   }
{ 0 }                                   {   NoHayMemoria   = 3;   }
       Beep :                           {   ErrorDeUsuario = 4;   }
         begin                          { otro valor hace un beep }
           Sound(500);                  { est ndard de caracter   }
           Delay(250);                  { #007 (agente secreto)   }
           NoSound;
         end;
{ 1 }
       TeclaMala :
         begin
           Sound(200);
           Delay(100);
           NoSound;
         end;
{ 2 }
       FaltaArchivo :
         begin
           Sound(350);
           Delay(300);
           Sound(100);
           Delay(300);
           NoSound;
         end;
{ 3 }
       NoHayMemoria :
         begin
           Sound(150);
           Delay(200);
           Sound(100);
           Delay(200);
           Sound(50);
           Delay(500);
           NoSound;
         end;
{ 4 }
       ErrorDeUsuario :
         begin
           Sound(300);
           Delay(150);
           Sound(500);
           Delay(450);
           Sound(100);
           Delay(400);
           NoSound;
         end;
{ Otro valor }
          else Write(#7);
     end; { Case }
end;  { ---  ErrorBip  --- }



Function RespondeSi(Pregunta : String) : Boolean;
var Ev : TEvent;
    Contesta : Boolean;
begin
  Contesta := False;
  Write(Pregunta, ' (S/N): ');
  ErrorBip(Beep);
  Repeat
    GetKeyEvent(Ev);
    If (Ev.What = evKeyDown)
      then
        Case Ev.KeyCode of
{ Enter } 7181,
    { S } 8019,
    { s } 8051 :
            begin
              RespondeSi := True;
              Contesta := True;
            end;

  { Esc } 283,
    { N } 12622,
    { n } 12654 :
            begin
              RespondeSi := False;
              Contesta := True;
            end;

          else { cualquier otra tecla }
            ErrorBip(TeclaMala);

        end;
  Until Contesta;
end; { --- RespondeSi --- }




Procedure DelayBar(Vueltas, Tiempo : LongInt);
const
  Sprite : Array[0..3] of Char = 'Ä\|/';
var
  V : LongInt;
  N : Byte;
begin
  For V := 1 to Vueltas do
    For N := 0 to 3 do
      begin
      	Write(Sprite[N], #08); { escribe un sprite y vuelve para atr s }
        Delay(Tiempo div 4);  { espera un cuarto de vuelta }
      end;
  Write(#32#08); { borra el sprite que queda }
  If (Vueltas = 0) then Delay(Tiempo);
end; { --- DelayBar --- }



Procedure DelayStar(Pulsos, Tiempo : LongInt);
const
  Star : Array[0..6] of Char = 'úù*O'#9;
var
  S : LongInt;
  N : Byte;
begin
  For S := 1 to Pulsos do
    For N := 0 to 6 do
      begin
      	Write(Star[N], #08); { escribe un sprite y vuelve para atr s }
        Sound(50 div (N+1));
        Delay(Tiempo div 8);  { espera un cuarto de vuelta }
      end;
  NoSound;
  Write(#32#08); { borra el sprite que queda }
  If (Pulsos = 0) then Delay(Tiempo);
end; { --- DelayStar --- }



Function TextoCentrado(Const Texto : String80; Linea : Byte): Byte;
var Columna : Byte;
begin
  Columna := (80 - Length(Texto)) div 2;
  GotoXY(Columna, Linea);
  Write(Texto);
end; { --- TextoCentrado --- }




Function Espacios(Cant : Byte) : String;
var X : Byte;
    S : String;
begin
  S := '';
  If (Cant >= 1)
    then
      For X := 1 to Cant do
        S := S + #32;
  Espacios := S;
end; { --- Espacios --- }



END
{ INTERFAZ.PAS }
.