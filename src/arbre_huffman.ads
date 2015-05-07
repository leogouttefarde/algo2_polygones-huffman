with Ada.Unchecked_Deallocation, Ada.Streams.Stream_IO;
use Ada.Streams.Stream_IO;

package Arbre_Huffman is
	--stockage des frequences
	type Tableau_Ascii is array(Character) of Natural;
	--un bit
	subtype ChiffreBinaire is Integer range 0..1 ;
	--arbre
	type Arbre is private;

	function Calcul_Arbre(Frequences : in Tableau_Ascii) return Arbre;
	procedure Affiche_Arbre(A: Arbre);
	procedure Export(Dest : String ; Racine : Arbre);

	--un code binaire
	type TabBits is array(Positive range <>) of ChiffreBinaire ;
	type Code is access TabBits;
	procedure Liberer is new Ada.Unchecked_Deallocation(TabBits, Code);

	-- Dictionnaire des codes
	type Dico is array(Character) of Code;

	-- Stocke le code de chaque caractère
	function Calcul_Dictionnaire(A : Arbre) return Dico;
	procedure Liberer_Dictionnaire(D : in out Dico);

	procedure Stockage_Huffman(SAccess : in out Stream_Access ; Arbre_Huffman : Arbre);
	function Lecture_Huffman(SAccess : in out Stream_Access) return Arbre;

	procedure Liberer_Arbre(A : in out Arbre);

	generic
		with function Octet_Suivant return Character;
		--decodage_code prend un reste d'octet non decode
		--un arbre
		--et calcule le caractere correspondant
		--il peut recuperer des octets supplementaires si besoin a l'aide de la fonction 'octet_suivant'
		--remplace l'ancien reste par le nouveau
		procedure Decodage_Code(Reste : in out TabBits;
			Position : in out Positive;
			Arbre_Huffman : Arbre;
			Caractere : out Character);
private
	type Noeud;
	type Arbre is access Noeud;

	type Direction is (Gauche, Droite);
	type Tableau_Fils is array (Direction) of Arbre;
end;
