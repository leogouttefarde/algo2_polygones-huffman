with Ada.Text_IO, Comparaisons, File_Priorite;
use Ada.Text_IO, Comparaisons;

package body Arbre_Huffman is

	package File_Arbre is new File_Priorite(Natural, Compare, Arbre);
	use File_Arbre;

	type TabFils is array(ChiffreBinaire) of Arbre ;

	type Noeud(EstFeuille: Boolean) is record
		case EstFeuille is
			when True => Char : Character;
			when False =>
				Fils: TabFils;
				-- on a: Fils(0) /= null and Fils(1) /= null
		end case ;
	end record;

	procedure Liberer_Noeud is new Ada.Unchecked_Deallocation(Noeud, Arbre);


	-- Affiche le contenu des feuilles d'un arbre sur la sortie standard
	-- (en décommentant les lignes commentées, affiche l'arbre complet)
	procedure Affiche_Arbre(A : Arbre) is
	begin
		if A /= null then
			if A.EstFeuille then
				Put(Character'Image(A.Char) & " ");
				-- New_Line;
			else
				-- Put_Line("Gauche");
				Affiche_Arbre(A.Fils(0));
				-- Put_Line("Droite");
				Affiche_Arbre(A.Fils(1));
				-- Put_Line("Fin");
			end if;
		end if;
	end Affiche_Arbre;

	-- Exporte un arbre vers un fichier au format DOT
	procedure Export(Dest : String ; A : Arbre) is

		procedure Subtree(File : Ada.Text_IO.File_Type ; A : Arbre ; Index : in out Natural) is
			Cur : Natural := Index + 1;
		begin
			if A /= null then
				Index := Cur;
				Put(File, " --" & Natural'Image(Cur) );

				if A.EstFeuille then
					Put_Line( File, "   " & Natural'Image(Cur)
						& " [label=""" & Character'Image(A.Char)
						& """]");
				else
					Subtree(File, A.Fils(0), Index);
					Put_Line( File, "   " & Natural'Image(Cur)
						& " [label=""""]");

					Put(File, "   " & Natural'Image(Cur) );
					Subtree(File, A.Fils(1), Index);
				end if;
			else
				New_Line(File);
			end if;
		end;

		File : Ada.Text_IO.File_Type;
		Index : Natural := 0;
		Cur : Natural := Index;
	begin
		if A /= null then

			Create( File => File, Mode => Out_File, Name => Dest );

			New_Line(File);
			Put_Line(File, "graph { ");

			if A.EstFeuille then
				Put_Line( File, "   " & Natural'Image(Cur)
					& " [label=""" & Character'Image(A.Char)
					& """]");
			else
				Put_Line( File, "   " & Natural'Image(Cur)
					& " ");
				Put_Line( File, "   " & Natural'Image(Cur)
					& " [label=""ε""]");
			end if;


			Put(File, "   " & Natural'Image(Cur));
			Subtree(File, A.Fils(0), Index);
			Put(File, "   " & Natural'Image(Cur));
			Subtree(File, A.Fils(1), Index);
			Put_Line(File, "}");
			New_Line(File);

			Close(File);

		end if;
	exception
		when others => NULL;
	end;

	-- Calcul de l'arbre de Huffman à partir des fréquences
	function Calcul_Arbre(Frequences : in Tableau_Ascii) return Arbre is
		A : Arbre;
		Fils0, Fils1 : Arbre;
		F : File := Nouvelle_File(Frequences'Length);
		Statut : Boolean := True;
		P1, P2 : Natural;
	begin
		-- Ajout d'une feuille à la file de priorité
		-- pour chaque caractère du fichier
		for Char in Frequences'Range loop
			if Frequences(Char) > 0 then
				Insertion(F, Frequences(Char), new Noeud'(True, Char));
			end if;
		end loop;

		-- Construction de l'arbre de Huffman
		while Statut loop
			Meilleur(F, P1, Fils0, Statut);

			-- S'il y a un arbre de priorité minimale
			if Statut then
				Suppression(F);
				Meilleur(F, P2, Fils1, Statut);
			end if;

			-- S'il y a un nouvel arbre de priorité minimale
			if Statut then
				Suppression(F);

				-- On fusionne les deux arbres avant de les ajouter à la file
				Insertion(F, P1 + P2, new Noeud'(False, (Fils1, Fils0)));

			-- Sinon, l'arbre de Huffman est
			-- le dernier arbre extrait : Fils0
			else
				A := Fils0;
			end if;
		end loop;

		Liberation(F);

		return A;
	end Calcul_Arbre;

	-- Crée un dictionnaire contenant
	-- les codes de l'arbre de Huffman donné
	function Calcul_Dictionnaire(A : Arbre) return Dico is
		D : Dico;

		-- Conversion d'un entier en tableau de bits
		function Creer_Code(iCode : Natural ; Taille : Natural) return Code is
			nCode : Code := new TabBits( 1 .. Taille );
			cCode : Natural := iCode;
		begin
			for i in reverse nCode'Range loop
				nCode(i) := cCode mod 2;
				cCode := cCode / 2;
			end loop;

			return nCode;
		end;

		-- Calcul du code de chaque feuille de l'arbre de Huffman
		procedure Calcul_Codes(D : in out Dico ; A : Arbre ; pCode : Natural ; pTaille : Natural) is
			cCode : Natural := pCode * 2;
			Taille : Natural := pTaille + 1;
		begin
			if A /= null then

				-- Si on est sur une feuille,
				-- on ajoute son code au dictionnaire
				if A.EstFeuille then
					D(A.Char) := Creer_Code(pCode, pTaille);

				-- Si on est sur un noeud, on calcule les codes de ses fils
				else
					if A.Fils(0) /= null then
						Calcul_Codes(D, A.Fils(0), cCode, Taille);
					end if;

					if A.Fils(1) /= null then
						Calcul_Codes(D, A.Fils(1), cCode + 1, Taille);
					end if;
				end if;
			end if;
		end;
	begin
		-- Calcul récursif des codes de l'arbre
		-- à ajouter au dictionnaire
		Calcul_Codes(D, A, 0, 0);

		return D;
	end;

	-- Libère tous codes alloués
	procedure Liberer_Dictionnaire(D : in out Dico) is
	begin
		for i in D'Range loop
			if D(i) /= null then
				Liberer( D(i) );
			end if;
		end loop;
	end;

	-- Lit puis décode le prochain caractère depuis
	-- le fichier compressé
	procedure Decodage_Code(Reste : in out TabBits;
		Position : in out Positive;
		Arbre_Huffman : Arbre;
		Caractere : out Character) is

		Position_Courante : Arbre;
		Octet : Natural;
	begin
		Position_Courante := Arbre_Huffman;

		-- Tant qu'on a pas fini de décoder le prochain caractère
		while not Position_Courante.EstFeuille loop

			-- Si on a fini de lire l'octet courant (Reste),
			-- on passe au suivant
			if Position > Reste'Last then

				-- Chargement de l'octet suivant du fichier
				Position := Reste'First;
				Caractere := Octet_Suivant;
				Octet := Character'Pos(Caractere);

				-- Conversion de l'octet en tableau de bits
				for I in reverse Reste'Range loop
					Reste(I) := Octet mod 2;
					Octet := Octet / 2;
				end loop;
			end if;

			-- Avancée dans l'arbre
			Position_Courante := Position_Courante.Fils(Reste(Position)) ;
			Position := Position + 1;
		end loop;

		Caractere := Position_Courante.Char;
	end;


	-- Calcule le nombre de feuilles d'un arbre
	function Comptage_Feuilles(A : Arbre) return Natural is
		Nombre : Natural := 0;
	begin
		if A /= null then
			if A.EstFeuille then
				Nombre := 1;
			else
				Nombre := Comptage_Feuilles(A.Fils(0))
					+ Comptage_Feuilles(A.Fils(1));
			end if;
		end if;

		return Nombre;
	end;

	-- Encode un arbre en tableau de bits
	procedure Encodage_Arbre(A : Arbre ; Index : in out Positive ;
				Encodage : in out TabBits) is
		Octet : Integer;
	begin
		if A /= null then

			-- On code une feuilles par un 1 puis
			-- son caractère sur 8 bits
			if A.EstFeuille then
				Encodage(Index) := 1;
				Index := Index + 1;

				-- Conversion du caractère en tableau de bits
				Octet := Character'Pos(A.Char);
				for i in reverse 0 .. 7 loop
					Encodage(Index + i) := Octet mod 2;
					Octet := Octet / 2;
				end loop;

				Index := Index + 8;

			-- On code un noeud par un 0 suivi de ses fils
			else
				Encodage(Index) := 0;
				Index := Index + 1;

				-- Encodage du fils gauche puis du droit
				Encodage_Arbre(A.Fils(0), Index, Encodage);
				Encodage_Arbre(A.Fils(1), Index, Encodage);
			end if;
		end if;
	end;

	-- Stocke un arbre de Huffman dans le fichier ouvert par SAccess
	procedure Stockage_Huffman(SAccess : in out Stream_Access ; Arbre_Huffman : Arbre) is
		NbFeuilles : constant Natural := Comptage_Feuilles(Arbre_Huffman);
		Taille : constant Natural := 10 * NbFeuilles - 1; -- Il faut 10f-1 bits
		Encodage : TabBits(1 .. Taille);
		Bit : Integer;
		Octet : Integer;
		Position : Natural := Encodage'First;
		Index : Natural := Encodage'First;
	begin
		Encodage_Arbre(Arbre_Huffman, Index, Encodage);

		-- Ecriture de l'arbre encodé :
		-- tant qu'il reste des bits à écrire, on continue
		while Position < Encodage'Last loop

			Octet := 0;

			-- Extraction de l'octet suivant
			for i in 0 .. 7 loop
				Index := Position + i;

				-- S'il ne reste plus de bits à écrire,
				-- on complète le dernier octet par des 0
				if Index > Encodage'Last then
					Bit := 0;
				else
					Bit := Encodage(Index);
				end if;

				Octet := Octet * 2 + Bit;
			end loop;

			-- Ecriture d'un octet
			Character'Output(SAccess, Character'Val(Octet));
			Position := Position + 8;
		end loop;
	end;

	-- Lit et retourne le prochain bit du fichier ouvert dans SAccess
	function Lire_Bit(SAccess : in out Stream_Access ; Index : in out Natural ;
				Reste : in out TabBits) return Integer is
		Bit : Integer;
		Caractere : Character;
		Octet : Integer;
	begin
		-- Si on a fini de lire l'octet courant (Reste),
		-- on passe au suivant
		if Index > Reste'Last then
			Index := Reste'First;
			Caractere := Character'Input(SAccess);
			Octet := Character'Pos(Caractere);

			-- On convertit l'octet lu en tableau de bits
			for i in reverse Reste'Range loop
				Reste(i) := Octet mod 2;
				Octet := Octet / 2;
			end loop;
		end if;

		-- On récupère le prochain bit puis
		-- on incrémente l'index courant
		Bit := Reste(Index);
		Index := Index + 1;

		return Bit;
	end;

	-- Lit et retourne récursivement l'arbre de Huffman
	-- du fichier compressé ouvert dans SAccess
	function Creer_Huffman(SAccess : in out Stream_Access ; Index : in out Natural ;
				Reste : in out TabBits) return Arbre is
		A : Arbre;
		Fils0, Fils1 : Arbre;
		Bit : Integer;
		Octet : Integer := 0;
	begin
		Bit := Lire_Bit(SAccess, Index, Reste);

		-- Si on lit un 0, c'est un noeud
		if Bit = 0 then

			-- On lit d'abord les fils du noeud
			Fils0 := Creer_Huffman(SAccess, Index, Reste);
			Fils1 := Creer_Huffman(SAccess, Index, Reste);

			A := new Noeud'(False, (Fils0, Fils1));

		-- Sinon on a un 1 et c'est une feuille
		else
			-- On lit le caractère sur 8 bits de la feuille
			for i in Reste'Range loop
				Octet := Octet * 2 + Lire_Bit(SAccess, Index, Reste);
			end loop;

			A := new Noeud'(True, Character'Val(Octet));
		end if;

		return A;
	end;

	-- Lit et retourne l'arbre de Huffman
	-- du fichier compressé ouvert dans SAccess
	function Lecture_Huffman(SAccess : in out Stream_Access) return Arbre is
		Reste : TabBits(1 .. 8);
		Index : Natural := Reste'Last + 1;
	begin
		return Creer_Huffman(SAccess, Index, Reste);
	end;

	-- Libère récursivement un arbre et ses fils
	procedure Liberer_Arbre(A : in out Arbre) is
	begin
		if A /= null then
			if not A.EstFeuille then
				Liberer_Arbre(A.Fils(0));
				Liberer_Arbre(A.Fils(1));
			end if;

			Liberer_Noeud(A);
		end if;
	end;

end;
