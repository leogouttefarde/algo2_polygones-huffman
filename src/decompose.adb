


package body Decompose is

        procedure Intersection(Segments : Segment_Lists.List ; X : Float ; cAVL : in out Arbre_Segments.Arbre) is
                Segment_Pos : Segment_Lists.Cursor;
                cSegment : Segment;
        begin

                Segment_Pos := Segment_Lists.First( Segments );

                while Segment_Lists.Has_Element( Segment_Pos ) loop

                        cSegment := Segment_Lists.Element( Segment_Pos );

                        if cSegment(1).X <= X and X <= cSegment(2).X then
                                cAVL := Arbre_Segments.Inserer(cAVL, cSegment);
                        end if;

                        Segment_Lists.Next( Segment_Pos );

                end loop;
        end;

        -- print new segs
        procedure Decomposition(cPoint : Point ; cAVL : in out Arbre_Segments.Arbre) is
        begin
                NULL;
        end;

end Decompose;


