
with Ada.Containers.Doubly_Linked_Lists;
with Ada.Text_IO;
use Ada.Text_IO;


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

        function Intersection(sPoint : SimplePoint ; cSegment : Segment) return SimplePoint is
                Inter : SimplePoint;
                dx, dy : Float;
                X1, X2, Y1, Y2 : Float;
                A, B : Float;
                X : Float := sPoint.X;
                Y : Float;
        begin
                Inter.X := X;

                if IsPoint(cSegment) then
                        -- Hack, pas d'intersection dans ce cas (ne devrait jamais arriver)
                        Y := cSegment(1).Y;
                        --Put_Line("Erreur");

                        return Inter;
                end if;


                if cSegment(1).X < cSegment(2).X then
                        X1 := cSegment(1).X;
                        Y1 := cSegment(1).Y;

                        X2 := cSegment(2).X;
                        Y2 := cSegment(2).Y;
                else
                        X1 := cSegment(2).X;
                        Y1 := cSegment(2).Y;

                        X2 := cSegment(1).X;
                        Y2 := cSegment(1).Y;
                end if;

                dy := Y2 - Y1;
                dx := X2 - X1;

                A := dy / dx;
                B := Y1 - A * X1;


                if dx = 0.0 then
                        if X = X1 then
                                Y := sPoint.Y;
                        else
                                -- Hack, pas d'intersection dans ce cas (ne devrait jamais arriver)
                                Y := sPoint.Y;
                                --Put_Line("Erreur");
                        end if;
                else
                        Y := A * X + B;
                end if;

                -- debug
                -- Put_Line("X1 = " & Float'Image(X1));
                -- Put_Line("X2 = " & Float'Image(X2));
                -- Put_Line("Y1 = " & Float'Image(Y1));
                -- Put_Line("Y2 = " & Float'Image(Y2));
                -- Put_Line("dx = " & Float'Image(dx));
                -- Put_Line("dy = " & Float'Image(dy));
                -- Put_Line("A = " & Float'Image(A));
                -- Put_Line("B = " & Float'Image(B));
                -- Put_Line("Y = " & Float'Image(Inter.Y));
                
                Inter.Y := Y;

                return Inter;
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

        -- function ">" (S1, S2 : Segment) return Boolean is
        --         P1, P2 : SimplePoint;
        -- begin
        --         P1 := Intersection(D_Pos, S1);
        --         P2 := Intersection(D_Pos, S2);

        --         if P1.X > P2.X then
        --                 return True;
        --         end if;

        --         return False;
        -- end;

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

        -- function "<" (S1, S2 : Segment) return Boolean is
        -- begin
        --         if not (S1 > S2) and not (S1 = S2) then
        --                 return True;
        --         end if;

        --         return False;
        -- end;

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


