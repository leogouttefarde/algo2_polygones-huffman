
with Ada.Text_IO, GNAT.OS_Lib, GNAT.String_Split, Common;
use Ada.Text_IO, GNAT.String_Split, Common;


package Parseur is

        procedure Lire_Polygone(Chemin : in String ; Points : out Point_Lists.List);

end Parseur;


