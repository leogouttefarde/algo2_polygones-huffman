with Ada.Text_IO, Comparaisons, File_Priorite;
use Ada.Text_IO, Comparaisons;

package body Arbre_Huffman is

	package Ma_File is new File_Priorite(Natural, Compare, Arbre);
	use Ma_File;

	type TabFils is array(ChiffreBinaire) of Arbre ;

	type Noeud(EstFeuille: Boolean) is record
		case EstFeuille is
			when True => Char : Character;
			when False =>
				Fils: TabFils;
				-- on a: Fils(0) /= null and Fils(1) /= null
		end case ;
	end record;


	-- Export .dot d'arbre
	procedure Export(Dest : String ; Racine : Arbre) is

		procedure Subtree(File : File_Type ; Racine : Arbre ; Index : in out Natural) is
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

		File : File_Type;
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
				New_Line;
			else
				Put_Line("Gauche");
				Affiche_Arbre(A.Fils(0));
				Put_Line("Droite");
				Affiche_Arbre(A.Fils(1));
				Put_Line("Fin");
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

			if cCode /= 0 then
				Put_Line("Erreur, reste : " & Natural'Image(cCode));
			end if;

			Put(Natural'Image(iCode) & " = " );
			for i in nCode'Range loop
				Put(Integer'Image(nCode(i)));
			end loop;
			New_Line;

			return nCode;
		end;

		procedure Calcul_Codes(D : in out Dico ; A : Arbre ; pCode : Natural ; pTaille : Natural) is
			cCode : Natural := pCode * 2;
			Taille : Natural := pTaille + 1;
		begin
			if A /= null then
				if A.EstFeuille then
					Put(A.Char);
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

		New_Line;
		Calcul_Codes(D, A, 0, 0);

		return D;
	end;

	procedure Decodage_Code(Reste : in out Code;
		Arbre_Huffman : Arbre;
		Caractere : out Character) is

		Position_Courante : Arbre;
		Tmp,R : Natural;
		Nouveau_Reste : Code;
	begin
		Position_Courante := Arbre_Huffman;
		while not Position_Courante.EstFeuille loop
			if Reste = null then
				--chargement de l'octet suivant du fichier
				Reste := new TabBits(1..8);
				Caractere := Octet_Suivant;
				Tmp := Character'Pos(Caractere);
				for I in Reste'Range loop
					R := Tmp mod 2;
					Reste(Reste'Last + Reste'First - I) := R;
					Tmp := Tmp / 2;
				end loop;
			end if;
			Position_Courante := Position_Courante.Fils(Reste(1)) ;
			if Reste'Last = 1 then
				Liberer(Reste);
				Reste := null;
			else
				-- TODO : modifier cette procedure
				-- pour eviter de faire a chaque iteration
				-- une allocation + 1 liberation
				Nouveau_Reste := new TabBits(1..(Reste'Last - 1));
				for I in Nouveau_Reste'Range loop
					Nouveau_Reste(I) := Reste(I+1);
				end loop;
				Liberer(Reste);
				Reste := Nouveau_Reste;
			end if;
		end loop;
		Caractere := Position_Courante.Char;
	end;

end;
