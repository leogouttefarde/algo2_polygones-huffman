
with Arbre;
with Ada.Command_Line; use Ada.Command_Line;
with Ada.Text_IO; use Ada.Text_IO;


procedure Main is

        type Point;

        type pPoint is access Point;

        type Segment is array (Positive range 1 .. 2) of pPoint;

        type ArraySegments is array (Positive range <>) of Segment;
        type pSegments is access ArraySegments;

        type Point is record
                X : Float;
                Y : Float;
                InSegs : pSegments;
                OutSegs : pSegments;
        end record;

        function Compare (X, Y: Segment) return Boolean is
        begin
                return False;
        end;

        package Arbre_Segments is new Arbre(Segment, Compare);
        use Arbre_Segments;

        type ArrayPoints is array (Positive range <>) of Point;

        type pPoints is access ArrayPoints;


        Points : pPoints;
        Segments : pSegments;
        ABR : Arbre_Segments.Noeud;
begin

        if Argument_Count < 1 then
                Put_Line(Standard_Error, "Usage : " & Command_Name & " polygon.in");
                Set_Exit_Status(Failure);
        --else
                -- parse .in
                -- Points := parse_in();
                -- Segments := generate_segments(Points);

                -- beg svg
                -- print input as polygon

                -- algo + print new segs
                -- for Point in Points:
                --      algo1(Point, ABR)

                -- end svg
        end if;

end Main;


