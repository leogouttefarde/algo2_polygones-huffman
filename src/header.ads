


type Noeud;
type Arbre is access Noeud;
type Direction is (Gauche, Droite);
type Tableau_Fils is array (Direction) of Arbre;
type Noeud is record
        C : Type_Clef;
        Fils : Tableau_Fils;
        Pere : Arbre;
        Compte : Positive; -- nombre de noeuds dans le sous-arbre
end record;



-- Coût pire cas = O(h)
procedure Noeuds_Voisins(Cible : Arbre ; Petit_Voisin, Grand_Voisin : out Arbre);

-- Coût pire cas = O(h)
procedure Compte_Position( Cible : Arbre ; Nb_Petits, Nb_Grands : out Natural);


