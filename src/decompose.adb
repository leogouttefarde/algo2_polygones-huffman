


package body Decompose is

        -- Ajoute les segments entrants / sortants d'un point
        -- Précondition : Prev(2) = cPoint = Next(1)
        procedure Finish_Point (cPoint : in out Point ; Prev, Next : Segment) is
        begin
                -- Traitement du segment précédent
                if InfEgal(Prev(1).X, cPoint.Pt.X) then
                        Segment_Lists.Append(cPoint.InSegs, Prev);
                elsif Sup(Prev(1).X, cPoint.Pt.X) then
                        Segment_Lists.Append(cPoint.OutSegs, Prev);
                end if;

                -- Traitement du segment suivant
                if Inf(Next(2).X, cPoint.Pt.X) then
                        Segment_Lists.Append(cPoint.InSegs, Next);
                elsif SupEgal(Next(2).X, cPoint.Pt.X) then
                        Segment_Lists.Append(cPoint.OutSegs, Next);
                end if;
        end;

        -- Ajoute les segments entrants / sortants de chaque point
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

                -- Parcours des segments
                -- et attribution aux points voisins
                loop
                        Point_Lists.Next( Point_Pos );
                        Segment_Lists.Next( Segment_Pos );

                        exit when not (Point_Lists.Has_Element( Point_Pos )
                                and Segment_Lists.Has_Element( Segment_Pos ));


                        cSegment := Segment_Lists.Element( Segment_Pos );

                        cPoint := Point_Lists.Element( Point_Pos );

                        -- Ajout des segments entrants / sortants de chaque point
                        Finish_Point(cPoint, sPrev, cSegment);

                        -- Mise à jour de la liste
                        Point_Lists.Replace_Element(Points, Point_Pos, cPoint);

                        sPrev := cSegment;
                end loop;

                -- Ajout des segments entrants / sortants du premier point
                Finish_Point(First, sPrev, s1);

                -- Mise à jour de la liste
                Point_Lists.Replace_Element(Points, FirstPos, First);
        end;

        -- Génère les segments correspondant aux points donnés
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
                sPoint := cPoint.Pt;
                First := sPoint;
                Prev := First;

                -- Parcours des points et création
                -- des segments par liaison
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

        -- Génère le code SVG de reconnexion d'un point à un segment
        procedure Reconnexion(P1 : SimplePoint ; cSegment : pSegment) is
                P2 : SimplePoint;
        begin
                if cSegment /= null then
                        P2 := Intersection(P1, cSegment.all);

                        if not IsPoint((P1, P2)) then
                                Svg_Line(P1, P2, Blue);
                        end if;
                end if;
        end;

        function Impair(Nombre : Natural) return Boolean is
        begin
                if (Nombre mod 2) = 1 then
                        return True;
                end if;

                return False;
        end;

        -- Libération de segment sécurisée
        procedure Liberation(cSegment : in out pSegment) is
        begin
                if cSegment /= null then
                        Liberer_Segment(cSegment);
                        cSegment := null;
                end if;
        end;

        -- Extrait le segment d'un noeud
        procedure Copie(Dest : in out pSegment ; pNoeud : Arbre) is
        begin
                if pNoeud /= null then

                        if Dest = null then
                                Dest := new Segment;
                        end if;

                        Dest.all := pNoeud.C;
                else
                        Liberation(Dest);
                end if;
        end;


        --DotIndex : Natural := 0;

        -- Exécute l'algorithme de décomposition pour le point donné
        procedure Decomposition(cPoint : Point ; cAVL : in out Arbre) is
                Rebroussement : Boolean := False;
                cSegment : Segment;
                sPoint : SimplePoint := cPoint.Pt;
                pNoeud : Arbre;
                V_petit : Arbre := null;
                V_Grand : Arbre := null;
                S_petit : pSegment := null;
                S_Grand : pSegment := null;
                C_petits : Natural := 0;
                C_Grands : Natural := 0;
                Segment_Pos : Segment_Lists.Cursor;
        begin

                -- On regarde si on est sur un point de rebroussement
                if Segment_Lists.Length(cPoint.OutSegs) = 2 then
                        Rebroussement := True;
                        cSegment := ( sPoint, sPoint );

                        pNoeud := Inserer(cAVL, cSegment);

                        Noeuds_Voisins(pNoeud, V_petit, V_Grand);
                        Compte_Position(pNoeud, C_petits, C_Grands);

                        -- On copie les segments voisins car la suppression
                        -- d'en-dessous peut invalider leurs pointeurs
                        Copie(S_petit, V_petit);
                        Copie(S_Grand, V_Grand);


                        cAVL := Supprimer_Noeud(cAVL, cSegment);

                end if;


                -- On retire de l'AVL les segments qui finissent au point courant
                Segment_Pos := Segment_Lists.First( cPoint.InSegs );
                while Segment_Lists.Has_Element( Segment_Pos ) loop

                        cSegment := Segment_Lists.Element( Segment_Pos );
                        cAVL := Supprimer_Noeud(cAVL, cSegment);

                        Segment_Lists.Next( Segment_Pos );

                end loop;


                -- On ajoute à l'AVL les segments qui commencent au point courant
                Segment_Pos := Segment_Lists.First( cPoint.OutSegs );
                while Segment_Lists.Has_Element( Segment_Pos ) loop

                        cSegment := Segment_Lists.Element( Segment_Pos );
                        pNoeud := Inserer(cAVL, cSegment);

                        Segment_Lists.Next( Segment_Pos );

                end loop;


                -- Export .dot des AVLs pour le debug
                --AVL_Disp.Export("dots/AVL" & Natural'Image(DotIndex) & ".dot", cAVL);
                --DotIndex := DotIndex + 1;


                if Segment_Lists.Length(cPoint.InSegs) = 2 then
                        Rebroussement := True;
                        cSegment := ( sPoint, sPoint );
                        pNoeud := Inserer(cAVL, cSegment);

                        Noeuds_Voisins(pNoeud, V_petit, V_Grand);
                        Compte_Position(pNoeud, C_petits, C_Grands);

                        -- On copie les segments voisins car la suppression
                        -- d'en-dessous peut invalider leurs pointeurs
                        Copie(S_petit, V_petit);
                        Copie(S_Grand, V_Grand);


                        cAVL := Supprimer_Noeud(cAVL, cSegment);

                end if;


                -- On traite l'éventuel point de rebroussement
                if Rebroussement and (Impair(C_petits) or Impair(C_Grands)) then

                        Reconnexion(sPoint, S_petit);
                        Reconnexion(sPoint, S_Grand);

                end if;

                Liberation(S_petit);
                Liberation(S_Grand);

        end;

end Decompose;


