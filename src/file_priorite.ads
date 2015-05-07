-- paquetage file de priorite

with Comparaisons, Ada.Unchecked_Deallocation;
use Comparaisons;

generic

	type Priorite is private;
	with function Compare(C1, C2: Priorite) return Comparaison;

	type Donnee is private;

package File_Priorite is

	type File is private;

	-- Cree une file pouvant contenir au plus 'Taille' elements
	function Nouvelle_File(Taille: Positive) return File;

	-- Insere un element de la priorite donnee
	procedure Insertion(F: in out File; P: Priorite; D: Donnee);

	-- Recupere l'element de meilleure priorite ; met le statut a Faux si la file est vide
	-- le laisse dans la file
	procedure Meilleur(F: in File; P: out Priorite; D: out Donnee; Statut: out Boolean);

	-- Supprime l'élément de meilleure priorité
	procedure Suppression(F: in out File);

	procedure Liberation(F : in out File);


private
	type File_Interne;
	type File is access File_Interne;

	type Element is record
		P : Priorite;
		D : Donnee;
	end record;

	type Tableau is array (integer range <>) of Element;

	type File_Interne (Taille_Max : Positive) is record
		Tas : Tableau(1 .. Taille_Max);
		Taille : Natural := 0;
	end record;

	procedure Liberer is new Ada.Unchecked_Deallocation(File_Interne, File);
end;
