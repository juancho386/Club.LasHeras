Program VerKey;

Uses Crt;

Var T : Char;

BEGIN
  Repeat
    T := ReadKey;
    WriteLn(T, ' - ', Ord(T));
  Until T = #27;
  WriteLn('Color: ', $B800);
  WriteLn('Mono : ', $B000);
END.