with Ada.Unchecked_Deallocation, Ada.Streams.Stream_IO;
use Ada.Streams.Stream_IO;

package Arbre_Huffman is

	-- Tableau de stockage des fréquences
	type Tableau_Ascii is array(Character) of Natural;

	-- Type de chiffre binaire (bit)
	subtype ChiffreBinaire is Integer range 0 .. 1;

	-- Arbre
	type Arbre is private;

	-- Calcul de l'arbre de Huffman à partir des fréquences
	function Calcul_Arbre(Frequences : in Tableau_Ascii) return Arbre;

	-- Affiche le contenu des feuilles d'un arbre sur la sortie standard
	-- (en décommentant les lignes commentées, affiche l'arbre complet)
	procedure Affiche_Arbre(A : Arbre);

	-- Exporte un arbre vers un fichier au format DOT
	procedure Export(Dest : String ; A : Arbre);

	-- Code binaire
	type TabBits is array(Positive range <>) of ChiffreBinaire;
	type Code is access TabBits;
	procedure Liberer is new Ada.Unchecked_Deallocation(TabBits, Code);

	-- Dictionnaire des codes
	type Dico is array(Character) of Code;

	-- Crée un dictionnaire contenant
	-- les codes de l'arbre de Huffman donné
	function Calcul_Dictionnaire(A : Arbre) return Dico;

	-- Libère tous codes alloués
	procedure Liberer_Dictionnaire(D : in out Dico);

	-- Stocke un arbre de Huffman dans le fichier ouvert par SAccess
	procedure Stockage_Huffman(SAccess : in out Stream_Access ; Arbre_Huffman : Arbre);

	-- Lit et retourne l'arbre de Huffman
	-- du fichier compressé ouvert dans SAccess
	function Lecture_Huffman(SAccess : in out Stream_Access) return Arbre;

	-- Libère récursivement un arbre et ses fils
	procedure Liberer_Arbre(A : in out Arbre);

	generic
		with function Octet_Suivant return Character;

		-- Lit puis décode le prochain caractère depuis
		-- le fichier compressé
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
