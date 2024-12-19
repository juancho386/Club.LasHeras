{$A+,B-,D+,E+,F-,G+,I+,L+,N-,O-,P-,Q-,R-,S+,T-,V+,X+,Y+}
{$M 65521,0,655360}
Program Club;

Uses
  Crt,
  Dos,
  Drivers,
  Selector,
  SCAVers,
  CASeUnit,
  ClubList,
  ClubAlq,
  SCMatrix,
  ClubMain,
  SCConfig,
  Mensajes;




Procedure MenuPrincipal; { Muestra el menu principal del programa }
 procedure RedibujaMenu;
 begin { Redibuja el menu cuando vuelve de otra pantalla }
  Presenta;
  TextXY(14,  6, 'Listado de Escuela de Nataci¢n');
  TextXY(14,  8, 'Listado de Pileta Libre');
  TextXY(14, 10, 'Planilla de Horarios');
  TextXY(14, 12, 'Alquileres de Pileta');
  TextXY(14, 14, 'Men£ de Configuraci¢n...');
  TextXY(40, 18, 'Acerca del Administrador');
  TextXY(40, 20, 'Salir del Administrador');
  Select(12, 6, 12, 6, 33);
 end;

var Tecla : Char;
    QuiereSalir : Boolean;
begin
  InitVideo;
  RedibujaMenu;
  QuiereSalir := False;
  Repeat
    Tecla := ReadKey;
    CASe Tecla of
 { teclas especiales }
      #00 :
        CASe ReadKey of
      { Flecha Abajo }
          #80 :
            CASe WhereY of
              6  : Select(12,  6, 12,  8, 33);
              8  : Select(12,  8, 12, 10, 33);
              10 : Select(12, 10, 12, 12, 33);
              12 : Select(12, 12, 12, 14, 33);
              14 : Select(12, 14, 38, 18, 33);
              18 : Select(38, 18, 38, 20, 33);
              20 : Select(38, 20, 12,  6, 33);
              else
                Sonido(80, 100);
            end; { Case WhereY }
       { Flecha Arriba }
          #72 :
            CASe WhereY of
              20 : Select(38, 20, 38, 18, 33);
              18 : Select(38, 18, 12, 14, 33);
              14 : Select(12, 14, 12, 12, 33);
              12 : Select(12, 12, 12, 10, 33);
              10 : Select(12, 10, 12,  8, 33);
              8  : Select(12,  8, 12,  6, 33);
              6  : Select(12,  6, 38, 20, 33);
              else
                Sonido (80,100);
            end; { Case WhereY }
          else { si no son las flechas }
            Sonido(80, 100);
        end; { Case ReadKey of }
 { enter }
      #13 :
        CASe WhereY of
	  6  :
            begin   { listado de socios }
              ListaPrincipal(True);
              RedibujaMenu;
            end;
	  8  :
            begin   { listado de Pileta Libre }
              ListaPrincipal(False);
              RedibujaMenu;
            end;
	  10 : { Matriz de Horarios }
            begin
              ListaPorHorarios(Matrix);
              RedibujaMenu;
            end;
	  12 : {alquileres}
            begin
            { --- A L Q U I L E R E S --- }
              ListaAlquileres;
              RedibujaMenu;
            end;
          14 :
            begin
            { --- Men£ de Configuraci¢n --- }
            MenudeConfig;
            RedibujaMenu;
            end;
          18 :
            begin
              AcercaDe;
              RedibujaMenu;
            end;
	  20 : QuiereSalir := True;
          else
            ShowError;
        end; { Enter }
 { otras teclas }
      else
        sonido (80,100);

    end; { Case Tecla of }

  Until QuiereSalir; { hasta que pulse escape }

  Salida;

  DoneVideo;
end; { --- MenuPrincipal --- }



{ Declaraci¢n de Variables }
Var N : Byte;

{ Cuerpo Principal del Programa }
BEGIN
  GotoXY(1,1);
  For N := 1 to 79 do
    begin
      InsLine;
      Vueltas(1, 3);
    end;
  CentText(2, 'Programa Administrativo de la Escuela ' +
              'de Nataci¢n del Club Las Heras');
  CentText(4, 'Cargando...');
  Vueltas(10, 30);
  Presenta;
  CentText(4, 'Cargando...');
  Vueltas(5, 30);
  MenuPrincipal;
END.