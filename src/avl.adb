
with Ada.Text_IO;
use Ada.Text_IO;

package body AVL is

        function Max_Noeud(Noeud : Arbre) return Arbre is
                cNoeud : Arbre := Noeud;
        begin
                if cNoeud /= null then
                        while cNoeud.Fils(Droite) /= null loop
                                cNoeud := cNoeud.Fils(Droite);
                        end loop;
                end if;

                return cNoeud;
        end;

        function Min_Noeud(Noeud : Arbre) return Arbre is
                cNoeud : Arbre := Noeud;
        begin
                if cNoeud /= null then
                        while cNoeud.Fils(Gauche) /= null loop
                                cNoeud := cNoeud.Fils(Gauche);
                        end loop;
                end if;

                return cNoeud;
        end;

        -- requires Cible /= null
        function PetitVoisin(Cible : Arbre) return Arbre is
                Pere : Arbre := Cible.Pere;
        begin
                if Cible.Fils(Gauche) /= null then
                        return Max_Noeud( Cible.Fils(Gauche) );

                else
                        while Pere /= null loop
                                if Pere.C < Cible.C then
                                        return Pere;
                                end if;

                                Pere := Pere.Pere;
                        end loop;

                        return null;
                end if;
        end;

        function GrandVoisin(Cible : Arbre) return Arbre is
                Pere : Arbre := Cible.Pere;
        begin
                if Cible.Fils(Droite) /= null then
                        return Min_Noeud( Cible.Fils(Droite) );

                else
                        while Pere /= null loop
                                if Pere.C > Cible.C then
                                        return Pere;
                                end if;

                                Pere := Pere.Pere;
                        end loop;

                        return null;
                end if;
        end;

        procedure Noeuds_Voisins(Cible : Arbre ; Petit_Voisin, Grand_Voisin : out Arbre) is
        begin
                if Cible /= null then
                        Petit_Voisin := PetitVoisin( Cible );
                        Grand_Voisin := GrandVoisin( Cible );
                end if;
        end;

        function Compte( Cible : Arbre ) return Natural is
                Res : Natural := 0;
        begin
                if Cible /= null then
                        Res := 1 + Compte( Cible.Fils(Gauche) ) + Compte( Cible.Fils(Droite) );
                end if;

                return Res;
        end;

        function CompteInf(iCible : Arbre ; Clef : Type_Clef) return Natural is
                Res : Natural := 0;
                Prev : Arbre := iCible;
                Cible : Arbre := iCible.Pere;
        begin
                if Cible /= null then
                        if Cible.C < Clef then
                                Res := Res + 1;
                        end if;

                        if Cible.Fils(Gauche) /= Prev then
                                Res := Res + Compte(Cible.Fils(Gauche));
                        end if;

                        Res := Res + CompteInf(Cible, Clef);
                end if;

                return Res;
        end;

        function CompteSup(iCible : Arbre ; Clef : Type_Clef) return Natural is
                Res : Natural := 0;
                Prev : Arbre := iCible;
                Cible : Arbre := iCible.Pere;
        begin
                if Cible /= null then
                        if Cible.C > Clef then
                                Res := Res + 1;
                        end if;

                        if Cible.Fils(Droite) /= Prev then
                                Res := Res + Compte(Cible.Fils(Droite));
                        end if;

                        Res := Res + CompteSup(Cible, Clef);
                end if;

                return Res;
        end;

        procedure Compte_Position( Cible : Arbre ; Nb_Petits, Nb_Grands : out Natural) is
        begin
                Nb_Petits := Compte( Cible.Fils(Gauche) ) + CompteInf(Cible, Cible.C);
                Nb_Grands := Compte( Cible.Fils(Droite) ) + CompteSup(Cible, Cible.C);
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

                Noeud.Pere := pNoeud.Pere;
                pNoeud.Pere := Noeud;

                if Noeud2 /= null then
                        Noeud2.Pere := pNoeud;
                end if;

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

                B.Pere := A.Pere;
                A.Pere := B;

                if C /= null then
                        C.Pere := A;
                end if;

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

        function Inserer(Noeud : in out Arbre ; Clef : Type_Clef) return Arbre is
                cBalance : Integer;
                Cible : Arbre;
        begin
                if Noeud = null then
                        Noeud := Creer_Noeud(Clef);
                        Cible := Noeud;

                        return Cible;
                end if;

                if Clef < Noeud.C then
                        Cible := Inserer(Noeud.Fils(Gauche), Clef);
                        Noeud.Fils(Gauche).Pere := Noeud;
                else
                        Cible := Inserer(Noeud.Fils(Droite), Clef);
                        Noeud.Fils(Droite).Pere := Noeud;
                end if;

                Noeud.Hauteur := Natural'Max( Hauteur(Noeud.Fils(Gauche)), Hauteur(Noeud.Fils(Droite))+1 );

                cBalance := Balance(Noeud);

                if (cBalance > 1 and then Clef < Noeud.Fils(Gauche).C) then
                        Noeud := Rotation_Droite(Noeud);

                elsif (cBalance < -1 and then Clef > Noeud.Fils(Droite).C) then
                        Noeud := Rotation_Gauche(Noeud);

                elsif (cBalance > 1 and then Clef > Noeud.Fils(Gauche).C) then
                        Noeud.Fils(Gauche) := Rotation_Gauche(Noeud.Fils(Gauche));
                        Noeud := Rotation_Droite(Noeud);

                elsif (cBalance < -1 and then Clef < Noeud.Fils(Droite).C) then
                        Noeud.Fils(Droite) := Rotation_Droite(Noeud.Fils(Droite));
                        Noeud := Rotation_Gauche(Noeud);
                end if;

                if Noeud.Fils(Gauche) /= null then
                        Noeud.Fils(Gauche).Pere := Noeud;
                end if;

                if Noeud.Fils(Droite) /= null then
                        Noeud.Fils(Droite).Pere := Noeud;
                end if;

                return Cible;
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
                                        temp.Pere := oRacine.Pere;
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

                if (cBalance > 1 and then Balance(oRacine.Fils(Gauche)) >= 0) then
                        return Rotation_Droite(oRacine);

                elsif (cBalance > 1 and then Balance(oRacine.Fils(Gauche)) < 0) then
                        oRacine.Fils(Gauche) := Rotation_Gauche(oRacine.Fils(Gauche));
                        return Rotation_Droite(oRacine);

                elsif (cBalance < -1 and then Balance(oRacine.Fils(Droite)) <= 0) then
                        return Rotation_Gauche(oRacine);

                elsif (cBalance < -1 and then Balance(oRacine.Fils(Droite)) > 0) then
                        oRacine.Fils(Droite) := Rotation_Droite(oRacine.Fils(Droite));
                        return Rotation_Gauche(oRacine);
                end if;

                return oRacine;
        end Supprimer_Noeud;

        procedure Affichage(Racine : Arbre) is
        begin
                if Racine /= null then
                        Affiche(Racine.C);
                        Affichage(Racine.Fils(Gauche));
                        Affichage(Racine.Fils(Droite));
                end if;
        end;



end AVL;


