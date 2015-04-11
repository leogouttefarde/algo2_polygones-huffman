
with Ada.Command_Line; use Ada.Command_Line;
with Ada.Text_IO; use Ada.Text_IO;
with Parseur; use Parseur;
with SVG; use SVG;
with Common; use Common; use Common.Arbre_Segments;
with Decompose; use Decompose;


procedure Main is

        Points : Point_Lists.List;
        Segments : Segment_Lists.List;
        cAVL : Arbre;
        Point_Pos : Point_Lists.Cursor;
        Segment_Pos : Segment_Lists.Cursor;
        cPoint : Point;
begin

        -- Gestion des arguments
        if Argument_Count < 1 then
                Put_Line(Standard_Error, "Usage : " & Command_Name & " polygon.in");
                Set_Exit_Status(Failure);

        else
                -- Lecture du fichier
                Lire_Polygone(Argument(1), Points);

                -- Génération des segments
                Segments := Generate_Segments(Points);

                -- Attribution des segments entrants et sortants de chaque point
                Finish_Points(Points, Segments);


                -- Début de la génération SVG
                Svg_Header(600, 600);
                Svg_Scale(Points);
                Svg_Polygon(Points);

                -- Tri des points
                Point_Sorting.Sort(Points);


                -- Parcours des points ordonnés
                Point_Pos := Point_Lists.First( Points );

                while Point_Lists.Has_Element( Point_Pos ) loop

                        cPoint := Point_Lists.Element( Point_Pos );

                        -- Application de l'algorithme
                        -- de décomposition sur chaque point
                        Decomposition(cPoint, cAVL);

                        Point_Lists.Next( Point_Pos );

                end loop;

                -- Fin de la sortie SVG
                Svg_Footer;


                -- Libération AVL (pas essentiel car déjà vidé normalement),
                -- ainsi on est assuré qu'il n'y a pas de leaks.
                Liberer(cAVL);
        end if;

end Main;


