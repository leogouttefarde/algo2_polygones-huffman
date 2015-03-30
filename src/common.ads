
with AVL;
with Ada.Containers.Doubly_Linked_Lists;
with Ada.Unchecked_Deallocation;


package Common is

        type SimplePoint is record
                X : Float;
                Y : Float;
        end record;

        type Segment is array (Positive range 1 .. 3) of SimplePoint;

        package Segment_Lists is new Ada.Containers.Doubly_Linked_Lists ( Segment );
        type pSegment is access Segment;

        procedure Liberer_Segment is new Ada.Unchecked_Deallocation (Object => Segment, Name => pSegment);


        type Point is record
                Pt : SimplePoint;
                InSegs : Segment_Lists.List;
                OutSegs : Segment_Lists.List;
        end record;


        function Egal (F1, F2 : Float) return Boolean;
        function Inf (F1, F2 : Float) return Boolean;

        function InfEgal (F1, F2 : Float) return Boolean;
        function Sup (F1, F2 : Float) return Boolean;


        function SupEgal (F1, F2 : Float) return Boolean;

        function "=" (P1, P2 : Point) return Boolean;



        function "<" (S1, S2 : Segment) return Boolean;
        function ">" (iS1, iS2 : Segment) return Boolean;

        package Arbre_Segments is new AVL(Segment, "<", ">");
        use Arbre_Segments;


        function "<" (P1, P2 : Point) return Boolean;
        function ">" (P1, P2 : Point) return Boolean;


        package Point_Lists is new Ada.Containers.Doubly_Linked_Lists ( Point, "=" );


        function Intersection(sPoint : SimplePoint ; cSegment : Segment) return SimplePoint;

        procedure Affiche_Segment(cSegment : Segment);

        function IsPoint (cSegment : Segment) return Boolean;

end Common;


