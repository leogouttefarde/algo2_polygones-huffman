


package body Decompose is

        -- requires Prev(2) = cPoint = Next(1)
        procedure Finish_Point (cPoint : in out Point ; Prev, Next : Segment) is
        begin
                if Prev(1).X < cPoint.Pt.X then
                        Segment_Lists.Append(cPoint.InSegs, Prev);
                else
                        Segment_Lists.Append(cPoint.OutSegs, Prev);
                end if;

                if Next(2).X < cPoint.Pt.X then
                        Segment_Lists.Append(cPoint.InSegs, Next);
                else
                        Segment_Lists.Append(cPoint.OutSegs, Next);
                end if;
        end;

        procedure Finish_Points (Points : in out Point_Lists.List ; Segments : Segment_Lists.List) is
                Point_Pos, FirstPos : Point_Lists.Cursor;
                Segment_Pos : Segment_Lists.Cursor;
                cPoint, First : Point;
                s1, sPrev, cSegment : Segment;
        begin
                FirstPos := Point_Lists.First( Points );
                First := Point_Lists.Element( FirstPos );
                Segment_Pos := Segment_Lists.First( Segments );
                s1 := Segment_Lists.Element( Segment_Pos );
                sPrev := s1;

                loop
                        Point_Lists.Next( Point_Pos );
                        Segment_Lists.Next( Segment_Pos );

                        exit when not (Point_Lists.Has_Element( Point_Pos )
                                and Segment_Lists.Has_Element( Segment_Pos ));


                        cSegment := Segment_Lists.Element( Segment_Pos );

                        cPoint := Point_Lists.Element( Point_Pos );

                        Finish_Point(cPoint, sPrev, cSegment);
                        Point_Lists.Replace_Element(Points, Point_Pos, cPoint);

                        sPrev := cSegment;
                end loop;

                Finish_Point(First, sPrev, s1);
                Point_Lists.Replace_Element(Points, FirstPos, First);
        end;

        function Generate_Segments (Points : in Point_Lists.List) return Segment_Lists.List is
                Segments : Segment_Lists.List;
                Point_Pos : Point_Lists.Cursor;
                cPoint : Point;
                First, Prev, Last : SimplePoint;
                sPoint : SimplePoint;
                cSegment : Segment;
        begin
                Point_Pos := Point_Lists.First( Points );
                cPoint := Point_Lists.Element( Point_Pos );
                First := cPoint.Pt;
                Prev := First;

                loop
                        Point_Lists.Next( Point_Pos );
                        exit when not Point_Lists.Has_Element( Point_Pos );

                        cPoint := Point_Lists.Element( Point_Pos );
                        sPoint := cPoint.Pt;

                        cSegment(1) := Prev;
                        cSegment(2) := sPoint;

                        Segment_Lists.Append( Segments, cSegment );

                        Prev := sPoint;
                end loop;

                Last := sPoint;


                cSegment(1) := Last;
                cSegment(2) := First;

                Segment_Lists.Append( Segments, cSegment );

                return Segments;
        end;

        procedure Intersection(Segments : Segment_Lists.List ; cPoint : Point ; cAVL : in out Arbre_Segments.Arbre) is
                Segment_Pos : Segment_Lists.Cursor;
                cSegment : Segment;
                D : Float := cPoint.Pt.X;
        begin
                Segment_Pos := Segment_Lists.First( Segments );

                while Segment_Lists.Has_Element( Segment_Pos ) loop

                        cSegment := Segment_Lists.Element( Segment_Pos );

                        if cSegment(1).X <= D and D <= cSegment(2).X then
                                cAVL := Arbre_Segments.Inserer(cAVL, cSegment);
                        end if;

                        Segment_Lists.Next( Segment_Pos );

                end loop;
        end;

        -- print new segs
        procedure Decomposition(cPoint : Point ; cAVL : in out Arbre_Segments.Arbre) is
                R : Boolean := False;
                cSegment : Segment;
                sPoint : SimplePoint := cPoint.Pt;
        begin
                if Segment_Lists.Length(cPoint.OutSegs) >= 2 then
                        R := True;
                        cSegment := ( sPoint, sPoint );
                        cAVL := Arbre_Segments.Inserer(cAVL, cSegment);
                end if;
        end;

end Decompose;


