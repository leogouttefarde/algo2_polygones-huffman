
with Arbre;
with Ada.Command_Line; use Ada.Command_Line;
with Ada.Text_IO; use Ada.Text_IO;
with Parseur; use Parseur;
with SVG; use SVG;
with Common; use Common;


procedure Main is

        function "<" (X, Y: Segment) return Boolean is
        begin
                return False;
        end;

        function ">" (X, Y: Segment) return Boolean is
        begin
                return False;
        end;

        package Arbre_Segments is new Arbre(Segment, ">", "<");
        use Arbre_Segments;

        function Generate_Segments (Points : in Point_Lists.List) return Segment_Lists.List is
                Segments : Segment_Lists.List;
                Point_Pos : Point_Lists.Cursor;
                First, Prev, cPoint, Last : Point;
                cSegment : Segment;
        begin
                Point_Pos := Point_Lists.First( Points );
                First := Point_Lists.Element( Point_Pos );
                Prev := First;

                loop
                        Point_Lists.Next( Point_Pos );
                        exit when not Point_Lists.Has_Element( Point_Pos );

                        cPoint := Point_Lists.Element( Point_Pos );

                        cSegment(1) := Prev;
                        cSegment(2) := cPoint;

                        Segment_Lists.Append( Segments, cSegment );

                        Prev := cPoint;
                end loop;

                Last := cPoint;


                cSegment(1) := Last;
                cSegment(2) := First;

                Segment_Lists.Append( Segments, cSegment );

                return Segments;
        end;


        Points : Point_Lists.List;
        Segments : Segment_Lists.List;
        ABR : Noeud;
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

                Point_Pos := Point_Lists.First( Points );

                while Point_Lists.Has_Element( Point_Pos ) loop

                        cPoint := Point_Lists.Element( Point_Pos );

                        -- print new segs
                        --Decomposition(Point, ABR);

                        Point_Lists.Next( Point_Pos );

                end loop;

                Svg_Footer;
        end if;

end Main;


