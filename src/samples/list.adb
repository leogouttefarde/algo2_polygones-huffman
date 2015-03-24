
package body Tree is

	-- Crée un arbre contenant uniquement un noeud racine
	function New_Tree return Tree is
		T : Tree := new Node;
	begin
		T.Parent := null;

		for i in T.Childs'range loop
			T.Childs(i) := null;
		end loop;

		T.Words := null;

		return T;
	end;

	-- Libère récursivement un arbre
	procedure Free_Tree(T : in out Tree) is
	begin
		if T /= null then
			for i in T.Childs'range loop
				Free_Tree ( T.Childs(i) );
			end loop;

			if T.Words /= null then
				Free_List ( T.Words );
			end if;

			Free_Node ( T );
			T := null;
		end if;
	end;

	-- Compte le nombre d'apparitions de chaque lettre de l'alphabet dans un mot,
	-- sans prêter attention à la casse des lettres
	procedure Letter_Counts(Word : in String ; Counts : out Alphabet) is
		L : Character;
		Nb : Natural;
	begin
		Counts := (others => 0);

		for i in Word'range loop
			L := To_Lower( Word(i) );
			Nb := Counts( L );

			-- Le nombre de lettres ne doit pas dépasser la valeur maximale
			if Nb < M then
				Nb := Nb + 1;
			end if;

			Counts( L ) := Nb;
		end loop;
	end;

	-- Insère un mot dans un arbre
	procedure Insertion(T : in out Tree ; Word : in String) is

		LetterCounts : Alphabet;

		-- Procédure d'insertion récursive
		procedure Insertion_Rec(T : in out Tree ; Word : in String ; Counts : in Alphabet ; i : in Natural) is
			C : Character;
			Child : Tree;
			Nb : Natural := 0;
		begin
			if i < Alphabet'Length then
				C := Character'Val(Character'Pos('a') + i);
				Nb := Counts(C);
				Child := T.Childs(Nb);

				-- Si l'enfant concerné n'existe pas, on le crée
				if Child = null then
					Child := new Node;
					Child.Parent := T;
					T.Childs(Nb) := Child;
				end if;

				Insertion_Rec(Child, Word, Counts, i+1);
			else
				-- Si la liste de mots n'existe pas, on la crée
				if T.Words = null then
					T.Words := new String_Lists.List;
				end if;

				String_Lists.Append( T.Words.all, To_Unbounded_String(Word) );
			end if;
		end;
	begin
		Letter_Counts ( Word, LetterCounts );
		Insertion_Rec ( T, Word, LetterCounts, 0 );
	end;


	-- Recherche les mots correspondant aux lettres demandées dans un arbre
	procedure Search_And_Display(T : in Tree ; Letters : in String) is

		LetterCounts : Alphabet;

		-- Procédure de recherche récursive
		procedure Search_And_Display_Rec(T : in Tree ; Counts : in Alphabet ; i : in Natural) is
			C : Character;
			Child : Tree;
			Nb : Natural;
			Position : String_Lists.Cursor;
		begin
			if T /= null then

				-- On parcoure tout l'alphabet avant d'arriver à une feuille
				if i < Alphabet'Length then
					C := Character'Val(Character'Pos('a') + i);
					Nb := Counts( C );

					-- On continue récursivement dans toutes les branches de taille <= Nb
					for j in reverse 0 .. Nb loop
						Child := T.Childs(j);

						-- Si branche vide ne pas continuer 
						if Child /= null then
							Search_And_Display_Rec(Child, Counts, i+1);
						end if;
					end loop;

				else
					if T.Words /= null then
						Position := String_Lists.First( T.Words.all );

						-- Affichage des mots d'une feuille
						while String_Lists.Has_Element( Position ) loop
							Put_Line( To_String ( String_Lists.Element( Position ) ) );
							String_Lists.Next( Position );
						end loop;
					end if;
				end if;
			end if;
		end;

	begin
		Letter_Counts ( Letters, LetterCounts );
		Search_And_Display_Rec ( T, LetterCounts, 0 );
	end;

end Tree;
