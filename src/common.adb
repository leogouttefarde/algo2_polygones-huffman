
with Ada.Containers.Doubly_Linked_Lists;


package body Common is

        function "=" (P1, P2 : SimplePoint) return Boolean is
        begin
                if P1.X = P2.X and P1.Y = P2.Y then
                        return True;
                end if;

                return False;
        end;

        function IsPoint (cSegment : Segment) return Boolean is
        begin
                if cSegment(1) = cSegment(2) then
                        return True;
                end if;

                return False;
        end;

        function "<" (iS1, iS2 : Segment) return Boolean is
                dx, dy : Float;
                X1, X2, Y1, Y2 : Float;
                A, B : Float;
                Im1, Im2 : Float;
                S1 : Segment := iS1;
                S2 : Segment := iS2;

                Inverse : Boolean := False;
        begin
                if IsPoint(iS2) then
                        S2 := iS1;
                        S1 := iS2;

                        Inverse := True;
                end if;

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

                if Inverse then
                        if (Im1 <= S1(1).Y and Im2 < S1(2).Y) or
                                (Im1 < S1(1).Y and Im2 <= S1(2).Y) then
                                return True;
                        end if;

                elsif (Im1 >= S1(1).Y and Im2 > S1(2).Y) or
                        (Im1 > S1(1).Y and Im2 >= S1(2).Y) then
                        return True;
                end if;

                return False;
        end;

        function "=" (S1, S2 : Segment) return Boolean is
        begin
                if (S1(1) = S2(1) and S1(2) = S2(2)) or
                        (S1(2) = S2(1) and S1(1) = S2(2)) then
                        return True;
                end if;

                return False;
        end;

        function ">" (S1, S2 : Segment) return Boolean is
        begin
                if not (S1 < S2) and not (S1 = S2) then
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


