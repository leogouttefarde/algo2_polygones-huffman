
with Arbre;
with Ada.Command_Line; use Ada.Command_Line;
with Ada.Text_IO; use Ada.Text_IO;
with Parseur; use Parseur;
with SVG; use SVG;
with Common; use Common;


procedure Main is

        package Arbre_Segments is new Arbre(Segment, "<", ">");
        use Arbre_Segments;

        package Point_Sorting is new Point_Lists.Generic_Sorting( "<" );

        Points : Point_Lists.List;
        Segments : Segment_Lists.List;
        AVL : Noeud;
        Point_Pos : Point_Lists.Cursor;
        cPoint : Point;
begin

        if Argument_Count < 1 then
                Put_Line(Standard_Error, "Usage : " & Command_Name & " polygon.in");
                Set_Exit_Status(Failure);
        else
                Lire_Polygone(Argument(1), Points);

                Segments := Generate_Segments(Points);

                Svg_Header(100, 100);

                Svg_Polygon(Points);

                Point_Sorting.Sort(Points);

                Point_Pos := Point_Lists.First( Points );

                while Point_Lists.Has_Element( Point_Pos ) loop

                        cPoint := Point_Lists.Element( Point_Pos );

                        -- print new segs
                        --Decomposition(Point, AVL);

                        Point_Lists.Next( Point_Pos );

                end loop;

                Svg_Footer;
        end if;

end Main;


