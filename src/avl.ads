
with Ada.Unchecked_Deallocation;


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
                Hauteur : Natural; -- Champ supplémentaire des AVL
        end record;


        procedure Liberer_Noeud is new Ada.Unchecked_Deallocation (Object => Noeud, Name => Arbre);



        -- Coût au pire cas : O(h) = O(log2(n)) car AVL
        procedure Noeuds_Voisins(Cible : Arbre ; Petit_Voisin, Grand_Voisin : out Arbre);

        -- Coût au pire cas : O(h) = O(log2(n)) car AVL
        procedure Compte_Position( Cible : Arbre ; Nb_Petits, Nb_Grands : out Natural);


        -- Coût au pire cas : O(h) = O(log2(n)) car AVL
        function Inserer(Noeud : in out Arbre ; Clef : Type_Clef) return Arbre;

        -- Coût au pire cas : O(h) = O(log2(n)) car AVL
        function Rechercher(Racine : Arbre ; Clef : Type_Clef) return Arbre;

        -- Coût au pire cas : O(h) = O(log2(n)) car AVL
        function Supprimer_Noeud(Racine : Arbre ; Clef : Type_Clef) return Arbre;

        -- Libère l'AVL en entier (pour s'assurer qu'il n'y a pas de leak).
        procedure Liberer(Racine : in out Arbre);


        -- Package générique d'affichage / export d'arbre
        generic
                with function Get_String(Clef : Type_Clef) return String;

        package Generic_Display is
                procedure Affichage(Racine : Arbre);
                procedure Export(Dest : String ; Racine : Arbre);
        end Generic_Display;

end AVL;


