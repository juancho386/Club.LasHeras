Unit ClubList;{ SyCASe! Club-List Unit }
{ CLUBLIST.PAS }
{ Unidad de Lista de Socios de la Escuela de Nataci¢n del Club Las Heras }

INTERFACE

Uses SCATypes;

{ ---=== Funciones y Procedimientos P£blicos de esta Unidad ===--- }

{ Funci¢n para mostrar en pantalla una lista ya armada }
Procedure Listar(Socios : Boolean; var Prim, Ulti : PElem);


{ Funci¢n principal para el manejo de la lista }
Function ListaPrincipal(Socios : Boolean): Byte;
{ Si Socios es True, mostrar  la lista de Socios }
{ Si Socios es False, mostrar  la lista de los que concurren a pileta libre }


IMPLEMENTATION

Uses Dos, Crt, Printer, Drivers,
     ClubMain, SCMatrix, SCALista, CampoSCA, Interfaz, CASeUnit, Selector, SCConfig, Mensajes;


Function SociosIguales(const Socio1, Socio2 : TSocio) : Boolean;
begin  { Compara si dos socios son iguales }
  SociosIguales :=
      (Socio1.Nombre       = Socio2.Nombre)       and
      (Socio1.Apellido     = Socio2.Apellido)     and
      (Socio1.Edad         = Socio2.Edad)         and
      (Socio1.Direccion    = Socio2.Direccion)    and
      (Socio1.Telefono     = Socio2.Telefono)     and
      (Socio1.FechaIng     = Socio2.FechaIng)     and
      (Socio1.MesPagado    = Socio2.MesPagado)    and
      (Socio1.Categoria    = Socio2.Categoria)    and
      (Socio1.Horario[1].D = Socio2.Horario[1].D) and
      (Socio1.Horario[1].F = Socio2.Horario[1].F) and
      (Socio1.Horario[1].C = Socio2.Horario[1].C) and
      (Socio1.Horario[2].D = Socio2.Horario[2].D) and
      (Socio1.Horario[2].F = Socio2.Horario[2].F) and
      (Socio1.Horario[2].C = Socio2.Horario[2].C) and
      (Socio1.Horario[3].D = Socio2.Horario[3].D) and
      (Socio1.Horario[3].F = Socio2.Horario[3].F) and
      (Socio1.Horario[3].C = Socio2.Horario[3].C) and
      (Socio1.Borrado      = Socio2.Borrado);
end; { --- SociosIguales --- }




Function AgregaSoc(Socios : Boolean; var Prim, Ulti : PElem) : Boolean;
var
  Reg : TSocio;
  Anio, Mes, Dia, DiaSem : Word;
  F1  : SocioFile;
  Tec : char;
  Anos : string[3];
  Archivo : NameStr;
  Hor : PCadenaH;
  Scr : Screen;
begin
  Scr := Pantalla^;
  DoneVideo;
  Presenta;
  With Reg do
    begin
      Borrado := False;
      CentText(3, '>>Ficha de ingreso de socios a la escuela de nataci¢n<<');
      TextXY(10, 5, ' Apellido :');
      TextXY(10, 6, '   Nombre :');
      TextXY(10, 7, '     Edad :');
      TextXY(10, 8, 'Direcci¢n :');
      TextXY(10, 9, ' Tel‚fono :');

      GotoXY(22, 5); ReadLn(Apellido);
      GotoXY(22, 6); ReadLn(Nombre);
      Repeat
        GotoXY(22, 7);
        ReadLn(Anos);
      Until StrAByte(Anos, Edad);
      GotoXY(22, 8); ReadLn(Direccion);
      GotoXY(22, 9); ReadLn(Telefono);

     { levanta la fecha del sistema }
      Getdate(Anio, Mes, Dia, DiaSem);
      FechaIng :=  IntAStr(Dia) + '/'
                 + IntAStr(Mes) + '/'
                 + IntAStr(Anio);
      TextXY(10, 10, 'Fecha de Ingreso: ' + FechaIng);

      TextXY (13, 11, 'El sistema deduce que el socio ' + Apellido + ',');
      TextXY (13, 12, Nombre + ' NO ha pagado el corriente mes.');
      MesPagado := 0;

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
            Colorea(TextoNormal, FondoNormal);
            TextXY(10, 14, '                                         ');
            TextXY(35, 15, '                ');
            TextXY(35, 16, '                ');
            TextXY(35, 17, '                ');
            TextXY(35, 18, '                ');
          end
        else
          begin
            Assign(F1, 'PLIBRE.SCA');
            Categoria := 'F';
          end;

      TextXY(10, 14, 'Categor¡a : "' +
                     Reg.Categoria + '" : '+
                     Categoria2Str(Reg.Categoria));

      If Socios { S¢lo se asigna el horario a los que concurren a Clases }
        then    { de nataci¢n.                                           }
          begin
            Vueltas(3, 30);
            TextXY(28, 16, 'Horarios :');
            Vueltas(10,30);

            Hor := Matrix;
            If (Hor <> nil)
              then Horario[1] := Hor^
              else FillChar(Horario[1], 3, 0);
            TextXY(40, 16, Cadena2Str(Horario[1]));
            Vueltas(5,30);

            Hor := Matrix;
            If (Hor <> nil)
              then Horario[2] := Hor^
              else FillChar(Horario[2], 3, 0);
            TextXY(40, 17, Cadena2Str(Horario[2]));
            Vueltas(5,30);

            Hor := Matrix;
            If (Hor <> nil)
              then Horario[3] := Hor^
              else FillChar(Horario[3], 3, 0);
            TextXY(40, 18, Cadena2Str(Horario[3]));
            Vueltas(5,30);
          end
        else
          begin
            FillChar(Horario[1], 3, 0);
            FillChar(Horario[2], 3, 0);
            FillChar(Horario[3], 3, 0);
          end;
    end; { with Reg }
  Reset(F1);
  Seek(F1, FileSize(F1)); { se prepara para escribir }

  GotoXY(10, 20);
  If RespondeSi('¨Desea aceptar los datos ingresados?')
    then
      begin
        Write('S¡!');
        Write(F1, Reg); { graba el registro en el archivo y }
        AgregaSoc := True;
        ArmarLista(F1, Prim, Ulti); { re-arma la lista }
      end
    else
      begin
        Write('Ehmmm,...no, mejor no.'); { ...ehmmm, no hace nada (creo) }
        Vueltas(10, 10);
        AgregaSoc := False;
      end;
  Close(F1);     { Se cierra el archivo }
  Vueltas(10, 20);
  InitVideo;
  Pantalla^ := Scr;
end;  { --- AgregaSoc --- }



{ Escribe un registro en los campos de la l¡nea especificada }
{ Tambi‚n se puede especificar si se desea que aparezca seleccionado }
Procedure MostrarSocio(Selec : Boolean; Linea : Byte; const Soc : TSocio);
begin
  If Selec then Colorea(TextoSelec, FondoSelec);
  TextXY(3, Linea, Espacios(75));       { limpia los campos de la tabla }
  TextXY(5, Linea, Soc.Apellido+',');                 { escribe }
  TextXY(32, Linea, Soc.Nombre+'.');                    { los }
  TextXY(62, Linea, Soc.Categoria);                    { datos }
  If Soc.MesPagado = 0
    then
      TextXY(67, Linea, 'NO PAGO')
    else
      TextXY(67, Linea, MesesStr[Soc.MesPagado]);
  If Selec then Colorea(TextoNormal, FondoNormal);
end; { --- MostrarSocio --- }



{ Muestra los 12 socios que caben en la ventana de la lista }
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
            MostrarSocio(False, L, P^.Soc);
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
              Mostrar12(P);
              MostrarSocio(True, Linea, P^.Soc);
            end;
      end;
end; { --- Arriba --- }



{ Baja un registro en le lista }
Procedure Abajo(var Linea : Byte; var P : PElem);
begin
  If (P^.Sig = nil)
    then
      ErrorBip(TeclaMala)
    else
      begin
        If (Linea < 19)
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
              Mostrar12(P^.Ant^.Ant^.Ant^.Ant^.Ant^.
                      { 1    2    3    4    5    6 }
                      Ant^.Ant^.Ant^.Ant^.Ant^.Ant);
                      { 7    8    9   10   11   12 }
              MostrarSocio(True, Linea, P^.Soc);
            end;
      end;
end; { --- Abajo --- }


{ Sube hasta 12 registros en la lista (de un saque) }
Procedure PageUp(var P : PElem; var Linea : Byte);
var X : Byte;
begin
  X := 1;
  While (P^.Ant <> nil) and (X < 12) do
    begin
      Sound(100);
      Delay(10);
      Arriba(Linea, P);
      X := X + 1;
      NoSound;
    end;
end; { --- PageUp --- }



{ Baja hasta 12 registros en la lista (de un saque) }
Procedure PageDown(var P : PElem; var Linea : Byte);
var X : Byte;
begin
  X := 1;
  While (P^.Sig <> nil) and (X < 12) do
    begin
      Sound(100);
      Delay(10);
      Abajo(Linea, P);
      X := X + 1;
      NoSound;
    end;
end; { --- PageDown --- }



{ Se sit£a al comienzo de la lista }
Procedure Inicio(var Linea : Byte; var P : PElem);
begin
  While (P^.Ant <> nil) do Arriba(Linea, P);
end; { --- Inicio --- }


{ Se sit£a al fibal de la lista }
Procedure Final(var Linea : Byte; var P : PElem);
begin
  While (P^.Sig <> nil) do Abajo(Linea, P);
end; { --- Final --- }



{ Elimina el socio de la lista, asign ndole el atributo de borrado y }
{ volviendo a armar la lista }
Procedure BorrarSocio(var Pri, Ult, Aux : PElem; var Linea : Byte);
var Scr     : Screen;
    NomArch : String[12];
    Arch    : SocioFile;
    Reg     : TSocio;
begin
  Scr := Pantalla^; { guarda la pantalla }
  Window(5, 9, 75, 16); { crea un cuadro de di logo }
  Colorea(TextoSelec, FondoSelec);
  ClrScr;
  TextXY(9, 1, '>>>>>>>>>>>>>>>> ­­­ C U I D A D O !!! <<<<<<<<<<<<<<<<');
  ErrorBip(ErrorDeUsuario);     { por si es ciego, para que escuche }
  TextXY(3, 3, '­El socio: '+ Aux^.Soc.Apellido+ ', '+ Aux^.Soc.Nombre+ '.');
  TextXY(3, 4, 'est  a punto de ser eliminado!!!.');
  TextXY(10, 6, '');            { pregunta amigablemente al usuario }
  If RespondeSi('¨ Est  usted seguro ?')
    then
      begin { Borra el socio, noma'... }
        Write('S¡...');

        If (Aux^.Soc.Categoria = 'F')
          then                            { Asigna el nombre del archivo }
            NomArch := 'PLIBRE.SCA'
          else
            NomArch := 'SOCIOS.SCA';
        If not ExisteArchivo(NomArch, Archive)
          then                            { avisa en caso de error }
            ShowError;
        Assign(Arch, NomArch);
        Reset(Arch);             { abre el archivo }

        Repeat
          If EoF(Arch) { busca el registro del socio actual }
            then       { ­ERROR FATAL!: El socio estaba en la lista, }
              ShowError;               { pero no en el archivo!!! }
          Read(Arch, Reg);
        Until SociosIguales(Reg, Aux^.Soc);

        Seek(Arch, FilePos(Arch) - 1);  { Retrocede un registro }
                                        { para actualizarlo }
        Reg.Borrado := True; { le asigna el atributo de Borrado }
        Write(Arch, Reg);      { y lo escribe en el archivo }

        ArmarLista(Arch, Pri, Ult); { vuelve a armar la lista }
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
              MostrarSocio(True, Linea, Aux^.Soc);
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



Procedure ImprimirLista(var Prim, Ulti : PElem);
var Scr : Screen;
    Count : Byte;
    Code  : Word;
    Socio : PElem;
    Header : String[79];
begin
  Scr := Pantalla^;
  Window(5, 9, 75, 16); { crea un cuadro de di logo }
  Colorea(TextoSelec, FondoSelec);
  ClrScr;
  TextXY(9, 1, '>>>>>>>>>>>>>>>>   I M P R E S I O N   <<<<<<<<<<<<<<<<');
  TextXY(3, 3, 'Introduzca un texto para el encabezado del reporte:');
  TextXY(3, 4, ''); ReadLn(Header);
  TextXY(10, 6, '');
  If RespondeSi('¨ Est  usted seguro ?')
    then
      begin
        Write('S¡!');
        DelayBar(5, 100); { para que el usuario tenga tiempo de leer }
        ClrScr;
        TextXY(9, 1, '>>>>>>>>>>>>>>>>  ­ A T E N C I O N !  <<<<<<<<<<<<<<<<');
        TextXY(3, 3, ' Est  a punto de imprimir la lista. Verifique que la');
        TextXY(3, 4, ' impresora est‚ enchufada, encendida, tenga papel, y');
        TextXY(3, 5, ' est‚ On-Line!');
        TextXY(10, 6, '');
        If RespondeSi('¨ Est  todo listo ?')
          then
            begin
              Write('Yeah!');
              DelayBar(5, 100); { para que el usuario tenga tiempo de leer }
              ClrScr;
              TextXY(9, 1, '>>>>>>>>>>>>>>>> I M P R I M I E N D O <<<<<<<<<<<<<<<<');
              TextXY(3, 3, ' Espere un par de a¤os...');
              TextXY(3, 4, ' El programa est  enviando los datos de la cola de');
              TextXY(3, 5, ' impresi¢n a trav‚s del puerto paralelo...');
              Window(1,1,80,25); { restaura la ventana }
         {$I-}
{printing...} WriteLn (Lst, Header);
              Code := IOResult;
              If (Code <> 0)
                then
                  MostrarMensaje('­­­ ERROR FATAL DE IMPRESION !!!',
                                 'No se puede imprimir por culpa del usuario!'+#13+
                                 'C¢digo de Error = '+IntAStr(Code))
                else
                  begin
                    For Count := 1 to 79 do Write(Lst, 'Í');
                    WriteLn(Lst);
                    Socio := Prim;
                    Repeat
                      With Socio^.Soc do
                        begin
                          WriteLn(Lst, Apellido+', ', Nombre, ':');
                          Write  (Lst, #9#9,'Edad: ', Edad, ' a¤os. ');
                          Write  (Lst, 'Categor¡a: "', Categoria, '". ');
                          WriteLn(Lst, 'Tel.: ', Telefono);
                          WriteLn(Lst, #9#9, 'Direcci¢n : ', Direccion);
                          Write  (Lst, #9#9, 'Fecha de ingreso : ', FechaIng);
                          WriteLn(Lst, '. Ultimo mes pagado : ', MesesStr[MesPagado]);
                          If (Categoria <> 'F')
                            then
                              begin
                                Write(Lst, #9#9, 'Horarios : ');
                                Write(Lst, Cadena2Str(Horario[1]), '. ');
                                Write(Lst, Cadena2Str(Horario[2]), '. ');
                                Write(Lst, Cadena2Str(Horario[3]), '.');
                                WriteLn(Lst);
                              end;
                          WriteLn(Lst);
                        end;
                      Socio := Socio^.Sig;
                      Code := IOResult;
                      If (Code <> 0)
                        then
                          MostrarMensaje('­­­ ERROR FATAL DE IMPRESION !!!',
                                         'No se puede imprimir por culpa del usuario!'+#13+
                                         'C¢digo de Error = '+IntAStr(Code));
                    Until (Socio = nil);

                    Write(Lst, #12); { Fin de p gina }
                  end;
         {$I+}
            end
          else
            begin
              Write('Ehmmm,...no, mejor no.'); { ...ehmmm, no hace nada (creo) }
            end;
      end
    else
      begin
        Write('Ehmmm,...no, mejor no.'); { ...ehmmm, no hace nada (creo) }
      end;
  DelayBar(5, 100); { para que el usuario tenga tiempo de leer }
  Colorea(TextoNormal, FondoNormal);
  Window(1,1,80,25); { restaura la ventana }
  Pantalla^ := Scr;   { y la pantalla }
end;




Procedure PagarCuota(var P : PElem);
var Scr     : Screen;
    NomArch : String[12];
    Arch    : SocioFile;
    Reg     : TSocio;
    A,M,D,W : Word;
    Code    : Byte;
    Count   : Byte;
begin
  Scr := Pantalla^; { guarda la pantalla }
  Window(5, 9, 75, 16); { crea un cuadro de di logo }
  Colorea(TextoSelec, FondoSelec);
  ClrScr;
  TextXY(9, 1, '>>>>>>>>>>>>>>>>  ­ A T E N C I O N !  <<<<<<<<<<<<<<<<');
  TextXY(3, 3, 'El socio: ' + P^.Soc.Apellido+ ', ' +
                              P^.Soc.Nombre+ '.');
  If P^.Soc.MesPagado = 0
    then
      begin
        GetDate(A,M,D,W);
        TextXY(3, 4, 'est  pagando la cuota del mes de ' +
                      MesesStr[M] + '.');
      end
    else
      TextXY(3, 4, 'est  pagando la cuota del mes de ' +
                    MesesStr[P^.Soc.MesPagado+1] + '.');
  TextXY(10, 6, '');
  If RespondeSi('¨ Est  usted seguro ?')
    then
      begin
        Write('S¡!');
        DelayBar(5, 100);
        If (P^.Soc.Categoria = 'F')
          then                            { Asigna el nombre del archivo }
            NomArch := 'PLIBRE.SCA'
          else
            NomArch := 'SOCIOS.SCA';
        If not ExisteArchivo(NomArch, Archive)
          then                            { avisa en caso de error }
            ShowError;
        Assign(Arch, NomArch);
        Reset(Arch);             { abre el archivo }

        Repeat
          If EoF(Arch) { busca el registro del socio actual }
            then       { ­ERROR FATAL!: El socio estaba en la lista, }
              ShowError;               { pero no en el archivo!!! }
          Read(Arch, Reg);
        Until SociosIguales(Reg, P^.Soc);

        Seek(Arch, FilePos(Arch) - 1);  { Retrocede un registro }
                                        { para actualizarlo }
        With P^.Soc do
          begin
            If MesPagado = 0
              then MesPagado := M
              else MesPagado := MesPagado + 1; { Actualiza el Mes pagado en }
            While (MesPagado > 12) do      { el registro de la lista. }
              MesPagado := MesPagado - 12;
          end;
        Write(Arch, P^.Soc);    { lo escribe eb el archivo }
        Close(Arch);

        ClrScr;
        TextXY(9, 1, '>>>>>>>>>>>>>>>>  ­ A T E N C I O N !  <<<<<<<<<<<<<<<<');
        TextXY(3, 3, ' Est  a punto de imprimir el recibo de pago. Verifique');
        TextXY(3, 4, ' que la impresora est‚ enchufada, encendida, tenga');
        TextXY(3, 5, ' papel y est‚ On-Line!');
        Repeat
          TextXY(10, 6, '');
        Until RespondeSi('¨ Est  todo listo ?');
        Write('Yeah!');
        DelayBar(5, 100); { para que el usuario tenga tiempo de leer }
        ClrScr;
        TextXY(9, 1, '>>>>>>>>>>>>>>>> I M P R I M I E N D O <<<<<<<<<<<<<<<<');
        TextXY(3, 3, ' Espere un par de a¤os...');
        TextXY(3, 4, ' El programa est  enviando los datos de la cola de');
        TextXY(3, 5, ' impresi¢n a trav‚s del puerto paralelo...');
        Window(1,1,80,25); { restaura la ventana }
     {$I-}
{printing...}
        WriteLn(Lst, '          ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»');
        WriteLn(Lst, '          º        Centro de Nataci¢n del Club Las Heras        º');
        WriteLn(Lst, '          º                    RECIBO DE PAGO                   º');
        WriteLn(Lst, '          ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶');
        WriteLn(Lst, '          º  Mediante el presente recibo, queda expreso que     º');
        WriteLn(Lst, '          º ', P^.Soc.Nombre, #32, P^.Soc.Apellido,
                     'º':65-12-Length(P^.Soc.Nombre+#32+P^.Soc.Apellido));
        WriteLn(Lst, '          º ha pagado el mes de ', MesesStr[P^.Soc.MesPagado], '.',
                     'º':64-32-(Length(MesesStr[P^.Soc.MesPagado])));
        WriteLn(Lst, '          º                                                     º');
        WriteLn(Lst, '          º                                                     º');
        WriteLn(Lst, '          º                                Firma:............   º');
        WriteLn(Lst, '          ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼');
        WriteLn(Lst);
        Code := IOResult;
        If (Code <> 0)
          then
            MostrarMensaje('­­­ ERROR FATAL DE IMPRESION !!!',
                           'No se puede imprimir por culpa del usuario!'+#13+
                           'C¢digo de Error = '+IntAStr(Code))
          else
            begin
              WriteLn(Lst);
              For Count := 1 to 39 do Write(Lst, ' -');
              WriteLn(Lst);
              Write(Lst, #12); { Fin de p gina }
            end;
      end
    else { no est  seguro? }
      begin
        Write('Ehmmm,...no, mejor no.'); { ...ehmmm, no hace nada (creo) }
      end;
  DelayBar(5, 100); { para que el usuario tenga tiempo de leer }
  Colorea(TextoNormal, FondoNormal);
  Window(1,1,80,25); { restaura la ventana }
  Pantalla^ := Scr;   { y la pantalla }
end; { --- PagarMes --- }




Procedure MostrarFicha(var Socio : TSocio);
var
  Scr : Screen;
  Tec : Char;
  Int : LongInt;
  Cat : Char;
  Hor : PCadenaH;
begin
  Scr := Pantalla^; { guarda la pantalla }
  DoneVideo;
  Presenta;
  CentText(4, '>> Ficha Personal del Socio <<');
  With Socio do
    begin
      TextXY(10, 6, 'Datos Personales:');       { presenta los datos }
      TextXY(6,  8, ' Apellido : '+Apellido);
      TextXY(6,  9, 'Nombre(s) : '+Nombre);
      TextXY(6, 10, '     Edad : '+IntAStr(Edad)+'  a¤os.');
      TextXY(6, 11, 'Direcci¢n : '+Direccion);
      TextXY(6, 12, ' Tel‚fono : '+Telefono);

      TextXY(55,  6, 'Fecha de Ingreso :');
      TextXY(60,  7, FechaIng);
      TextXY(55, 13, 'Ultimo mes pagado :');
      TextXY(60, 14, IntAStr(MesPagado));
      TextXY(63, 14, '('+MesesStr[MesPagado]+')');

      TextXY(6, 15, 'Categor¡a : "'+Categoria+'" : '+
                     Categoria2Str(Categoria));
      If (Categoria <> 'F')
        then
          begin
            TextXY(6, 17, 'Horarios :');
            TextXY(20, 17, Cadena2Str(Horario[1]));
            TextXY(20, 18, Cadena2Str(Horario[2]));
            TextXY(20, 19, Cadena2Str(Horario[3]));
          end;
    end;

  Select2(5,43, 8, 5,43, 8);

  Repeat
    Tec := Readkey;
    Case Tec of
      #13 : { Editar campo }
        begin
          Case WhereY of
             8 : Socio.Apellido  := EditaCampo(18, 8, 25, Socio.Apellido);
             9 : Socio.Nombre    := EditaCampo(18, 9, 25, Socio.Nombre);
            10 : { Edad }
              begin
                While not StrAInt(EditaCampo(18, 10, 3, IntAStr(Socio.Edad)), Int) do
                  MostrarMensaje('­TREMENDO ERROR DE USUARIO!',
                                 'En el campo de Edad s¢lo se pueden ingresar los'+#13+
                                 'siguientes caracteres num‚ricos (n£meros):'+#13+
                                 '1, 2, 3, 4, 5, 6, 7, 8, 9, y 0.');
                Socio.Edad := Byte(Int);
              end;
            11 : Socio.Direccion := EditaCampo(18, 11, 50, Socio.Direccion);
            12 : Socio.Telefono  := EditaCampo(18, 12, 10, Socio.Telefono);
            15 : { Categoria }
              If (Socio.Categoria = 'F')
                then
                  begin
                    MostrarMensaje(' P I L E T A    L I B R E ',
                                   'El socio seleccionado NO concurre a Escuela de Nataci¢n.'+#13+
                                   'No se puede modificar la categor¡a ni los horarios.'+#13+
                                   'Para ello cree un nuevo registro.');
                  end
                else
                  begin
                    Colorea(TextoSelec, FondoSelec);
                    TextXY(18, 15, '"'+Socio.Categoria+'"');
                    Repeat
                      Cat := UpCASe(ReadKey);
                      If not (Cat in ['A'..'E'])
                        then
                          MostrarMensaje('­ E R R O R   D E   U S U A R I O !',
                                         '­Seleccione una categor¡a v lida!'+#13+
                                         'Las categor¡as v lidas son:'+#13+
                                         '"A", "B", "C", "D" y "E".');
                    Until (Cat in ['A'..'E']);
                    Colorea(TextoNormal, FondoNormal);
                    Socio.Categoria := Cat;
                    TextXY(6, 15, Espacios(32));
                    TextXY(6, 15, 'Categor¡a : "'+Socio.Categoria+'" : '+
                                   Categoria2Str(Socio.Categoria));
                  end;
            17 : { Horarios }
              begin
                Colorea(TextoSelec, FondoSelec);
                TextXY(6, 17, 'Horarios');
                Colorea(TextoNormal, FondoNormal);

                Hor := Matrix;
                If (Hor <> nil)
                  then Socio.Horario[1] := Hor^
                  else FillChar(Socio.Horario[1], 3, 0);
                TextXY(20, 17, Cadena2Str(Socio.Horario[1]));
                Vueltas(5,30);

                Hor := Matrix;
                If (Hor <> nil)
                  then Socio.Horario[2] := Hor^
                  else FillChar(Socio.Horario[2], 3, 0);
                TextXY(20, 18, Cadena2Str(Socio.Horario[2]));
                Vueltas(5,30);

                Hor := Matrix;
                If (Hor <> nil)
                  then Socio.Horario[3] := Hor^
                  else FillChar(Socio.Horario[3], 3, 0);
                TextXY(20, 19, Cadena2Str(Socio.Horario[3]));
                Vueltas(5,30);

                TextXY(6, 17, 'Horarios');
              end;
          end { case }
        end; { enter }

      #0 : { teclas especiales }
        Case Readkey of
          #72 : { Arriba }
             begin
               Case WhereY of
                 17 : Select2( 5,16,17,  5,38,15);
                 15 : Select2( 5,38,15,  5,28,12);
                 12 : Select2( 5,28,12,  5,70,11);
                 11 : Select2( 5,70,11,  5,27,10);
                 10 : Select2( 5,27,10,  5,43, 9);
                  9 : Select2( 5,43, 9,  5,43, 8);
                  8 : If (Socio.Categoria = 'F')
                        then
                          Select2( 5,43, 8,  5,28,12)
                        else
                          Select2( 5,43, 8,  5,16,17);
               end;

            end;
          #80 : { Abajo }
            begin
              Case WhereY of
                 8 : Select2( 5,43, 8,  5,43, 9);
                 9 : Select2( 5,43, 9,  5,27,10);
                10 : Select2( 5,27,10,  5,70,11);
                11 : Select2( 5,70,11,  5,28,12);
                12 : If (Socio.Categoria = 'F')
                       then
                         Select2( 5,28,12,  5,43, 8)
                       else
                         Select2( 5,28,12,  5,38,15);
                15 : Select2( 5,38,15,  5,16,17);
                17 : Select2( 5,16,17,  5,43, 8);
              end;
            end;
          else ErrorBip(TeclaMala);
        end; { Case teclas especiales }

      else ErrorBip(TeclaMala);

    end; { End Case Principal }

  Until (Tec = #27); { hasta pulsar Esc }

  While KeyPressed do ReadKey; { limpia el b£ffer del teclado }
 { si crees que est  al pedo, probala sin esto y apret  la tecla '' }
  InitVideo;
  Pantalla^ := Scr;
end; { --- MostrarFicha --- }


Procedure ModificaSocio(Socios : Boolean; var Soc : TSocio);
var
  FS        : SocioFile;
  SocioBak  : TSocio;
  SocioDisk : TSocio;
begin
  SocioBak := Soc;
  MostrarFicha(Soc);
  If Socios
    then
      Assign(FS, 'SOCIOS.SCA')
    else
      Assign(FS, 'PLIBRE.SCA');
  Reset(FS);
  Repeat
{$I-}
    Read(FS, SocioDisk);
    If (IOResult <> 0)
      then
        ShowError;
  Until SociosIguales(SocioBak, SocioDisk);
  Seek(FS, FilePos(FS) - 1);
  Write(FS, Soc);
  Close(FS);
  If (IOResult <> 0)
    then
      ShowError;
{$I+}
end; { --- ModificaSocio --- }






Procedure Listar(Socios : Boolean; var Prim, Ulti : PElem);
var
  Auxi  : PElem;
  Salir : Boolean;
  Linea : Byte;
begin
  TextXY(5, 6, 'Apellido:');
  TextXY(32, 6, 'Nombre:');
  TextXY(60, 6, 'Cat.:');
  TextXY(67, 5, 'Ultimo mes');
  TextXY(67, 6, 'pagado');
  TextXY(1, 7, 'ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ'+
               'ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶');
  Salir := False;
  Auxi := Prim;
  Linea := 8;
  Mostrar12(Auxi);
  If (Auxi <> nil)
    then
      begin
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
          If (Auxi <> nil)
            then
              begin
                ModificaSocio(Socios, Auxi^.Soc);
                MostrarSocio(True, Linea, Auxi^.Soc);
              end
            else
              ErrorBip(ErrorDeUsuario);
        end;

{ i } #105,
{ I } #73 :
        begin
          If (Auxi <> nil)
            then
              ImprimirLista(Prim, Ulti)
            else
              ErrorBip(ErrorDeUsuario);
        end;


{ p } #112,
{ P } #80 :
        begin
          If (Auxi <> nil)
            then
              begin
                PagarCuota(Auxi);
                MostrarSocio(True, Linea, Auxi^.Soc);
              end
            else
              ErrorBip(ErrorDeUsuario);
        end;

      #00 : { teclas especiales }
        begin
          Case ReadKey of
            #82 : { Insert }
              begin
                 If AgregaSoc(Socios, Prim, Ulti)
                   then
                     begin
                       Auxi := Prim;
                       Linea := 8;
                       Mostrar12(Auxi);
                       MostrarSocio(True, Linea, Auxi^.Soc);
                       Final(Linea, Auxi)
                     end
                   else
                     ErrorBip(TeclaMala);
               end;
            #83 : { Delete }
              begin
                If (Auxi <> nil)
                  then
                    BorrarSocio(Prim, Ulti, Auxi, Linea)
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
        CentText(3, '>> Lista de socios que concurren a' +
                    ' la Escuela de Nataci¢n <<')
      end
    else
      begin
        Archivo := 'PLIBRE';  { Archivo de Pileta Libre }
        CentText(3, '>> Lista de los que concurren a' +
                    ' Pileta Libre <<')
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
        CentText(5, 'No hay registros activos en '+ Archivo + '.SCA');
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
END.  { SyCASe! ClubList Unit - CLUBLIST.PAS }