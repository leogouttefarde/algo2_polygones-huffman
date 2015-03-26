


package body Arbre is

        procedure Noeuds_Voisins(Cible : Arbre ; Petit_Voisin, Grand_Voisin : out Arbre) is
        begin
                NULL;
        end;

        function Hauteur(A : Arbre) return Natural is
        begin
                if A = null then
                        return 0;
                else
                        return A.Hauteur;
                end if;
        end;

        function Creer_Noeud(Clef : Type_Clef) return Arbre is
                pNoeud : Arbre := new Noeud;
        begin
                pNoeud.C := Clef;
                pNoeud.Compte := 1;
                pNoeud.Hauteur := 1;

                return pNoeud;
        end;

        function Rotation_Droite(pNoeud : Arbre) return Arbre is
                Noeud : Arbre := pNoeud.Fils(Gauche);
                Noeud2 : Arbre := Noeud.Fils(Droite);
        begin
                Noeud.Fils(Droite) := pNoeud;
                pNoeud.Fils(Gauche) := Noeud2;

                pNoeud.Hauteur := Natural'Max( Hauteur(pNoeud.Fils(Gauche)), Hauteur(pNoeud.Fils(Droite))+1 );
                Noeud.Hauteur := Natural'Max( Hauteur(Noeud.Fils(Gauche)), Hauteur(Noeud.Fils(Droite))+1 );

                return Noeud;
        end;

        function Rotation_Gauche(A : Arbre) return Arbre is
                B : Arbre := A.Fils(Droite);
                C : Arbre := B.Fils(Gauche);
        begin
                B.Fils(Gauche) := A;
                A.Fils(Droite) := C;

                A.Hauteur := Natural'Max( Hauteur(A.Fils(Gauche)), Hauteur(A.Fils(Droite))+1 );
                B.Hauteur := Natural'Max( Hauteur(B.Fils(Gauche)), Hauteur(B.Fils(Droite))+1 );

                return B;
        end;

        function Balance(A : Arbre) return Integer is
                Balance : Integer := 0;
        begin
                if A /= null then
                        Balance := Hauteur(A.Fils(Gauche)) - Hauteur(A.Fils(Droite));
                end if;

                return Balance;
        end;

        function Inserer(Noeud : Arbre ; Clef : Type_Clef) return Arbre is
                cBalance : Integer;
        begin
                if Noeud = null then
                        return Creer_Noeud(Clef);
                end if;

                if Clef < Noeud.C then
                        Noeud.Fils(Gauche) := Inserer(Noeud.Fils(Gauche), Clef);
                else
                        Noeud.Fils(Droite) := Inserer(Noeud.Fils(Droite), Clef);
                end if;

                Noeud.Hauteur := Natural'Max( Hauteur(Noeud.Fils(Gauche)), Hauteur(Noeud.Fils(Droite))+1 );

                cBalance := Balance(Noeud);

                if (cBalance > 1 and Clef < Noeud.Fils(Gauche).C) then
                        return Rotation_Droite(Noeud);

                elsif (cBalance < -1 and Clef > Noeud.Fils(Droite).C) then
                        return Rotation_Gauche(Noeud);

                elsif (cBalance > 1 and Clef > Noeud.Fils(Gauche).C) then
                        Noeud.Fils(Gauche) := Rotation_Gauche(Noeud.Fils(Gauche));
                        return Rotation_Droite(Noeud);

                elsif (cBalance < -1 and Clef < Noeud.Fils(Droite).C) then
                        Noeud.Fils(Droite) := Rotation_Droite(Noeud.Fils(Droite));
                        return Rotation_Gauche(Noeud);
                end if;


                return Noeud;
        end;

        function Min_Noeud(Noeud : Arbre) return Arbre is
                cNoeud : Arbre := Noeud;
        begin
                while cNoeud.Fils(Gauche) /= null loop
                        cNoeud := cNoeud.Fils(Gauche);
                end loop;

                return cNoeud;
        end;

        function Supprimer_Noeud(Racine : Arbre ; Clef : Type_Clef) return Arbre is
                Temp : Arbre;
                oRacine : Arbre := Racine;
                cBalance : Integer;
        begin
                if Racine = null then
                        return Racine;
                end if;

                if Clef < Racine.C then
                        Racine.Fils(Gauche) := Supprimer_Noeud(Racine.Fils(Gauche), Clef);

                elsif Clef > Racine.C then
                        Racine.Fils(Droite) := Supprimer_Noeud(Racine.Fils(Droite), Clef);
                
                else
                        if (Racine.Fils(Gauche) = null) or (Racine.Fils(Droite) = null) then
        
                                if Racine.Fils(Gauche) /= null then
                                        temp := Racine.Fils(Gauche);
                                else
                                        temp := Racine.Fils(Droite);
                                end if;

                                if temp = null then
                                        temp := Racine;
                                        oRacine := null;
                                else
                                        oRacine.all := temp.all;
                                end if;

                                --Free(temp);
                        else
                                temp := Min_Noeud(oRacine.Fils(Droite));
                                oRacine.C := temp.C;
                                oRacine.Fils(Droite) := Supprimer_Noeud(oRacine.Fils(Droite), temp.C);
                        end if;

                end if;

                if oRacine = null then
                        return oRacine;
                end if;

                oRacine.Hauteur := Natural'Max( Hauteur(oRacine.Fils(Gauche)), Hauteur(oRacine.Fils(Droite))+1 );

                cBalance := Balance(oRacine);

                if (cBalance > 1 and Balance(oRacine.Fils(Gauche)) >= 0) then
                        return Rotation_Droite(oRacine);

                elsif (cBalance > 1 and Balance(oRacine.Fils(Gauche)) < 0) then
                        oRacine.Fils(Gauche) := Rotation_Gauche(oRacine.Fils(Gauche));
                        return Rotation_Droite(oRacine);

                elsif (cBalance < -1 and Balance(oRacine.Fils(Droite)) <= 0) then
                        return Rotation_Gauche(oRacine);

                elsif (cBalance < -1 and Balance(oRacine.Fils(Droite)) > 0) then
                        oRacine.Fils(Droite) := Rotation_Droite(oRacine.Fils(Droite));
                        return Rotation_Gauche(oRacine);
                end if;

                return oRacine;
        end;

        -- procedure Affichage(Racine : Arbre) is
        -- begin
        --         if Racine /= null then
        --                 --Put()
        --         end if;
        -- end;



end Arbre;


