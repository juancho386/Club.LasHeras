Unit CampoSCA;

INTERFACE


Function EditaCampo(X, Y, L : Byte; ValIni : String) : String;
{ Lee un campo de longitud L que comienza en X,Y y devuelve:           }
{ un String que es lo que ingres¢ el chab¢n si puls¢ Enter y code = 13 }
{ si apret¢ escape devuelve un string igual a ValIni                   }


IMPLEMENTATION


Uses SCConfig, CASeUnit, Interfaz, Selector, Crt;


Function EditaCampo(X, Y, L : Byte; ValIni : String) : String;
var
  Tec : Char;   { tecla pulsada }
  STemp : String; { cadena temporal }
  Count : Byte;     { ¡ndice de la posici¢n actual }
  Letra : Byte;     {    "   de la letra }
  Salir, Listo : Boolean;
begin
  TextXY(X,Y, Espacios(L));
  Select(X, Y, X, Y, L-1);
  TextXY(X,Y, ValIni);
  STemp := ValIni;
  Listo := False;
  Salir := False;
  Count := Length(ValIni);
  Tec := #0;
  Repeat
    Tec := ReadKey;
    Case Tec of
      #13 : { Enter }
        Listo := True;

      #27 : { Escape }
        Salir := True;

      #32..#255 : { Caracteres Alfanum‚ricos, signos y chirimbolitos }
        begin
          If (Length(STemp) < L)
            then
              begin
                STemp[0] := Char(Ord(STemp[0]) + 1);
                For Letra := Length(STemp) downto Count + 1 do
                  begin
                    STemp[Letra] := STemp[Letra-1];
                  end;
                STemp[Letra] := Tec;
                TextXY(X, Y, Espacios(L));
                TextXY(X, Y, STemp);
                Count := Count + 1;
                GotoXY(X+Count, Y);
              end
            else
              ErrorBip(TeclaMala);
        end;

      #8  : { BackSpace }
        begin
          If (Count > 0) and (Count < Length(STemp) + 1)
            then
              begin
                For Letra := Count to Length(STemp) do
                  begin
                    STemp[Letra] := STemp[Letra+1];
                  end;
                STemp[0] := Char(Ord(STemp[0]) - 1);
                TextXY(X, Y, Espacios(L));
                TextXY(X, Y, STemp);
                Count := Count -1;
                GotoXY(X+Count, Y);
              end
            else
            ErrorBip(TeclaMala);
        end;

      #0  : { Teclas Especiales }
        Case ReadKey of
          #71 : { Home }
            begin
              If (Count > 0)
                then
                  begin
                    GotoXY(X,Y);
                    Count := 0;
                  end
                else
                  ErrorBip(TeclaMala);
            end;

          #79 : { End }
            begin
              If (Count < Length(STemp))
                then
                  begin
                    GotoXY(X+Length(STemp), Y);
                    Count := Length(STemp);
                  end
                else
                  ErrorBip(TeclaMala);
            end;

          #83 : { Delete }
            begin
              If (Count < L) and (Length(STemp) > Count)
                then
                  begin
                    For Letra := (Count + 1) to Length(STemp) do
                      begin
                        STemp[Letra] := STemp[Letra+1];
                      end;
                    STemp[0] := Char(Ord(STemp[0]) - 1);
                    TextXY(X, Y, Espacios(L));
                    TextXY(X, Y, STemp);
                    GotoXY(X+Count, Y);
                  end
                else
                  ErrorBip(TeclaMala);
            end;

          #75 : { Izquierda }
            begin
              If (Count > 0)
                then
                  begin
                    GotoXY(WhereX - 1, Y);
                    Count := Count - 1;
                  end
                else
                  ErrorBip(TeclaMala);
            end;

          #77 : { Derecha }
            begin
              If (Count < Length(STemp))
                then
                  begin
                    GotoXY(WhereX + 1, Y);
                    Count := Count + 1;
                  end
                else
                  ErrorBip(TeclaMala);
            end;

          else
            ErrorBip(TeclaMala);
        end;

      else { cualquier otra tecla }
        ErrorBip(TeclaMala);
    end; { Case Tec }
  Until (Tec = #27) or (Tec = #13);

  Colorea(TextoNormal, FondoNormal);

  If Listo
    then
      EditaCampo := STemp;

  If Salir
    then
      begin
        STemp      := ValIni;
        EditaCampo := ValIni;
      end;
  TextXY(X, Y, Espacios(L));
  TextXY(X, Y, STemp);
end; { --- LeeCampo --- }


BEGIN
END.

