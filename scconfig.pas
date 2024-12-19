Unit SCConfig;
{ SCCONFIG.PAS }


INTERFACE

Var
  TextoNormal,
  FondoNormal,

  TextoSelec,
  FondoSelec : Byte;

  SegmVideo,
  OffsVideo : Word;
  var F : Text;

  Procedure MenudeConfig;

{ Estas variables se configuran con la funci¢n LeeColoresDeConfiguracion }

IMPLEMENTATION

Uses ClubMain, Selector, CASeUnit, Drivers, Interfaz, Dos, Crt;

Procedure LeeDatosDeConfiguracion;
begin
  SegmVideo := $B800;
  OffsVideo := $0000;
  TextoNormal := 0;
  FondoNormal := 7;
  TextoSelec := 15;
  FondoSelec := 0;

  Assign(F, 'CONFIG.SCA');
  If not ExisteArchivo('CONFIG.SCA', Archive)
    then
      begin
        ReWrite(F);
        WriteLn(F, SegmVideo);
        WriteLn(F, OffsVideo);

        WriteLn(F, TextoNormal);
        WriteLn(F, FondoNormal);
        WriteLn(F, TextoSelec);
        WriteLn(F, FondoSelec);
      end;

  Reset(F);
  If not EoF(F) then Read(F, SegmVideo);
  If not EoF(F) then Read(F, OffsVideo);
  If not EoF(F) then Read(F, TextoNormal);
  If not EoF(F) then Read(F, FondoNormal);
  If not EoF(F) then Read(F, TextoSelec);
  If not EoF(F) then Read(F, FondoSelec);
  Close (F);  { creo que no est  por ning£n lado y por eso lo agregu‚ }
end;


Procedure MenudeConfig;
Var Tecla:Char;
begin
  Presenta;
  CentText (3,'>> Men£ de Configuraci¢n <<');
  TextXY (7,7,'Tipo de monitor:  Mono Color');
  TextXY (4,9,'Valor en la escala de colores para: (ñ2.147.483.647)');
  TextXY (7,10,'Texto normal: '+ IntAStr(TextoNormal));
  TextXY (7,11,'Fondo normal: '+ IntAStr(FondoNormal));
  TextXY (7,12,'Texto Selecionado: '+ IntAStr(TextoSelec));
  TextXY (7,13,'Fondo Selecionado: '+ IntAStr(FondoSelec));
  if SegmVideo=47104 then Select (30,7,30,7,4)
                     else Select (25,7,25,7,4);
  Colorea (TextoNormal, FondoNormal);
  TextXY (15, 15,'¨Desea cambiar esta configuraci¢n?');
  If RespondeSi('') then
     Begin
       Write('...S¡!');
       Vueltas(10, 30);
       TextXY (15, 15,'                                                  ');
       if SegmVideo=47104 then Select (30,7,30,7,4)
                          else Select (25,7,25,7,4);
       Colorea (TextoNormal, FondoNormal);
       Repeat
         Tecla := ReadKey;
         CASe Tecla of
           #00 :
             CASe ReadKey of
               #75,#77 :    { Left or Right }
                 CASe WhereX of
                   30 : Select (30,7,25,7,4);
                   25 : Select (25,7,30,7,4);
                   else ErrorBip(TeclaMala);
                 end;
               else ErrorBip(TeclaMala);
             end;
           #13 :
             CASe WhereX of
                 30 : SegmVideo:=$B800;
                 25 : SegmVideo:=$B000;
               end;
           else ErrorBip(Teclamala);
         end;
       until Tecla=#13;
       Colorea (TextoNormal, FondoNormal);
       Select (6,10,6,10,23);
       Repeat
         Tecla := ReadKey;
         CASe Tecla of
           #00 :
             CASe ReadKey of
               #72 :    { arriba }
                 CASe WhereY of
                   13 : Select (6,13,6,12,23);
                   12 : Select (6,12,6,11,23);
                   11 : Select (6,11,6,10,23);
                   10 : Select (6,10,6,13,23);
                   else ErrorBip(TeclaMala);
                 end;
               #80 : { abajo }
                 CASe WhereY of
                   10 : Select (6,10,6,11,23);
                   11 : Select (6,11,6,12,23);
                   12 : Select (6,12,6,13,23);
                   13 : Select (6,13,6,10,23);
                   else ErrorBip(TeclaMala);
                 end;
               else ErrorBip(TeclaMala);
             end;
           #13 :
             CASe WhereY of
               10 : Begin
                      TextXY (7,10,'Texto normal:     ');
                      GotoXY (21,10); ReadLn (TextoNormal);
                      Select (6,10,6,10,23);
                    End;
               11 : begin
                      TextXY (7,11,'Fondo normal:     ');
                      GotoXY (21,11); ReadLn (FondoNormal);
                      Select (6,11,6,11,23);
                    end;
               12 : Begin
                      TextXY (7,12,'Texto Selecionado:     ');
                      GotoXY (26,12); ReadLn (TextoSelec);
                      Select (6,12,6,12,23);
                    end;
               13 : Begin
                      TextXY (7,13,'Fondo Selecionado:     ');
                      GotoXY (26,13); ReadLn (FondoSelec);
                      Select (6,13,6,13,23);
                    End;
             end;
           else ErrorBip(Teclamala);
         end;
       until Tecla=#27;
       ReWrite (F);
       WriteLn (F, SegmVideo);
       WriteLn (F, OffsVideo);
       WriteLn (F, TextoNormal);
       WriteLn (F, FondoNormal);
       WriteLn (F, TextoSelec);
       WriteLn (F, FondoSelec);
       If segmVideo=$B800 then WriteLn (F, $B000) else WriteLn (F, $B800);
       Close(F);
     end  { if responde si a cambiar la config }
    else
      begin
        Write('...eeehm... No.');
        Vueltas(10, 30);
      end;
end;

BEGIN
  Write('Inicializando Configuraci¢n...');
  DelayBar(5, 100); WriteLn;
  LeeDatosDeConfiguracion;
  SetuPantalla(SegmVideo, OffsVideo);
END.