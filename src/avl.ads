


generic
        type Type_Clef is private;
        with function "<" (X, Y: Type_Clef) return Boolean;
        with function ">" (X, Y: Type_Clef) return Boolean;

package AVL is

        type Noeud;
        type Arbre is access Noeud;
        type Direction is (Gauche, Droite);
        type Tableau_Fils is array (Direction) of Arbre;
        type Noeud is record
                C : Type_Clef;
                Fils : Tableau_Fils;
                Pere : Arbre;
                Compte : Positive; -- nombre de noeuds dans le sous-arbre
                Hauteur : Natural;
        end record;


        -- Coût pire cas = O(h)
        procedure Noeuds_Voisins(Cible : Arbre ; Petit_Voisin, Grand_Voisin : out Arbre);

        -- Coût pire cas = O(h)
        procedure Compte_Position( Cible : Arbre ; Nb_Petits, Nb_Grands : out Natural);

        function Inserer(Noeud : Arbre ; Clef : Type_Clef) return Arbre;

        function Supprimer_Noeud(Racine : Arbre ; Clef : Type_Clef) return Arbre;

end AVL;


