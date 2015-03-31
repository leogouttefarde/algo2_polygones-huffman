
with Ada.Text_IO;
use Ada.Text_IO;
with Common; use Common;
with Parseur; use Parseur;
with Decompose; use Decompose;



procedure Test_Comp is

        Points, Points4, Points6 : Point_Lists.List;
        Segments, Segments4, Segments6 : Segment_Lists.List;
        Segment_Pos : Segment_Lists.Cursor;
        s2, s4, s7, s1 : Segment;

begin
        Lire_Polygone("tests/4.in", Points4);
        Lire_Polygone("tests/5.in", Points);
        Lire_Polygone("tests/6.in", Points6);

        Segments := Generate_Segments(Points);
        Segments4 := Generate_Segments(Points4);
        Segments6 := Generate_Segments(Points6);

        -- s1
        Segment_Pos := Segment_Lists.First( Segments );
        Segment_Lists.Next( Segment_Pos );

        s2 := Segment_Lists.Element( Segment_Pos );

        Segment_Lists.Next( Segment_Pos );
        Segment_Lists.Next( Segment_Pos );

        s4 := Segment_Lists.Element( Segment_Pos );


        if s2 = s4 then
                Put_Line("s2 = s4 Erreur");
        end if;


        -- Tests de respect de l'ordre des comparaisons
        if s4 < s2 then
                Put_Line("s4 < s2 Erreur");
        end if;

        if s4 > s2 then
                Put_Line("s4 > s2 OK");
        end if;


        if s2 < s4 then
                Put_Line("s2 < s4 OK");
        end if;

        if s2 > s4 then
                Put_Line("s2 > s4 Erreur");
        end if;



        Segment_Pos := Segment_Lists.First( Segments4 );

        for i in 2 .. 7 loop
                Segment_Lists.Next( Segment_Pos );
        end loop;

        s7 := Segment_Lists.Element( Segment_Pos );


        if s7 = s7 then
                Put_Line("s7 = s7 OK");
        end if;


        -- Tests du respect de l'ordre des comparaisons
        if s7 < s7 then
                Put_Line("s7 < s7 Erreur");
        end if;

        if s7 > s7 then
                Put_Line("s7 > s7 Erreur");
        end if;



        Segment_Pos := Segment_Lists.First( Segments6 );

        s1 := Segment_Lists.Element( Segment_Pos );
        Segment_Lists.Next( Segment_Pos );

        s2 := Segment_Lists.Element( Segment_Pos );




        if s2 = s1 then
                Put_Line("s2 = s1");
        end if;


        -- Tests du respect de l'ordre des comparaisons
        if s1 < s2 then
                Put_Line("s1 < s2 Erreur");
        end if;

        if s1 > s2 then
                Put_Line("s1 > s2 OK");
        end if;


        if s2 < s1 then
                Put_Line("s2 < s1 OK");
        end if;

        if s2 > s1 then
                Put_Line("s2 > s1 Erreur");
        end if;

end;
