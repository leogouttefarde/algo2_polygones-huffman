
with Ada.Containers.Doubly_Linked_Lists;


package body Common is

        function "<" (S1, S2 : Segment) return Boolean is
                dx, dy : Float;
                X1, X2, Y1, Y2 : Float;
                A, B : Float;
                Im1, Im2 : Float;
        begin
                if S2(1).X < S2(2).X then
                        X1 := S2(1).X;
                        Y1 := S2(1).Y;

                        X2 := S2(2).X;
                        Y2 := S2(2).Y;
                else
                        X1 := S2(2).X;
                        Y1 := S2(2).Y;

                        X2 := S2(1).X;
                        Y2 := S2(1).Y;
                end if;

                dy := Y2 - Y1;
                dx := X2 - X1;

                A := dy / dx;
                B := Y1 - A * X1;

                Im1 := A * S1(1).X + B;
                Im2 := A * S1(2).X + B;

                if (Im1 >= S1(1).Y and Im2 > S1(2).Y) or
                        (Im1 > S1(1).Y and Im2 >= S1(2).Y) then
                        return True;
                end if;

                return False;
        end;

        function ">" (S1, S2 : Segment) return Boolean is
        begin
                if not (S1 < S2) then
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


