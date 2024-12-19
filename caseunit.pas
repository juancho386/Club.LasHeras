Unit CASeUnit;

INTERFACE

uses dos,CRT;

Procedure colorea(tex,bac:word); {Da atributos de color al texto}
Procedure Vueltas (vuelta,wait:longint); {gira caracteres como el toolkit}
procedure CentText(Y:byte;texto:string);{centra el texto sobre X}
procedure TextXY (a,b:byte;t:string);{como OutTextXY pero en modo texto}
procedure ReadXY(x, y : Byte; var Texto : String);
procedure Boton (c,d,e,f:byte;g:string;h:boolean);{crea botones en modo texto}
Function Encuentra(arch:PathStr):Boolean; {true si encuentra el archivo nombrado}
Function IntAStr(I: Longint): String;
Function StrAInt(const S : String; var I : LongInt): Boolean;
Function StrAByte(const S : String; var B : Byte): Boolean;


IMPLEMENTATION


Procedure Boton;
begin


end;


Procedure Colorea;
begin
  Textcolor(tex);
  TextBackGround(bac);
end;



Procedure vueltas;
const
	barra : array [1..4] of char = '/Ä\³';
Var
	a,b:longint;
Begin
	for a:=1to vuelta do
   	for b:=1 to 4 do begin
      	write(barra[b],#8);
         delay (wait);
      end;
      write(#32);
end;



Function Encuentra;
Var dirinf :SearchRec;
 Begin
 	DIRINF.NAME:='';
	FindFirst(arch, Archive, DirInf);
   If DirInf.name='' then Encuentra :=false else Encuentra:=true;
 end;



Procedure CentText;
 Begin
 	GotoXY(40-length(texto)div 2,y);
 	Write(texto);
 end;



Procedure TextXY;
 Begin
 	GotoXY (a,b);
   write (t);
 end;

Procedure ReadXY(x, y : Byte; var Texto : String);
begin
  GotoXY(X, Y);
  Read(Texto);
end;



Function IntAStr(I: Longint): String;
var
  S : String;
begin
  Str(I, S);
  IntAStr := S;
end; { --- IntAStr --- }


Function StrAInt(const S : String; var I : LongInt): Boolean;
var Code : Integer;
begin
  Val(S, I, Code);
  If Code <> 0
    then StrAInt := False
    else StrAInt := True;
end; { --- StrAInt --- }


Function StrAByte(const S : String; var B : Byte): Boolean;
var Code : Integer;
begin
  Val(S, B, Code);
  If Code <> 0
    then StrAByte := False
    else StrAByte := True;
end; { --- StrAInt --- }


BEGIN
END.