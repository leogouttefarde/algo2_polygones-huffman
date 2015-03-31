
with Ada.Text_IO;
use Ada.Text_IO;

package body AVL is

        -- Coût au pire cas : O(h) = O(log2(n)) car AVL
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

        -- Coût au pire cas : O(h) = O(log2(n)) car AVL
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

        -- Coût au pire cas : O(h) = O(log2(n)) car AVL
        -- Précondition : Cible /= null
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

        -- Coût au pire cas : O(h) = O(log2(n)) car AVL
        -- Précondition : Cible /= null
        function GrandVoisin(Cible : Arbre) return Arbre is
                Pere : Arbre := Cible.Pere;
        begin
                -- Descente de l'arbre
                if Cible.Fils(Droite) /= null then
                        return Min_Noeud( Cible.Fils(Droite) );

                -- Remontée de l'arbre
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

        -- Coût au pire cas : O(h) = O(log2(n)) car AVL
        procedure Noeuds_Voisins(Cible : Arbre ; Petit_Voisin, Grand_Voisin : out Arbre) is
        begin
                if Cible /= null then
                        Petit_Voisin := PetitVoisin( Cible );
                        Grand_Voisin := GrandVoisin( Cible );
                else
                        Petit_Voisin := null;
                        Grand_Voisin := null;
                end if;
        end;

        -- Coût : O(1)
        -- On a réduit le coût en stockant
        -- le compte de chaque noeud dans le champ "Compte"
        -- qui est mis à jour quand nécessaire.
        function Compte( Cible : Arbre ) return Natural is
                Res : Natural := 0;
        begin
                if Cible /= null then
                        Res := Cible.Compte;
                end if;

                return Res;
        end;

        -- Coût au pire cas : O(h - 1)
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

                        -- Remontée récursive de l'arbre
                        Res := Res + CompteInf(Cible, Clef);
                end if;

                return Res;
        end;

        -- Coût au pire cas : O(h - 1)
        function CompteSup(iCible : Arbre ; Clef : Type_Clef) return Natural is
                Res : Natural := 0;
                Prev : Arbre := iCible;
                Cible : Arbre := iCible.Pere;
        begin
                if Cible /= null then
                        if Cible.C > Clef then
                                Res := Res + 1;
                        end if;

                        -- Descente de l'arbre
                        if Cible.Fils(Droite) /= Prev then
                                Res := Res + Compte(Cible.Fils(Droite));
                        end if;

                        -- Remontée récursive de l'arbre
                        Res := Res + CompteSup(Cible, Clef);
                end if;

                return Res;
        end;

        -- Coût au pire cas : O(h) = O(1) + O(h - 1) = O(log2(n)) car AVL
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
        end Hauteur;


        procedure Update_Hauteur(A : in out Arbre) is
        begin
                if A /= null then
                        A.Hauteur := Natural'Max( Hauteur(A.Fils(Gauche)), Hauteur(A.Fils(Droite))) + 1;
                end if;
        end;


        function Creer_Noeud(Clef : Type_Clef) return Arbre is
                pNoeud : Arbre := new Noeud;
        begin
                pNoeud.C := Clef;
                pNoeud.Compte := 1;
                pNoeud.Hauteur := 1;
                pNoeud.Pere := null;
                pNoeud.Fils(Gauche) := null;
                pNoeud.Fils(Droite) := null;

                return pNoeud;
        end;


        function Rotation_Droite(pNoeud : in out Arbre) return Arbre is
                Noeud : Arbre := pNoeud.Fils(Gauche);
                Noeud2 : Arbre := Noeud.Fils(Droite);
                Count : Positive := pNoeud.Compte;
        begin
                Noeud.Fils(Droite) := pNoeud;
                pNoeud.Fils(Gauche) := Noeud2;

                Noeud.Pere := pNoeud.Pere;
                pNoeud.Pere := Noeud;

                if Noeud2 /= null then
                        Noeud2.Pere := pNoeud;
                        pNoeud.Compte := pNoeud.Compte + Noeud2.Compte;
                end if;


                -- Else jamais rencontré normalement
                if pNoeud.Compte > Noeud.Compte then
                        pNoeud.Compte := pNoeud.Compte - Noeud.Compte;
                end if;

                Noeud.Compte := Count;

                Update_Hauteur(pNoeud);
                Update_Hauteur(Noeud);

                return Noeud;

        end Rotation_Droite;


        function Rotation_Gauche(A : in out Arbre) return Arbre is
                B : Arbre := A.Fils(Droite);
                C : Arbre := B.Fils(Gauche);
                Count : Positive := A.Compte;
        begin
                B.Fils(Gauche) := A;
                A.Fils(Droite) := C;

                B.Pere := A.Pere;
                A.Pere := B;

                if C /= null then
                        C.Pere := A;
                        A.Compte := A.Compte + C.Compte;
                end if;


                -- Else jamais rencontré normalement
                if A.Compte > B.Compte then
                        A.Compte := A.Compte - B.Compte;
                end if;

                B.Compte := Count;

                Update_Hauteur(A);
                Update_Hauteur(B);

                return B;

        end Rotation_Gauche;


        function Balance(A : Arbre) return Integer is
                Balance : Integer := 0;
        begin
                if A /= null then
                        Balance := Hauteur(A.Fils(Gauche)) - Hauteur(A.Fils(Droite));
                end if;

                return Balance;

        end Balance;


        -- Coût au pire cas : O(h) = O(log2(n)) car AVL
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

                Noeud.Compte := Noeud.Compte + 1;
                Update_Hauteur(Noeud);

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

        end Inserer;


        -- Coût au pire cas : O(h) = O(log2(n)) car AVL
        function Rechercher(Racine : Arbre ; Clef : Type_Clef) return Arbre is
                Result : Arbre := null;
        begin
                if Racine /= null then
                        if Clef < Racine.C then
                                Result := Rechercher(Racine.Fils(Gauche), Clef);
                        elsif Clef > Racine.C then
                                Result := Rechercher(Racine.Fils(Droite), Clef);
                        else
                                Result := Racine;
                        end if;
                end if;

                return Result;

        end Rechercher;


        -- Coût au pire cas : O(h) = O(log2(n)) car AVL
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

                                if temp /= null then
                                        Liberer_Noeud(temp);
                                end if;
                        else
                                temp := Min_Noeud(oRacine.Fils(Droite));
                                oRacine.C := temp.C;
                                oRacine.Fils(Droite) := Supprimer_Noeud(oRacine.Fils(Droite), temp.C);
                        end if;

                end if;

                if oRacine = null then
                        return oRacine;
                end if;

                if oRacine.Compte > 1 then
                        oRacine.Compte := oRacine.Compte - 1;
                end if;

                Update_Hauteur(oRacine);

                cBalance := Balance(oRacine);

                if (cBalance > 1 and then Balance(oRacine.Fils(Gauche)) >= 0) then
                        oRacine := Rotation_Droite(oRacine);

                elsif (cBalance > 1 and then Balance(oRacine.Fils(Gauche)) < 0) then
                        oRacine.Fils(Gauche) := Rotation_Gauche(oRacine.Fils(Gauche));
                        oRacine := Rotation_Droite(oRacine);

                elsif (cBalance < -1 and then Balance(oRacine.Fils(Droite)) <= 0) then
                        oRacine := Rotation_Gauche(oRacine);

                elsif (cBalance < -1 and then Balance(oRacine.Fils(Droite)) > 0) then
                        oRacine.Fils(Droite) := Rotation_Droite(oRacine.Fils(Droite));
                        oRacine := Rotation_Gauche(oRacine);
                end if;

                return oRacine;

        end Supprimer_Noeud;


        -- Libère l'AVL en entier (pour s'assurer qu'il n'y a pas de leak).
        procedure Liberer(Racine : in out Arbre) is
        begin
                if Racine /= null then
                        Liberer(Racine.Fils(Gauche));
                        Liberer(Racine.Fils(Droite));
                        Liberer_Noeud(Racine);
                end if;
        end;


        package body Generic_Display is

        procedure Affichage(Racine : Arbre) is
        begin
                if Racine /= null then
                        Put_Line( Get_String(Racine.C) );
                        Put_Line("Gauche");
                        Affichage(Racine.Fils(Gauche));
                        Put_Line("Droite");
                        Affichage(Racine.Fils(Droite));
                        Put_Line("Fin");
                end if;
        end;

        procedure Export(Dest : String ; Racine : Arbre) is

                procedure Subtree(File : File_Type ; Racine : Arbre ; Index : in out Natural) is
                        Cur : Natural := Index + 1;
                begin
                        if Racine /= null then
                                Index := Cur;
                                Put(File, " -- " & Natural'Image(Cur) );
                                Subtree(File, Racine.Fils(Gauche), Index);


                                Put_Line( File, "   " & Natural'Image(Cur)
                                        & " [label=""" & Get_String(Racine.C)
                                        & """]");

                                Put(File, "   " & Natural'Image(Cur) );
                                Subtree(File, Racine.Fils(Droite), Index);
                        else
                                New_Line(File);
                        end if;
                end;

                File : File_Type;
                Index : Natural := 0;
                Cur : Natural := Index;
        begin
                if Racine /= null then

                        Create( File => File, Mode => Out_File, Name => Dest );

                        New_Line(File);
                        Put_Line(File, "graph { ");

                        Put_Line( File, "   " & Natural'Image(Cur)
                                & " [label=""" & Get_String(Racine.C)
                                & """]");

                        Put(File, "   " & Natural'Image(Cur));
                        Subtree(File, Racine.Fils(Gauche), Index);
                        Put(File, "   " & Natural'Image(Cur));
                        Subtree(File, Racine.Fils(Droite), Index);
                        Put_Line(File, "}");
                        New_Line(File);

                        Close(File);

                end if;
        exception
                when others => NULL;
        end;

        end Generic_Display;


end AVL;


