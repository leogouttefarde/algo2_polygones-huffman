
with Ada.Containers.Doubly_Linked_Lists;


package Common is

        type Point is record
                X : Float;
                Y : Float;
        end record;

        function "=" (P1, P2 : Point) return Boolean;

        type Segment is array (Positive range 1 .. 2) of Point;

        package Segment_Lists is new Ada.Containers.Doubly_Linked_Lists ( Segment );
        --type Segment_List is Segment_Lists.List;
        --type pSegments is access Segment_Lists.List;

        type ExtPoint is record
                Pt : Point;
                InSegs : Segment_Lists.List;
                OutSegs : Segment_Lists.List;
        end record;



        function "<" (S1, S2 : Segment) return Boolean;
        function ">" (S1, S2 : Segment) return Boolean;

        function "<" (P1, P2 : Point) return Boolean;
        function ">" (P1, P2 : Point) return Boolean;


        package Point_Lists is new Ada.Containers.Doubly_Linked_Lists ( Point, "=" );

        function Generate_Segments (Points : in Point_Lists.List) return Segment_Lists.List;

end Common;


