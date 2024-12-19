UNIT Selector;

INTERFACE

uses crt;

Type
    Charters = Record
      caracter,
      atributos : Byte;
    end;

    PScreen = ^Screen;
    Screen = Array[1..25, 1..80] of Charters;

Var
{  pet, i   : integer; }
  PantDefault : screen absolute $B800:0000; { Pantalla real }

  Pantalla : PScreen;


Procedure SetuPantalla(Segm, Offs : Word);


Procedure select (Xcor1,Ycor1,XCor2,YCor2,long:byte);


Procedure Select2(Xa1, Xb1, Y1, Xa2, Xb2, Y2 : Byte);


Procedure sonido (dur,del:integer);



IMPLEMENTATION

Uses SCConfig, CASeUnit;



Procedure SetuPantalla(Segm, Offs : Word);
begin
  Pantalla := Ptr(Segm, Offs);
end;


Procedure Select;
var i    : Byte;
    pant : screen;
begin
     Pant := Pantalla^;
     GotoXY(Xcor1, YCor1);
     textbackground(FondoNormal);
     textcolor(TextoNormal);
     For i := 0 to long do
       Write(Char(Pant[YCor1,XCor1+i].Caracter));
     GotoXY(XCor2,YCor2);
     TextBackGround(FondoSelec);
     textcolor(TextoSelec);
     For i:= 0 to long do
         Write(Char(Pant[YCor2,XCor2+i].Caracter));
     GotoXY(Xcor2, YCor2);
end;



Procedure Select2(Xa1, Xb1, Y1, Xa2, Xb2, Y2 : Byte);
begin
  TextXY(Xa1, Y1, #32);
  TextXY(Xb1, Y1, #32);
  Colorea(TextoSelec, FondoNormal);
  TextXY(Xa2, Y2, #16);
  TextXY(Xb2, Y2, #17);
  Colorea(TextoNormal, FondoNormal);
end; { --- Select 2 --- }


Procedure sonido;
 begin
      sound (dur);
      delay (del);
      nosound;
 end;
end.