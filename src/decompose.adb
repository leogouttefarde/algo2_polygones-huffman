
with Ada.Text_IO;
use Ada.Text_IO;

package body Decompose is

        procedure Affiche_Point(sPoint : SimplePoint) is
        begin
                Put_Line( "("& Float'Image(sPoint.X)
                        & ", "& Float'Image(sPoint.Y)
                        & ")");
        end;

        procedure Affichage_AVL is new Arbre_Segments.Affichage ( Affiche_Segment );

        -- requires Prev(2) = cPoint = Next(1)
        procedure Finish_Point (cPoint : in out Point ; Prev, Next : Segment) is
        begin
                if InfEgal(Prev(1).X, cPoint.Pt.X) then
                        Segment_Lists.Append(cPoint.InSegs, Prev);
                elsif Sup(Prev(1).X, cPoint.Pt.X) then
                        Segment_Lists.Append(cPoint.OutSegs, Prev);
                end if;

                if Inf(Next(2).X, cPoint.Pt.X) then
                        Segment_Lists.Append(cPoint.InSegs, Next);
                elsif SupEgal(Next(2).X, cPoint.Pt.X) then
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
                Point_Pos := FirstPos;
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

        procedure Reconnect(sPoint : SimplePoint ; Up, Down : pSegment) is
                UpPoint, DownPoint : SimplePoint;
        begin
                if Up /= null then
                        UpPoint := Intersection(sPoint, Up.all);

                        if not IsPoint( (sPoint, UpPoint) ) then
                                Svg_Line(sPoint, UpPoint, Green);
                        end if;
                end if;

                if Down /= null then
                        DownPoint := Intersection(sPoint, Down.all);

                        if not IsPoint( (sPoint, DownPoint) ) then
                                Svg_Line(sPoint, DownPoint, Green);
                        end if;
                end if;
        end;

        DotIndex : Natural := 0;

        procedure Decomposition(cPoint : Point ; cAVL : in out Arbre_Segments.Arbre) is
                Rebroussement : Boolean := False;
                cSegment : Segment;
                sPoint : SimplePoint := cPoint.Pt;
                pNoeud : Arbre_Segments.Arbre;
                V_petit : Arbre_Segments.Arbre := null;
                V_Grand : Arbre_Segments.Arbre := null;
                S_petit : pSegment := null;
                S_Grand : pSegment := null;
                C_petits : Natural := 0;
                C_Grands : Natural := 0;
                Segment_Pos : Segment_Lists.Cursor;
        begin

                if Segment_Lists.Length(cPoint.OutSegs) = 2 then
                        Rebroussement := True;
                        cSegment := ( sPoint, sPoint );

                        pNoeud := Arbre_Segments.Inserer(cAVL, cSegment);

                        Noeuds_Voisins(pNoeud, V_petit, V_Grand);
                        Compte_Position(pNoeud, C_petits, C_Grands);

                        if V_petit /= null then

                                if S_petit /= null then
                                        Liberer_Segment(S_petit);
                                end if;

                                S_petit := new Segment'(V_petit.C);
                        else
                                S_petit := null;
                        end if;

                        if V_Grand /= null then

                                if S_Grand /= null then
                                        Liberer_Segment(S_Grand);
                                end if;

                                S_Grand := new Segment'(V_Grand.C);
                        else
                                S_Grand := null;
                        end if;



                        cAVL := Arbre_Segments.Supprimer_Noeud(cAVL, cSegment);

                end if;



                Segment_Pos := Segment_Lists.First( cPoint.InSegs );
                while Segment_Lists.Has_Element( Segment_Pos ) loop

                        cSegment := Segment_Lists.Element( Segment_Pos );
                        cAVL := Arbre_Segments.Supprimer_Noeud(cAVL, cSegment);

                        Segment_Lists.Next( Segment_Pos );

                end loop;


                Segment_Pos := Segment_Lists.First( cPoint.OutSegs );
                while Segment_Lists.Has_Element( Segment_Pos ) loop

                        cSegment := Segment_Lists.Element( Segment_Pos );
                        pNoeud := Arbre_Segments.Inserer(cAVL, cSegment);

                        Segment_Lists.Next( Segment_Pos );

                end loop;


                --Arbre_Segments.Export("AVL_dot/AVL" & Natural'Image(DotIndex) & ".dot", cAVL);
                DotIndex := DotIndex + 1;


                if Segment_Lists.Length(cPoint.InSegs) = 2 then
                        Rebroussement := True;
                        cSegment := ( sPoint, sPoint );
                        pNoeud := Arbre_Segments.Inserer(cAVL, cSegment);

                        Noeuds_Voisins(pNoeud, V_petit, V_Grand);
                        Compte_Position(pNoeud, C_petits, C_Grands);

                        if V_petit /= null then

                                if S_petit /= null then
                                        Liberer_Segment(S_petit);
                                end if;

                                S_petit := new Segment'(V_petit.C);
                        else
                                S_petit := null;
                        end if;

                        if V_Grand /= null then

                                if S_Grand /= null then
                                        Liberer_Segment(S_Grand);
                                end if;

                                S_Grand := new Segment'(V_Grand.C);
                        else
                                S_Grand := null;
                        end if;


                        cAVL := Arbre_Segments.Supprimer_Noeud(cAVL, cSegment);

                end if;

                if Rebroussement and ((C_petits mod 2) = 1 or (C_Grands mod 2) = 1) then

                        Reconnect(sPoint, S_petit, S_Grand);

                end if;


                if S_petit /= null then
                        Liberer_Segment(S_petit);
                end if;

                if S_Grand /= null then
                        Liberer_Segment(S_Grand);
                end if;
        end;

end Decompose;


