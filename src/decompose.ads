
with Common; use Common; use Common.Arbre_Segments;
with AVL;
with Ada.Containers;
use Ada.Containers;


package Decompose is

        procedure Finish_Points (Points : in out Point_Lists.List ; Segments : Segment_Lists.List);

        function Generate_Segments (Points : in Point_Lists.List) return Segment_Lists.List;

        procedure Intersection(Segments : Segment_Lists.List ; cPoint : Point ; cAVL : in out Arbre_Segments.Arbre);

        procedure Decomposition(cPoint : Point ; cAVL : in out Arbre_Segments.Arbre);

end Decompose;


