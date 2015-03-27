
with Ada.Text_IO;
use Ada.Text_IO;

package body Decompose is

        -- requires Prev(2) = cPoint = Next(1)
        procedure Finish_Point (cPoint : in out Point ; Prev, Next : Segment) is
        begin
                if Prev(1).X < cPoint.Pt.X then
                        -- Put_Line("InSegs++ Prev"); OK 1
                        Segment_Lists.Append(cPoint.InSegs, Prev);
                else
                        -- Put_Line("OutSegs++ Prev");
                        Segment_Lists.Append(cPoint.OutSegs, Prev);
                end if;

                if Next(2).X < cPoint.Pt.X then
                        -- Put_Line("InSegs++ Next");
                        Segment_Lists.Append(cPoint.InSegs, Next);
                else
                        -- Put_Line("OutSegs++ Next");
                        Segment_Lists.Append(cPoint.OutSegs, Next);
                end if;
                        -- Put_Line("Finish_Point_End");
        end;

        procedure Finish_Points (Points : in out Point_Lists.List ; Segments : Segment_Lists.List) is
                Point_Pos, FirstPos : Point_Lists.Cursor;
                Segment_Pos : Segment_Lists.Cursor;
                cPoint, First : Point;
                s1, sPrev, cSegment : Segment;
        begin
                FirstPos := Point_Lists.First( Points );
                Point_Pos := FirstPos;
                First := Point_Lists.Element( FirstPos );
                Segment_Pos := Segment_Lists.First( Segments );
                s1 := Segment_Lists.Element( Segment_Pos );
                sPrev := s1;
-- Put_Line("WWWW"); OK 1
-- if Point_Lists.Has_Element( Point_Pos ) then
-- Put_Line("Point_Pos");
-- end if;
-- Put_Line("count "& count_type'image(Point_Lists.Length(Points)) );
-- if Segment_Lists.Has_Element( Segment_Pos ) then
-- Put_Line("Segment_Pos");
-- end if;
                        -- cSegment := Segment_Lists.Element( Segment_Pos );
                        -- Put_Line( "seg(1).X = "& Float'Image(cSegment(1).X)
                        --         & "    seg(1).Y = "& Float'Image(cSegment(1).Y)
                        --         & "    seg(2).X = "& Float'Image(cSegment(2).X)
                        --         & "    seg(2).Y = "& Float'Image(cSegment(2).Y));
                loop
                        Point_Lists.Next( Point_Pos );
                        Segment_Lists.Next( Segment_Pos );

                        exit when not (Point_Lists.Has_Element( Point_Pos )
                                and Segment_Lists.Has_Element( Segment_Pos ));


                        cSegment := Segment_Lists.Element( Segment_Pos );

                        cPoint := Point_Lists.Element( Point_Pos );

                        Finish_Point(cPoint, sPrev, cSegment);
                        Point_Lists.Replace_Element(Points, Point_Pos, cPoint);

                        -- Put_Line( "seg(1).X = "& Float'Image(cSegment(1).X)
                        --         & "    seg(1).Y = "& Float'Image(cSegment(1).Y)
                        --         & "    seg(2).X = "& Float'Image(cSegment(2).X)
                        --         & "    seg(2).Y = "& Float'Image(cSegment(2).Y));
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

        function Intersect(X : Float ; cSegment : Segment) return SimplePoint is
                Inter : SimplePoint;
                dx, dy : Float;
                X1, X2, Y1, Y2 : Float;
                A, B : Float;
        begin
                Inter.X := X;

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

                Inter.Y := A * X + B;

                -- old
                -- dy := cSegment(2).Y - cSegment(1).Y;
                -- dx := cSegment(2).X - cSegment(1).X;
                --Inter.Y := Sqrt( dx**2 + dy**2 );


                -- Put_Line("X1 = " & Float'Image(X1));
                -- Put_Line("X2 = " & Float'Image(X2));
                -- Put_Line("Y1 = " & Float'Image(Y1));
                -- Put_Line("Y2 = " & Float'Image(Y2));
                -- Put_Line("dx = " & Float'Image(dx));
                -- Put_Line("dy = " & Float'Image(dy));
                -- Put_Line("A = " & Float'Image(A));
                -- Put_Line("B = " & Float'Image(B));
                -- Put_Line("Y = " & Float'Image(Inter.Y));

                return Inter;
        end;

        procedure Reconnect(sPoint : SimplePoint ; Down, Up : Arbre_Segments.Arbre) is
                downPoint, upPoint : SimplePoint;
        begin
                if Down /= null then
                        -- Put_Line("DOWN");
                        downPoint := Intersect(sPoint.X, Down.C);
                        Svg_Line(sPoint, downPoint, Green);
                end if;

                if Up /= null then
                        -- Put_Line("UP");
                        upPoint := Intersect(sPoint.X, Up.C);
                        Svg_Line(sPoint, upPoint, Green);
                end if;
        end;

        procedure Decomposition(cPoint : Point ; cAVL : in out Arbre_Segments.Arbre) is
                R : Boolean := False;
                cSegment : Segment;
                sPoint : SimplePoint := cPoint.Pt;
                pNoeud : Arbre_Segments.Arbre;
                V_petit, V_Grand : Arbre_Segments.Arbre;
                C_petits, C_Grands : Natural;
                Segment_Pos : Segment_Lists.Cursor;
        begin
                -- Put_Line("Length(OutSegs) = "&Count_Type'image(Segment_Lists.Length(cPoint.OutSegs)));
                if Segment_Lists.Length(cPoint.OutSegs) >= 2 then
                        -- Put_Line("check beg R");
                        R := True;
                        cSegment := ( sPoint, sPoint );
                        pNoeud := Arbre_Segments.Inserer(cAVL, cSegment);

                        Noeuds_Voisins(pNoeud, V_petit, V_Grand);
                        Compte_Position(pNoeud, C_petits, C_Grands);

                        cAVL := Arbre_Segments.Supprimer_Noeud(pNoeud, cSegment);
                end if;


                Segment_Pos := Segment_Lists.First( cPoint.InSegs );
                while Segment_Lists.Has_Element( Segment_Pos ) loop

                        -- Put_Line("Del");
                        cSegment := Segment_Lists.Element( Segment_Pos );
                        cAVL := Arbre_Segments.Supprimer_Noeud(cAVL, cSegment);

                        Segment_Lists.Next( Segment_Pos );

                end loop;

                Segment_Pos := Segment_Lists.First( cPoint.OutSegs );
                while Segment_Lists.Has_Element( Segment_Pos ) loop

                        -- Put_Line("Add");
                        cSegment := Segment_Lists.Element( Segment_Pos );
                        cAVL := Arbre_Segments.Inserer(cAVL, cSegment);

                        Segment_Lists.Next( Segment_Pos );

                end loop;


                -- Put_Line("Length(InSegs) = "&Count_Type'image(Segment_Lists.Length(cPoint.InSegs)));
                if Segment_Lists.Length(cPoint.InSegs) >= 2 then
                        -- Put_Line("check end R");
                        R := True;
                        cSegment := ( sPoint, sPoint );
                        pNoeud := Arbre_Segments.Inserer(cAVL, cSegment);

                        Noeuds_Voisins(pNoeud, V_petit, V_Grand);
                        Compte_Position(pNoeud, C_petits, C_Grands);

                        cAVL := Arbre_Segments.Supprimer_Noeud(pNoeud, cSegment);
                end if;

                -- if cAVL = null then
                        -- Put_Line("NULL");
                -- end if;

                -- if R then
                        -- Put_Line("R True");
                -- end if;
                if R and ((C_petits mod 2) = 1 or (C_Grands mod 2) = 1) then
                        Reconnect(sPoint, V_petit, V_Grand);
                        -- Put_Line("RECONNECT !");
                -- else
                        -- Put_Line("No reco");
                end if;
        end;

end Decompose;


