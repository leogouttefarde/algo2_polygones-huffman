with Ada.Text_IO, Comparaisons, File_Priorite;
use Ada.Text_IO, Comparaisons;

package body Arbre_Huffman is

	package File_Arbres is new File_Priorite(Natural, Compare, Arbre);
	use File_Arbres;

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


	-- Export .dot d'arbre
	procedure Export(Dest : String ; Racine : Arbre) is

		procedure Subtree(File : Ada.Text_IO.File_Type ; Racine : Arbre ; Index : in out Natural) is
			Cur : Natural := Index + 1;
		begin
			if Racine /= null then
				Index := Cur;
				Put(File, " -- " & Natural'Image(Cur) );

				if Racine.EstFeuille then
					Put_Line( File, "   " & Natural'Image(Cur)
						& " [label=""" & Character'Image(Racine.Char)
						& """]");
				else
					Subtree(File, Racine.Fils(0), Index);
					Put_Line( File, "   " & Natural'Image(Cur)
						& " [label="" ""]");

					Put(File, "   " & Natural'Image(Cur) );
					Subtree(File, Racine.Fils(1), Index);
				end if;
			else
				New_Line(File);
			end if;
		end;

		File : Ada.Text_IO.File_Type;
		Index : Natural := 0;
		Cur : Natural := Index;
	begin
		if Racine /= null then

			Create( File => File, Mode => Out_File, Name => Dest );

			New_Line(File);
			Put_Line(File, "graph { ");

			if Racine.EstFeuille then
				Put_Line( File, "   " & Natural'Image(Cur)
					& " [label=""" & Character'Image(Racine.Char)
					& """]");
			else
				Put_Line( File, "   " & Natural'Image(Cur)
					& " ");
				Put_Line( File, "   " & Natural'Image(Cur)
					& " [label="" ""]");
			end if;


			Put(File, "   " & Natural'Image(Cur));
			Subtree(File, Racine.Fils(0), Index);
			Put(File, "   " & Natural'Image(Cur));
			Subtree(File, Racine.Fils(1), Index);
			Put_Line(File, "}");
			New_Line(File);

			Close(File);

		end if;
	exception
		when others => NULL;
	end;




	procedure Affiche_Arbre(A: Arbre) is
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

	--algo principal : calcul l'arbre a partir des frequences
	function Calcul_Arbre(Frequences : in Tableau_Ascii) return Arbre is
		A : Arbre;
		Fils0, Fils1 : Arbre;
		F : File := Nouvelle_File(Frequences'Length);
		Statut : Boolean := True;
		P1, P2 : Natural;
	begin
		for Char in Frequences'Range loop
			if Frequences(Char) > 0 then
				Insertion(F, Frequences(Char), new Noeud'(True, Char));
			end if;
		end loop;

		while Statut loop
			Meilleur(F, P1, Fils0, Statut);
			Suppression(F);

			if Statut then
				Meilleur(F, P2, Fils1, Statut);
			end if;

			if Statut then
				Suppression(F);
				Insertion(F, P1 + P2, new Noeud'(False, (Fils1, Fils0)));
			else
				A := Fils0;
			end if;
		end loop;

		Liberation(F);

		return A;
	end Calcul_Arbre;

	function Calcul_Dictionnaire(A : Arbre) return Dico is
		D : Dico;

		function CreateCode(iCode : Natural ; Taille : Natural) return Code is
			nCode : Code := new TabBits( 1 .. Taille );
			cCode : Natural := iCode;
		begin
			for i in reverse nCode'Range loop
				nCode(i) := cCode mod 2;
				cCode := cCode / 2;
			end loop;

			-- if cCode /= 0 then
			-- 	Put_Line("Erreur, reste : " & Natural'Image(cCode));
			-- end if;

			-- Put(Natural'Image(iCode) & " = " );
			-- for i in nCode'Range loop
			-- 	Put(Integer'Image(nCode(i)));
			-- end loop;
			-- New_Line;

			return nCode;
		end;

		procedure Calcul_Codes(D : in out Dico ; A : Arbre ; pCode : Natural ; pTaille : Natural) is
			cCode : Natural := pCode * 2;
			Taille : Natural := pTaille + 1;
		begin
			if A /= null then
				if A.EstFeuille then
					-- Put(A.Char);
					D(A.Char) := CreateCode(pCode, pTaille);
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
		-- Put_Line("");
		-- Put_Line("");
		-- Put_Line("Affiche_Arbre 0");
		-- Affiche_Arbre(A);
		-- Put_Line("");
		-- Put_Line("");

		Export("arbre.dot", A);

		-- New_Line;
		Calcul_Codes(D, A, 0, 0);

		return D;
	end;

	procedure Liberer_Dictionnaire(D : in out Dico) is
	begin
		for i in D'Range loop
			if D(i) /= null then
				Liberer( D(i) );
			end if;
		end loop;
	end;


	procedure Decodage_Code(Reste : in out TabBits;
		Position : in out Positive;
		Arbre_Huffman : Arbre;
		Caractere : out Character) is

		Position_Courante : Arbre;
		Octet : Natural;
	begin
		Position_Courante := Arbre_Huffman;

		while not Position_Courante.EstFeuille loop

			if Position > Reste'Last then

				-- Chargement de l'octet suivant du fichier
				Position := Reste'First;
				Caractere := Octet_Suivant;
				Octet := Character'Pos(Caractere);

				for I in reverse Reste'Range loop
					Reste(I) := Octet mod 2;
					Octet := Octet / 2;
				end loop;
			end if;

			Position_Courante := Position_Courante.Fils(Reste(Position)) ;
			Position := Position + 1;
		end loop;

		Caractere := Position_Courante.Char;
	end;


	function Comptage_Feuilles(A : Arbre) return Natural is
		Nombre : Natural := 0;
	begin
		if A /= null then
			if A.EstFeuille then
				Nombre := 1;
			else
				Nombre := Comptage_Feuilles(A.Fils(0));
				Nombre := Nombre + Comptage_Feuilles(A.Fils(1));
			end if;
		end if;

		return Nombre;
	end;

	procedure Encodage_Arbre(A : Arbre ; Index : in out Positive ;
				Encodage : in out TabBits) is
		Octet : Integer;
	begin
		if A /= null then
			if A.EstFeuille then
				Encodage(Index) := 1;
				Index := Index + 1;

				Octet := Character'Pos(A.Char);
				for i in reverse 0 .. 7 loop
					Encodage(Index + i) := Octet mod 2;
					Octet := Octet / 2;
				end loop;

				Index := Index + 8;
			else
				Encodage(Index) := 0;
				Index := Index + 1;

				Encodage_Arbre(A.Fils(0), Index, Encodage);
				Encodage_Arbre(A.Fils(1), Index, Encodage);
			end if;
		end if;
	end;

	procedure Stockage_Huffman(SAccess : in out Stream_Access ; Arbre_Huffman : Arbre) is
		NbFeuilles : constant Natural := Comptage_Feuilles(Arbre_Huffman);
		Taille : constant Natural := 10 * NbFeuilles - 1;
		Encodage : TabBits(1 .. Taille);
		Bit : Integer;
		Octet : Integer;
		Position : Natural := Encodage'First;
		Index : Natural := Encodage'First;
	begin
		Encodage_Arbre(Arbre_Huffman, Index, Encodage);

		while Position < Encodage'Last loop

			Octet := 0;

			for i in 0 .. 7 loop
				Index := Position + i;

				if Index > Encodage'Last then
					Bit := 0;
				else
					Bit := Encodage(Index);
				end if;

				Octet := Octet * 2 + Bit;
			end loop;

			Character'Output(SAccess, Character'Val(Octet));
			Position := Position + 8;
		end loop;
	end;

	function Lire_Bit(SAccess : in out Stream_Access ; Index : in out Natural ;
				Reste : in out TabBits) return Integer is
		Bit : Integer;
		Caractere : Character;
		Octet : Integer;
	begin
		if Index > Reste'Last then
			Index := Reste'First;
			Caractere := Character'Input(SAccess);
			Octet := Character'Pos(Caractere);

			for i in reverse Reste'Range loop
				Reste(i) := Octet mod 2;
				Octet := Octet / 2;
			end loop;
		end if;

		Bit := Reste(Index);
		Index := Index + 1;

		return Bit;
	end;

	function Creer_Huffman(SAccess : in out Stream_Access ; Index : in out Natural ;
				Reste : in out TabBits) return Arbre is
		A : Arbre;
		Fils0, Fils1 : Arbre;
		Bit : Integer;
		Octet : Integer := 0;
	begin
		Bit := Lire_Bit(SAccess, Index, Reste);

		if Bit = 0 then
			Fils0 := Creer_Huffman(SAccess, Index, Reste);
			Fils1 := Creer_Huffman(SAccess, Index, Reste);

			A := new Noeud'(False, (Fils0, Fils1));
		else
			for i in Reste'Range loop
				Octet := Octet * 2 + Lire_Bit(SAccess, Index, Reste);
			end loop;

			A := new Noeud'(True, Character'Val(Octet));
		end if;

		return A;
	end;

	function Lecture_Huffman(SAccess : in out Stream_Access) return Arbre is
		Reste : TabBits(1 .. 8);
		Index : Natural := Reste'Last + 1;
	begin
		return Creer_Huffman(SAccess, Index, Reste);
	end;


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
