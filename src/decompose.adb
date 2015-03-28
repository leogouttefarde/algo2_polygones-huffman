
with Ada.Text_IO;
use Ada.Text_IO;

package body Decompose is

        procedure Affiche_Point(sPoint : SimplePoint) is
        begin
                Put_Line( "("& Float'Image(sPoint.X)
                        & ", "& Float'Image(sPoint.Y)
                        & ")");
        end;

        procedure Affiche_Segment(cSegment : Segment) is
        begin
                Put_Line( Float'Image(cSegment(3).X)
                        & "  S1 = ("& Float'Image(cSegment(1).X)
                        & ", "& Float'Image(cSegment(1).Y)
                        & ")    S2 = ("& Float'Image(cSegment(2).X)
                        & ", "& Float'Image(cSegment(2).Y)
                        & ")");
        end;

        procedure Affichage_AVL is new Arbre_Segments.Affichage ( Affiche_Segment );

        -- requires Prev(2) = cPoint = Next(1)
        procedure Finish_Point (cPoint : in out Point ; Prev, Next : Segment) is
        begin
                -- new_line;
                -- new_line;
                -- Affiche_Point(cPoint.Pt);
                -- new_line;
                -- Affiche_Segment(Prev);
                -- Affiche_Segment(Next);
                -- new_line;
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
                i : Float := 1.01;
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
                        cSegment(3).X := i;

                        Segment_Lists.Append( Segments, cSegment );
                        -- Affiche_Segment(cSegment);

                        Prev := sPoint;
                        i := i + 1.0;
                end loop;

                Last := sPoint;


                cSegment(1) := Last;
                cSegment(2) := First;
                cSegment(3).X := i;
                -- Affiche_Segment(cSegment);

                Segment_Lists.Append( Segments, cSegment );

                return Segments;
        end;

        procedure Reconnect(sPoint : SimplePoint ; pUp, pDown : Arbre_Segments.Arbre) is
                UpPoint, DownPoint : SimplePoint;
        begin
                if pUp /= null then
                        -- Put_Line("UP");
                        UpPoint := Intersection(sPoint, pUp.C);
                        Svg_Line(sPoint, UpPoint, Green);
                end if;

                if pDown /= null then
                        -- Put_Line("DOWN");
                        DownPoint := Intersection(sPoint, pDown.C);
                        Svg_Line(sPoint, DownPoint, Green);
                end if;
        end;

        -- procedure UpdateAVL(cAVL, nAVL : in out Arbre_Segments.Arbre) is
        --         pNoeud : Arbre_Segments.Arbre;
        -- begin
        --         if cAVL /= null then
        --                 pNoeud := Arbre_Segments.Inserer(nAVL, cAVL.C);

        --                 UpdateAVL(cAVL.Fils(Gauche), nAVL);
        --                 UpdateAVL(cAVL.Fils(Droite), nAVL);
        --         end if;
        -- end;



        procedure Decomposition(cPoint : Point ; cAVL : in out Arbre_Segments.Arbre) is
                R : Boolean := False;
                cSegment : Segment;
                sPoint : SimplePoint := cPoint.Pt;
                pNoeud : Arbre_Segments.Arbre;
                V_petit, V_Grand : Arbre_Segments.Arbre;
                C_petits, C_Grands : Natural;
                Segment_Pos : Segment_Lists.Cursor;

                -- nAVL : Arbre_Segments.Arbre;
        begin

                New_Line;
                Put("Point courant : ");
                Affiche_Point(sPoint);

                New_Line;
                Affichage_AVL(cAVL);
                New_Line;
                New_Line;
                -- Common.D_Pos := sPoint.X;

                -- nAVL := null;
                -- UpdateAVL(cAVL, nAVL);
                -- cAVL := nAVL;
                -- nAVL := null;

        -- if cAVL = null then
        -- Put_Line("WTF");
        -- end if;
                if Segment_Lists.Length(cPoint.OutSegs) = 2 then
                        R := True;
                        cSegment := ( sPoint, sPoint, sPoint );
-- new_line;
-- Put_Line("yy");
-- Affichage_AVL(cAVL);
-- new_line;

                        pNoeud := Arbre_Segments.Inserer(cAVL, cSegment);

-- new_line;
-- Put_Line("yy");
-- Affichage_AVL(cAVL);
-- new_line;

                        Noeuds_Voisins(pNoeud, V_petit, V_Grand);
                        Compte_Position(pNoeud, C_petits, C_Grands);
-- new_line;

-- Affichage_AVL(cAVL);
-- new_line;
-- new_line;

--                         if V_petit /= null then
--                         Put_Line("V_petit");
--                                 Affiche_Segment(V_petit.C);
--                         end if;
--                         Put_Line("C_petits="&Natural'image(C_petits));
--                         Put_Line("C_Grands="&Natural'image(C_Grands));

--                         Put_Line("cSegment");
--                                 Affiche_Segment(cSegment);

--                         if V_Grand /= null then
--                         Put_Line("V_Grand");
--                                 Affiche_Segment(V_Grand.C);
--                         end if;

                        cAVL := Arbre_Segments.Supprimer_Noeud(cAVL, cSegment);
-- new_line;
-- Put_Line("yy");
-- Affichage_AVL(cAVL);
-- new_line;

                end if;


                Segment_Pos := Segment_Lists.First( cPoint.InSegs );
                while Segment_Lists.Has_Element( Segment_Pos ) loop

                        cSegment := Segment_Lists.Element( Segment_Pos );
                        Put_Line("Del");
                        Affiche_Segment(cSegment);
                        New_Line;
                        cAVL := Arbre_Segments.Supprimer_Noeud(cAVL, cSegment);

                        Segment_Lists.Next( Segment_Pos );

                end loop;

                Segment_Pos := Segment_Lists.First( cPoint.OutSegs );
                while Segment_Lists.Has_Element( Segment_Pos ) loop

                        -- Put_Line("Add");
                        cSegment := Segment_Lists.Element( Segment_Pos );
                        pNoeud := Arbre_Segments.Inserer(cAVL, cSegment);

                        Segment_Lists.Next( Segment_Pos );

                end loop;

-- new_line;
-- Affichage_AVL(cAVL);
-- new_line;

                -- Put_Line("Length(InSegs) = "&Count_Type'image(Segment_Lists.Length(cPoint.InSegs)));
                if Segment_Lists.Length(cPoint.InSegs) = 2 then
                        R := True;
                        cSegment := ( sPoint, sPoint, sPoint );
                        pNoeud := Arbre_Segments.Inserer(cAVL, cSegment);

                        Noeuds_Voisins(pNoeud, V_petit, V_Grand);
--                         new_line;
--                         new_line;
-- new_line;

-- Affichage_AVL(cAVL);
-- new_line;
-- new_line;

--                         if V_petit /= null then
--                         Put_Line("V_petit");
--                                 Affiche_Segment(V_petit.C);
--                         end if;
--                         Put_Line("C_petits="&Natural'image(C_petits));
--                         Put_Line("C_Grands="&Natural'image(C_Grands));

--                         Put_Line("cSegment");
--                                 Affiche_Segment(cSegment);

--                         if V_Grand /= null then
--                         Put_Line("V_Grand");
--                                 Affiche_Segment(V_Grand.C);
--                         end if;

--                         new_line;

                        Compte_Position(pNoeud, C_petits, C_Grands);

                        cAVL := Arbre_Segments.Supprimer_Noeud(cAVL, cSegment);
                end if;

                if R and ((C_petits mod 2) = 1 or (C_Grands mod 2) = 1) then
                        Reconnect(sPoint, V_petit, V_Grand);
                        -- Put_Line("Reconnect !");
                end if;
        end;

end Decompose;


