
with Ada.Containers.Doubly_Linked_Lists;


package body Common is

        function "<" (S1, S2 : Segment) return Boolean is
        begin
                if S1(1) < S2(1) and S1(2) < S2(2) then
                        return True;
                end if;

                return False;
        end;

        function ">" (S1, S2 : Segment) return Boolean is
        begin
                if S1(1) > S2(1) and S1(2) > S2(2) then
                        return True;
                end if;

                return False;
        end;

        function "<" (P1, P2 : Point) return Boolean is
        begin
                if P1.X < P2.X then
                        return True;
                end if;

                return False;
        end;

        function ">" (P1, P2 : Point) return Boolean is
        begin
                if P1.X > P2.X then
                        return True;
                end if;

                return False;
        end;

        function "=" (P1, P2 : Point) return Boolean is
        begin
                if P1.X = P2.X then
                        return True;
                end if;

                return False;
        end;

        function Generate_Segments (Points : in Point_Lists.List) return Segment_Lists.List is
                Segments : Segment_Lists.List;
                Point_Pos : Point_Lists.Cursor;
                First, Prev, cPoint, Last : Point;
                cSegment : Segment;
        begin
                Point_Pos := Point_Lists.First( Points );
                First := Point_Lists.Element( Point_Pos );
                Prev := First;

                loop
                        Point_Lists.Next( Point_Pos );
                        exit when not Point_Lists.Has_Element( Point_Pos );

                        cPoint := Point_Lists.Element( Point_Pos );

                        cSegment(1) := Prev;
                        cSegment(2) := cPoint;

                        Segment_Lists.Append( Segments, cSegment );

                        Prev := cPoint;
                end loop;

                Last := cPoint;


                cSegment(1) := Last;
                cSegment(2) := First;

                Segment_Lists.Append( Segments, cSegment );

                return Segments;
        end;

end Common;


