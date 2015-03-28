
with Ada.Text_IO;
use Ada.Text_IO;
with Common; use Common;
with Parseur; use Parseur;
with Decompose; use Decompose;



procedure Test_Comp is

procedure Affiche_Segment(cSegment : Segment) is
begin
        Put_Line( Float'Image(cSegment(3).X)
                & "  S1 = ("& Float'Image(cSegment(1).X)
                & ", "& Float'Image(cSegment(1).Y)
                & ")    S2 = ("& Float'Image(cSegment(2).X)
                & ", "& Float'Image(cSegment(2).Y)
                & ")");
end;
        Points : Point_Lists.List;
        Segments : Segment_Lists.List;
        s2, s4 : Segment;
        Segment_Pos : Segment_Lists.Cursor;
begin
        Lire_Polygone("tests/5.in", Points);
        Segments := Generate_Segments(Points);

        -- s1
        Segment_Pos := Segment_Lists.First( Segments );
        Segment_Lists.Next( Segment_Pos );

        s2 := Segment_Lists.Element( Segment_Pos );

        Segment_Lists.Next( Segment_Pos );
        Segment_Lists.Next( Segment_Pos );

        s4 := Segment_Lists.Element( Segment_Pos );

        Affiche_Segment(s2);
        Affiche_Segment(s4);
        New_Line;
        New_Line;
        New_Line;

        if s4 < s2 then
                Put_Line("s4 < s2");
        end if;

        if s4 > s2 then
                Put_Line("s4 > s2");
        end if;


        -- Test ordre
        if s2 < s4 then
                Put_Line("s2 < s4");
        end if;

        if s2 > s4 then
                Put_Line("s2 > s4");
        end if;


        if s2 = s4 then
                Put_Line("s2 = s4");
        end if;

        -- cSegment := Segment_Lists.Element( Segment_Pos );
        -- Put_Line("Del");
        -- Affiche_Segment(cSegment);
        -- New_Line;
        -- cAVL := Arbre_Segments.Supprimer_Noeud(cAVL, cSegment);

        -- Segment_Lists.Next( Segment_Pos );

end;
