
with AVL, SVG, Common;
use SVG, Common; use Common.Arbre_Segments;
with Ada.Containers;
use Ada.Containers;


package Decompose is

        -- Ajoute les segments entrants / sortants de chaque point
        procedure Finish_Points (Points : in out Point_Lists.List ; Segments : Segment_Lists.List);

        -- Génère les segments correspondant aux points donnés
        function Generate_Segments (Points : in Point_Lists.List) return Segment_Lists.List;

        -- Exécute l'algorithme de décomposition pour le point donné
        procedure Decomposition(cPoint : Point ; cAVL : in out Arbre);

end Decompose;


