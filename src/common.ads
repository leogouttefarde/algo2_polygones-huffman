
with Ada.Containers.Doubly_Linked_Lists;


package Common is

        type Point is record
                X : Float;
                Y : Float;
        end record;

        type Segment is array (Positive range 1 .. 2) of Point;

        package Segment_Lists is new Ada.Containers.Doubly_Linked_Lists ( Segment );
        --type Segment_List is Segment_Lists.List;
        --type pSegments is access Segment_Lists.List;

        type ExtPoint is record
                Pt : Point;
                InSegs : Segment_Lists.List;
                OutSegs : Segment_Lists.List;
        end record;

        package Point_Lists is new Ada.Containers.Doubly_Linked_Lists ( Point );

end Common;


