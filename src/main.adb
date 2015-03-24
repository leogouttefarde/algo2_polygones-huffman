
with Arbre;
with Ada.Command_Line; use Ada.Command_Line;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Containers.Doubly_Linked_Lists;


procedure Main is

        type Point;

        type pPoint is access Point;

        type Segment is array (Positive range 1 .. 2) of pPoint;

        package Segment_Lists is new Ada.Containers.Doubly_Linked_Lists ( Segment );
        --type Segment_List is Segment_Lists.List;
        --type pSegments is access Segment_Lists.List;

        type Point is record
                X : Float;
                Y : Float;
                InSegs : Segment_Lists.List;
                OutSegs : Segment_Lists.List;
        end record;

        function Compare (X, Y: Segment) return Boolean is
        begin
                return False;
        end;

        package Arbre_Segments is new Arbre(Segment, Compare);
        use Arbre_Segments;

        type ArrayPoints is array (Positive range <>) of Point;

        type pPoints is access ArrayPoints;

        package Point_Lists is new Ada.Containers.Doubly_Linked_Lists ( Point );
        --type Point_List is Point_Lists.List;
        --type pPoint is access Point_Lists.List;


        Points : Point_Lists.List;
        Segments : Segment_Lists.List;
        ABR : Noeud;
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


