
with Ada.Containers.Doubly_Linked_Lists;
with Ada.Text_IO;
use Ada.Text_IO;


package body Common is

        procedure Affiche_Segment(cSegment : Segment) is
        begin
                Put_Line( Float'Image(cSegment(3).X)
                        & "  S1 = ("& Float'Image(cSegment(1).X)
                        & ", "& Float'Image(cSegment(1).Y)
                        & ")    S2 = ("& Float'Image(cSegment(2).X)
                        & ", "& Float'Image(cSegment(2).Y)
                        & ")");
        end;

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


        F_Epsilon : Float := 0.0001;

        function Egal (F1, F2 : Float) return Boolean is
                Diff : Float := F1 - F2;
                Result : Boolean := False;
        begin
                if Diff < 0.0 then
                        Diff := - Diff;
                end if;

                if Diff < F_Epsilon then
                        Result := True;
                end if;

                return Result;
        end;

        function Inf (F1, F2 : Float) return Boolean is
                Diff : Float := F2 - F1;
                Result : Boolean := False;
        begin
                if Diff > 0.0 and Diff >= F_Epsilon then
                        Result := True;
                end if;

                return Result;
        end;

        function InfEgal (F1, F2 : Float) return Boolean is
                Result : Boolean := False;
        begin
                if Egal(F1, F2) or Inf(F1, F2) then
                        Result := True;
                end if;

                return Result;
        end;

        function Sup (F1, F2 : Float) return Boolean is
                Diff : Float := F1 - F2;
                Result : Boolean := False;
        begin
                if Diff > 0.0 and Diff >= F_Epsilon then
                        Result := True;
                end if;

                return Result;
        end;

        function SupEgal (F1, F2 : Float) return Boolean is
                Result : Boolean := False;
        begin
                if Egal(F1, F2) or Sup(F1, F2) then
                        Result := True;
                end if;

                return Result;
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

        -- function "<" (iS1, iS2 : Segment) return Boolean is
        --         dx, dy : Float;
        --         X1, X2, Y1, Y2 : Float;
        --         A, B : Float;
        --         Im1, Im2 : Float;
        --         S1 : Segment := iS1;
        --         S2 : Segment := iS2;

        --         Inverse : Boolean := False;
        -- begin
        --         if IsPoint(iS2) then
        --                 S2 := iS1;
        --                 S1 := iS2;

        --                 Inverse := True;
        --         end if;

        --         if S2(1).X < S2(2).X then
        --                 X1 := S2(1).X;
        --                 Y1 := S2(1).Y;

        --                 X2 := S2(2).X;
        --                 Y2 := S2(2).Y;
        --         else
        --                 X1 := S2(2).X;
        --                 Y1 := S2(2).Y;

        --                 X2 := S2(1).X;
        --                 Y2 := S2(1).Y;
        --         end if;

        --         dy := Y2 - Y1;
        --         dx := X2 - X1;

        --         A := dy / dx;
        --         B := Y1 - A * X1;

        --         Im1 := A * S1(1).X + B;
        --         Im2 := A * S1(2).X + B;

        --         if Inverse then
        --                 if (Im1 <= S1(1).Y and Im2 < S1(2).Y) or
        --                         (Im1 < S1(1).Y and Im2 <= S1(2).Y) then
        --                         return True;
        --                 end if;

        --         elsif (Im1 >= S1(1).Y and Im2 > S1(2).Y) or
        --                 (Im1 > S1(1).Y and Im2 >= S1(2).Y) then
        --                 return True;
        --         end if;

        --         return False;
        -- end;

        function Ordonner_Segment (cSeg : Segment) return Segment is
                oSeg : Segment := cSeg;
        begin
                if cSeg(2).X < cSeg(1).X then
                        oSeg(1) := cSeg(2);
                        oSeg(2) := cSeg(1);
                end if;

                return oSeg;
        end;

        function ">" (iS1, iS2 : Segment) return Boolean is
                S1, S2 : Segment;
                pS1, pS2 : Segment;
                Inverse : Boolean := False;
                IsPointS1, IsPointS2 : Boolean;
                Inter : SimplePoint;
        begin
                if iS1 = iS2 then
                        return False;
                end if;

                -- Affiche_Segment(iS1);
                -- Affiche_Segment(iS2);
                -- New_Line;
                -- New_Line;

                IsPointS1 := IsPoint(iS1);
                IsPointS2 := IsPoint(iS2);

                if IsPointS1 and IsPointS2 then
                        if iS1(1).Y > iS2(1).Y then
                                return True;
                        else
                                return False;
                        end if;
                elsif IsPointS1 and not IsPointS2 then
                        Inter := Intersection(iS1(1), iS2);

                        if Inter.Y < iS1(1).Y then
                                return True;
                        else
                                return False;
                        end if;
                elsif not IsPointS1 and IsPointS2 then
                        Inter := Intersection(iS2(1), iS1);

                        if Inter.Y > iS2(1).Y then
                                return True;
                        else
                                return False;
                        end if;
                end if;

                S1 := Ordonner_Segment(iS1);
                S2 := Ordonner_Segment(iS2);

                pS1 := S1;
                pS2 := S2;

                -- On s'assure de choisir le second segment pour S1
                if S1(1).X < S2(1).X then
                        pS1 := S2;
                        pS2 := S1;

                        Inverse := True;
                end if;

                pS2(1) := Intersection(pS1(1), pS2);

                if pS1(2).X > pS2(2).X then
                        pS1(2) := Intersection(pS2(2), pS1);
                else
                        pS2(2) := Intersection(pS1(2), pS2);
                end if;

                -- Affiche_Segment(pS1);
                -- Affiche_Segment(pS2);
                -- New_Line;
                -- New_Line;

                if Inverse then
                        -- Put_Line("ini");
                        -- if (pS1(1).Y < pS2(1).Y) then
                        -- Put_Line("pS1(1).Y < pS2(1).Y");
                        -- end if;
                        -- if (pS1(2).Y <= pS2(2).Y) then
                        -- Put_Line("pS1(2).Y <= pS2(2).Y");
                        -- else
                        -- Put_Line("pS1(2).Y > pS2(2).Y");
                        -- Put_Line("pS1(2).Y = "& Float'Image(pS1(2).Y) &"  > pS2(2).Y"& Float'Image(pS2(2).Y));
                        -- Put_Line("pS1(2).Y - pS2(2).Y = "& Float'Image(pS1(2).Y - pS2(2).Y));
                        -- end if;
                        if (Inf(pS1(1).Y, pS2(1).Y) and InfEgal(pS1(2).Y, pS2(2).Y)) or
                                (InfEgal(pS1(1).Y, pS2(1).Y) and Inf(pS1(2).Y, pS2(2).Y)) then
                        -- Put_Line("first");
                                return True;
                        end if;

                elsif (Sup(pS1(1).Y, pS2(1).Y) and SupEgal(pS1(2).Y, pS2(2).Y)) or
                        (SupEgal(pS1(1).Y, pS2(1).Y) and Sup(pS1(2).Y, pS2(2).Y)) then
                        -- Put_Line("sec");
                                return True;
                -- else
                --         Put_Line("sec");

                --         if (pS1(1).Y > pS2(1).Y and pS1(2).Y >= pS2(2).Y) then
                --         Put_Line("1");
                --                 return True;
                --         end if;

                --         if pS1(2).Y > pS2(2).Y then
                --         Put_Line("pS1(2).Y = "& Float'Image(pS1(2).Y) &"  > pS2(2).Y"& Float'Image(pS2(2).Y));
                --         >> (4.00000E+00 > 4.00000E+00) donne True en Ada içi ...
                --         end if;
                --         if (pS1(1).Y >= pS2(1).Y and pS1(2).Y > pS2(2).Y) then
                --         Put_Line("2");
                --                 return True;
                --         end if;
                end if;

                        -- Put_Line("false");
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

        -- function ">" (S1, S2 : Segment) return Boolean is
        -- begin
        --         if not (S1 < S2) and not (S1 = S2) then
        --                 return True;
        --         end if;

        --         return False;
        -- end;

        function "<" (S1, S2 : Segment) return Boolean is
        begin
                if not (S1 > S2) and not (S1 = S2) then
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


