
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

        if Argument_Count < 1 then
                Put_Line(Standard_Error, "Usage : " & Command_Name & " polygon.in");
                Set_Exit_Status(Failure);
        else
                Lire_Polygone(Argument(1), Points);

                Segments := Generate_Segments(Points);
                Finish_Points(Points, Segments);

                Svg_Header(600, 600);
                Svg_Scale(Points);
                Svg_Polygon(Points);

                Point_Sorting.Sort(Points);


                Point_Pos := Point_Lists.First( Points );

                while Point_Lists.Has_Element( Point_Pos ) loop

                        cPoint := Point_Lists.Element( Point_Pos );

                        Decomposition(cPoint, cAVL);

                        Point_Lists.Next( Point_Pos );

                end loop;

                Svg_Footer;


                -- Libération AVL (pas essentiel car déjà vidé normalement),
                -- ainsi on est assuré qu'il n'y a pas de leaks.
                Liberer(cAVL);
        end if;

end Main;


