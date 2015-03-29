
with Ada.Text_IO;
use Ada.Text_IO;
with Common; use Common;
with Parseur; use Parseur;
with Decompose; use Decompose;



procedure Test_Comp is

        Points : Point_Lists.List;
        Segments : Segment_Lists.List;
        Segment_Pos : Segment_Lists.Cursor;
        s2, s4 : Segment;

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


        if s2 = s4 then
                Put_Line("s2 = s4");
        end if;


        -- Tests de respect de l'ordre des comparaisons
        if s4 < s2 then
                Put_Line("s4 < s2");
        end if;

        if s4 > s2 then
                Put_Line("s4 > s2");
        end if;


        if s2 < s4 then
                Put_Line("s2 < s4");
        end if;

        if s2 > s4 then
                Put_Line("s2 > s4");
        end if;

end;
