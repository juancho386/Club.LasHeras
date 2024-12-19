Unit ClubMain;
{ SyCASe! Club Main }
{ Esta es la unidad principal del Programa Administrativo de la Escuela }
{ de Nataci¢n del Club Las Heras                                        }

INTERFACE

Uses
  DOS,
  SCATypes, ClubList, SCAVers, CASeUnit;

{ Arma la pantalla principal b sica }
Procedure Presenta;

{ Muestra informaci¢ sobre el programa y los autores (We!) }
Procedure AcercaDe;

{ Muestra un lindo mensaje al usuario (con chivo incluido) }
Procedure ShowError;

{ Sale advirtiendo al usuario que est  usando una versi¢n NO REGISTRADA! }
Procedure Salida;




IMPLEMENTATION

Uses Crt, Drivers,
     Mensajes, Selector, Interfaz, SCConfig;



{ Presentaci¢n de la pantalla b sica }
Procedure Presenta;
var
  A : Byte;
begin
  InitVideo;

  Colorea(TextoNormal, FondoNormal);
  ClrScr;
  Write('Ú');           { esquina superior izquierda }
  For A := 2 to 78 do
    Write('Ä');         { borde superior }
  Write('·');           { esquina superior derecha }
  TextXY(1, 25, 'Ô');   { esquina inferior izquierda }
  For A := 2 to 78 do
    Write('Í');         { borde inferior }
  Write('¼');           { esquina inferior derecha }
  For A := 2 to 24 do
    TextXY(1, A, '³');  { borde izquierdo }
  For A := 2 to 24 do
    TextXY(79, A, 'º'); { borde derecho }

  TextXY(1, 3, 'Ã');    { barra de t¡tulo }
  For A := 2 to 78 do
    Write('Ä');
  Write('¶');
  TextColor(TextoSelec);
  CentText(2, 'Programa Administrativo de la Escuela ' +
	      'de Nataci¢n del Club Las Heras');  { T¡tulo }

  TextColor(TextoNormal);
  TextXY (42, 23, 'Ú');
  For A := 43 to 78 do
    Write('Ä');
  TextXY(42, 24, '³');
  Write('    by SyWARE! & CASe Associated.');
  TextXY (42,25,'Ï');
  TextXY (79,23,'¶');
end;



{ Muestra informaci¢n Acerca del Programa }
Procedure AcercaDe;
const Texto : String = 'by SyWARE! & CASe Associated.';
var
  X : Byte;
  H,M,S,C:word;

begin
  Presenta;
  CentTexT( 5,'Versi¢n '+VersionStr+' NO Registrada');
  CentText( 8,'Dise¤o, Codificaci¢n, Verificaci¢n,');
  CentText( 9,'Pruebas y Depurado:');
  CentText(11,'Casta¤o, Juan Eduardo - (CASe)');
  CentText(13, 'Medrano, Sim¢n - (Dr.Sy!)');
  TextXY(14, 18, 'Agradecimientos');
  TextXY(14, 19, 'ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ');
  TextXY(15, 20, 'A nadie, porque lo hicimos nosotros dos SOLOS!!!!:');
  TextXY(6,4 ,    '____');    TextXY(67,4  ,    '.    _  .');
  TextXY(5,5 ,   '/# /_\_');  TextXY(67,5  ,    '|\_|/__/|');
  TextXY(4,6 ,  '|  |/o\o\'); TextXY(66,6  ,   '/ / \/ \  \');
  TextXY(4,7 ,  '|  \\_/_/'); TextXY(65,7  ,  '/__|O||O|__ \');
  TextXY(3,8 , '/ |_   |');   TextXY(64,8  , '|/_ \_/\_/ _\ |');
  TextXY(2,9 ,'|  ||\_ -|');  TextXY(64,9  , '| | (____) | ||');
  TextXY(2,10,'|  ||| \/');   TextXY(64,10 , '\/\___/\__/  //');
  TextXY(2,11,'|  |||_');     TextXY(64,11 , '(_/         ||');
  TextXY(3,12, '\//  |');     TextXY(65,12 ,  '|          ||');
  TextXY(4,13,  '||  |');     TextXY(65,13 ,  '|          ||\');
  TextXY(4,14,  '||_  \');    TextXY(66,14 ,   '\        //_/');
  TextXY(4,15,  '\_|  o|');   TextXY(67,15 ,    '\______//');
  TextXY(4,16,  '/\___/');    TextXY(65,16 ,  '__ ||   ||');
  TextXY(3,17, '/  ||||__');  TextXY(64,17 , '(____(____)');
  TextXY(6,18,'(___)_)');     TextXY(63,18 ,'/~~~~~~~~~~~\');
  X := 1;
  TextXY(68,21,'ÚÄÄÄÄÄÄÄÄÄÄ¶');
  TextXY(68,22,'³Hora');
  TextXY(68,23,'Á');
  Repeat
    If X > Length(Texto)
      then
        begin
          For X := 1 to Length(Texto) do
            begin
              GetTime(H,M,S,C);
              TextXY(74,22,IntAStr(H)+':'+IntAStr(M));
              Pantalla^[24, X+46].caracter := 32;
              Delay(10);
            end;
          X := 1;
        end;
    Pantalla^[24, X+46].caracter := Ord(Texto[X]);
    Pantalla^[24, X+46].atributos := Pantalla^[24, X+1].atributos xor Random(16);
    Delay(10);
    X := X + 1;
  Until KeyPressed;

  While KeyPressed do ReadKey;
end; { --- AcercaDe --- }



{ Muestra un agradable mensaje para tranqilizar al usuario... }
Procedure ShowError;
begin
  ClrScr;
  Randomize;
  CentText (2, 'Programa Administrativo de la Escuela ' +
               'de Nataci¢n del Club Las Heras');
  CentText (3, 'Versi¢n '+VersionStr+' NO Registrada');
  Delay(500);
  CentText (5, 'by SyCASe!');
  CentText (6, '(SyWARE! & CASe Associated)');
  CentText (8,'ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»');
  CentText (9,'º ERROR FATAL INESPERADO DE EJECUCION N§ '+
              IntAStr(Random(500)+100)+'        º');
  CentText(10,'º producido por el usuario o mal funcionamiento del º');
  CentText(11,'º hardware.  Por favor,  describa  en papel  lo que º');
  CentText(12,'º ocurri¢ y cont ctese  urgente con los autores del º');
  CentText(13,'º programa para contratar servicio t‚cnico especia- º');
  CentText(14,'º lizado y solucionar el problema lo antes posible. º');
  CentText(15,'º    Casta¤o, ''Lord CASe'' Juan Eduardo - 764-2647   º');
  CentText(16,'º    Medrano, Sim¢n ''Dr.Sy!''           - 842-5979   º');
  CentText(17,'ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼');
  Delay(10000);
  Halt(255);
end;





Procedure Salida;
VAR
  Primera,
  segunda: SocioFile;
  Reg: TSocio;


Begin
  Assign (primera,'socios.sca');
  Assign (segunda,'$SyCASe$.SCA');
  reset (primera);
  rewrite (Segunda);             { ac  empieza el borrado de los borrados }
  While not EOF(primera) do begin
    read (primera,reg);
    if not reg.borrado then write (segunda,reg);
  end;                           { ac  termina el borrado de los borrados }
(*  Seek (segunda,0);              { y empieza el acomodado por orden alfab‚tico }
  Seek (Primera,0);
  read (Segunda,maschico);
  While not EOF(Segunda) do begin { buscamos el mas chico }
    read (Segunda,reg);
    if maschico.apellido > reg.apellido then maschico := reg;
    if maschico.apellido = reg.apellido then
      if maschico.nombre > reg.nombre then maschico := reg;
  end;
  Write (Primera,maschico);    { y lo escribimos }
                                { Hasta ac  'ta todo cool }
  seek (Segunda,0);
  While filepos(primera) < Filesize (Segunda) do begin
    seek (Segunda,0);
    repeat
      read (Segunda,actual);
      if ( reg.apellido > maschico.apellido ) and
         ( reg.apellido < actual.apellido ) then begin
           actual:=reg;
      end;
    until EOF(Segunda);
    write (Primera,actual);
    maschico:=actual;
  end;             *)
  Close (Primera);
  Close (Segunda);
  erase (primera);                { futuro segunda  }
  rename (segunda,'socios.sca');  { futuro disabled }


  Randomize;
  If (Random(2) = 0)
    then
      MostrarMensaje(' NO SE PIERDA ESTA GRAN OPORTUNIDAD ',
                     '­Sea un usuario registrado de SyCASe!'+#13+
                     'Recibir  grandes beneficios adicionales como servicio'+#13+
                     't‚cnico especializado y muchas opciones interesantes.')
    else
      MostrarMensaje(' ¨ Y ? ',
                     '¨­Todav¡a NO est  Registrado!?'+#13+
                     '¨Qu‚ espera para hacerlo y obtener los grandes'+#13+
                     'beneficios que SyCASe! brinda a sus usuarios?');

  Colorea(LightGray, Black);
  DoneVideo;
  ClrScr;
  CentText(2, 'Programa Administrativo de la Escuela ' +
              'de Nataci¢n del Club Las Heras');
  CentText(3, 'Versi¢n '+VersionStr+' NO Registrada');
  Delay(500);
  CentText(5, 'by SyCASe!');
  CentText(6, '(SyWARE! & CASe Associated)');
  CentText(8, 'Sim¢n Medrano - ''Dr.Sy!'' - 842-5979');
  CentText(9, 'Juan Eduardo Casta¤o - ''CASe'' - 764-2647');
  WriteLn;
  WriteLn;

  If (Random(2) = 0)
    then
      begin
        Write('C:\>'); ReadLn;
        WriteLn('Comando o nombre de archivo NO REGISTRADO!');
        Delay(5000);
      end;


end;



BEGIN
END.
