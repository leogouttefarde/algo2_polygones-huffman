
with Ada.Command_Line; use Ada.Command_Line;
with Ada.Text_IO; use Ada.Text_IO;
with Parseur; use Parseur;
with SVG; use SVG;
with Common; use Common; use Common.Arbre_Segments;
with Decompose; use Decompose;


procedure Main is

        package Point_Sorting is new Point_Lists.Generic_Sorting( "<" );

        Points : Point_Lists.List;
        Segments : Segment_Lists.List;
        cAVL : Arbre_Segments.Arbre;
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

                -- On commence l'algorithme à partir du second point trié
                Point_Lists.Next( Point_Pos );

                cPoint := Point_Lists.Element( Point_Pos );

                -- On remplit l'arbre avec les segments en intersection
                Intersection(Segments, cPoint.X, cAVL);


                while Point_Lists.Has_Element( Point_Pos ) loop

                        cPoint := Point_Lists.Element( Point_Pos );

                        Decomposition(cPoint, cAVL);

                        Point_Lists.Next( Point_Pos );

                end loop;

                Svg_Footer;
        end if;

end Main;


