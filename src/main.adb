
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
        Segments : pSegments;
        ABR : Arbre_Segments.Noeud;
begin

        -- handle input arg for .in file

        -- parse .in
        -- Points := parse_in();
        -- Segments := generate_segments(Points);

        -- beg svg
        -- print input as polygon

        -- algo + print new segs
        -- for Point in Points:
        --      algo1(Point, ABR)

        -- end svg

        NULL;

end Main;


