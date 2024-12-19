Program Depurador;      { Depurador para el archivo de socios     }
uses crt, DOS
     CASeUnit, SCTypes;{ para el Administrador del Club LasHeras }

Var
  actual, { es la posici¢n actual en el file }
  maschico, { es el archivo que por el momento se escribe hasta que encuentre otro }
  reg   : TSocio; { es el que definitivamente se escribe y queda }
  I,J,K : byte;
  primera,
  segunda,
  ultima: file of TSocio;


Procedure Borrar;
Begin
end;

BEGIN
  ClrScr;
  CentText (1,'Analizando la base de datos ');
{  Vueltas (30,30);}
  write (#32);
  If not encuentra('SOCIOS.SCA') then begin
    CentText (2,'Error Inesperado 201: El archivo de datos no se encuentra en el');
    CentText (3,'directorio actual. Cree uno con el Administrador y vuelva a');
    CentText (4,'intentar la operaci¢n.');
    Halt (201);
  end;
  CentText(WhereY+2,'Depurando archivo de datos');
  assign (primera,'socios.sca');
  assign (Segunda,'∞±≤€€≤±∞.sca');
  Borrar;
  Acomodar;
  CentText (12,'Depuraci¢n finalizada. Probablemente el administrador');
  CentText (WhereY+1,'funsione m†s r†pidamente a partir de ahora');
  TextXY (58,WhereY+1,'By SyCASe! Associated');
END.