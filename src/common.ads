
with AVL;
with Ada.Containers.Doubly_Linked_Lists;


package Common is

        D_Pos : Float;

        type SimplePoint is record
                X : Float;
                Y : Float;
        end record;

        type Segment is array (Positive range 1 .. 3) of SimplePoint;

        package Segment_Lists is new Ada.Containers.Doubly_Linked_Lists ( Segment );
        --type Segment_List is Segment_Lists.List;
        -- type pSegments is access Segment_Lists.List;

        type Point is record
                Pt : SimplePoint;
                InSegs : Segment_Lists.List;
                OutSegs : Segment_Lists.List;
        end record;

        function "=" (P1, P2 : Point) return Boolean;



        function "<" (S1, S2 : Segment) return Boolean;
        -- function "<" (iS1, iS2 : Segment) return Boolean;
        function ">" (iS1, iS2 : Segment) return Boolean;

        package Arbre_Segments is new AVL(Segment, "<", ">");
        use Arbre_Segments;


        function "<" (P1, P2 : Point) return Boolean;
        function ">" (P1, P2 : Point) return Boolean;


        package Point_Lists is new Ada.Containers.Doubly_Linked_Lists ( Point, "=" );


        function Intersection(sPoint : SimplePoint ; cSegment : Segment) return SimplePoint;

        procedure Affiche_Segment(cSegment : Segment);

end Common;


