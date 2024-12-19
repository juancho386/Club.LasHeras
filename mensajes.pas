Unit Mensajes;


INTERFACE

Type
  DByte = Record
     C : Char;
     A : Byte;
  end;

  Pant = Array[1..25, 1..80] of DByte;


{ Muestra un mensaje en pantalla, usando memoria de v¡deo }
Procedure MostrarMensaje(Titulo, Texto : String);




IMPLEMENTATION

Uses Crt;

Var
  P : ^Pant;
  P2 : Pant;



Procedure MostrarMensaje(Titulo, Texto : String);
const
  Boton : String[11] = '> Aceptar <';
var
  X, Y : Byte; { coordenadas }
  M1, M2, M3 : String; { las tres l¡neas del mensaje }
begin
  P2 := P^;
  M1 := ''; M2 := ''; M3 := '';
  For X := 10 to 68 do        { Hace la ventana }
    For Y := 9 to 17 do
      begin
        P^[Y, X].A := 15;
        P^[Y, X].C := #32;
        If (X = 10) or (X = 68)
          then
            begin
              P^[Y, X].C := 'º';
              P^[Y, X].A := 15;
            end;
        If (X = 11) or (X = 67)
          then
            begin
              P^[Y, X].A := 15;
            end;
        If (Y = 9) or (Y = 17)
          then
            begin
              P^[Y, X].C := 'Í';
              P^[Y, X].A := 15;
            end;
      end;
  P^[9, 10].C := 'É';
  P^[17, 10].C := 'È';
  P^[9, 68].C := '»';
  P^[17, 68].C := '¼';

  For X := 12 to 70 do        { hace las sombras }
    For Y := 10 to 18 do
      If (Y = 18) or (X > 68)
        then P^[Y, X].A := 8;

  If (Byte(Titulo[0]) > 53)         { pone el t¡tulo }
    then Titulo[0] := Char(53);
  X := (80 - Byte(Titulo[0]))div 2;
  For Y := 1 to Byte(Titulo[0]) do
    begin
      P^[9, X+Y-1].C := Titulo[Y];
      P^[9, X+Y-1].A := 15;
    end;
  P^[9, X-1].C := '>';
  P^[9, X+Y].C := '<';

  For X := 1 to Byte(Texto[0]) do
    If (Texto[X] <> #13)
      then
        M1 := M1 + Texto[X]
      else
        X := Byte(Texto[0]);

  For X := Byte(M1[0])+2 to Byte(Texto[0]) do
    If (Texto[X] <> #13)
      then
        M2 := M2 + Texto[X]
      else
        X := Byte(Texto[0]);

  For X := Byte(M2[0])+Byte(M1[0])+3 to Byte(Texto[0]) do
    If (Texto[X] <> #13)
      then
        M3 := M3 + Texto[X]
      else
        X := Byte(Texto[0]);


  If (Byte(M1[0]) > 53)            { Mensaje 1 }
    then M1[0] := Char(53);
  X := (80 - Byte(M1[0]))div 2;
  For Y := 1 to Byte(M1[0]) do
    begin
      P^[11, X+Y-1].C := M1[Y];
      P^[11, X+Y-1].A := 15;
    end;

  If (Byte(M2[0]) > 53)            { Mensaje 2 }
    then M2[0] := Char(53);
  X := (80 - Byte(M2[0]))div 2;
  For Y := 1 to Byte(M2[0]) do
    begin
      P^[12, X+Y-1].C := M2[Y];
      P^[12, X+Y-1].A := 15;
    end;

  If (Byte(M3[0]) > 53)            { Mensaje 3 }
    then M3[0] := Char(53);
  X := (80 - Byte(M3[0]))div 2;
  For Y := 1 to Byte(M3[0]) do
    begin
      P^[13, X+Y-1].C := M3[Y];
      P^[13, X+Y-1].A := 15;
    end;

  X := (80 - Byte(Boton[0]))div 2; { Bot¢n Aceptar }
  For Y := 1 to Byte(Boton[0]) do
    begin
      P^[15, X+Y-1].C := Boton[Y];
      P^[15, X+Y-1].A := 15;
    end;

  Repeat
  Until ReadKey = #13;
  P^ := P2;
end;




BEGIN
  P := Ptr($B800, $0000);
END.