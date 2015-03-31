
with AVL, SVG, Common;
use SVG, Common; use Common.Arbre_Segments;
with Ada.Containers;
use Ada.Containers;


package Decompose is

        procedure Finish_Points (Points : in out Point_Lists.List ; Segments : Segment_Lists.List);

        function Generate_Segments (Points : in Point_Lists.List) return Segment_Lists.List;

        procedure Decomposition(cPoint : Point ; cAVL : in out Arbre);

end Decompose;


