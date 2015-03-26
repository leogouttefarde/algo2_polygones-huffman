
with Common; use Common; use Common.Arbre_Segments;
with AVL;


package Decompose is

        procedure Intersection(Segments : Segment_Lists.List ; X : Float ; cAVL : in out Arbre_Segments.Arbre);

        procedure Decomposition(cPoint : Point ; cAVL : in out Arbre_Segments.Arbre);

end Decompose;


