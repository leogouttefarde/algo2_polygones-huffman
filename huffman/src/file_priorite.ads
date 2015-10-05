
with Comparaisons, Ada.Unchecked_Deallocation;
use Comparaisons;

-- Paquetage des Files de priorité
generic

	type Priorite is private;
	with function Compare(C1, C2: Priorite) return Comparaison;

	type Donnee is private;

package File_Priorite is

	type File is private;

	-- Cree et retourne une nouvelle file
	-- pouvant contenir au plus 'Taille' elements
	function Nouvelle_File(Taille : Positive) return File;

	-- Insère un élément de priorité donnée
	procedure Insertion(F : in out File; P : Priorite; D : Donnee);

	-- Récupère l'élément de meilleure priorité (le laisse dans la file)
	-- Met le statut à Faux si la file est vide
	procedure Meilleur(F : in File; P : out Priorite; D : out Donnee; Statut : out Boolean);

	-- Supprime l'élément de meilleure priorité
	procedure Suppression(F : in out File);

	-- Libère une file
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
