
with Ada.Containers.Doubly_Linked_Lists;


package body Common is

        function "<" (S1, S2 : Segment) return Boolean is
        begin
                if (S1(1).Y < S2(1).Y and S1(2).Y <= S2(2).Y) or
                        (S1(1).Y <= S2(1).Y and S1(2).Y < S2(2).Y) then
                        return True;
                end if;

                return False;
        end;

        function ">" (S1, S2 : Segment) return Boolean is
        begin
                if (S1(1).Y > S2(1).Y and S1(2).Y >= S2(2).Y) or
                        (S1(1).Y >= S2(1).Y and S1(2).Y > S2(2).Y) then
                        return True;
                end if;

                return False;
        end;

        function "<" (P1, P2 : Point) return Boolean is
        begin
                if P1.Pt.X < P2.Pt.X then
                        return True;
                end if;

                return False;
        end;

        function ">" (P1, P2 : Point) return Boolean is
        begin
                if P1.Pt.X > P2.Pt.X then
                        return True;
                end if;

                return False;
        end;

        function "=" (P1, P2 : Point) return Boolean is
        begin
                if P1.Pt.X = P2.Pt.X then
                        return True;
                end if;

                return False;
        end;

end Common;


