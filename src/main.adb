
with Arbre;


procedure Main is

        type Point;

        type pPoint is access Point;

        type Segment is array (Positive range 1 .. 2) of pPoint;

        package Arbre_Segments is new Arbre(Segment);
        use Arbre_Segments;

        type ArraySegments is array (Positive range <>) of Segment;
        type pSegments is access ArraySegments;

        type Point is record
                X : Float;
                Y : Float;
                InSegs : pSegments;
                OutSegs : pSegments;
        end record;

        type ArrayPoints is array (Positive range <>) of Point;

        type pPoints is access ArrayPoints;


        Points : pPoints;
        Segments : Arbre_Segments.Noeud;
begin

        -- handle input arg for .in file

        -- parse .in

        -- beg svg
        -- print original polygon


        -- algo + print new segs


        -- end svg

        NULL;

end Main;


