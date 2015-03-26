
with Ada.Text_IO, GNAT.String_Split, SVG;
use Ada.Text_IO, GNAT.String_Split, SVG;
with Ada.Containers.Doubly_Linked_Lists;
with Common; use Common;


package Parseur is

        procedure Lire_Polygone(Chemin : in String ; Points : out Point_Lists.List);

end Parseur;


