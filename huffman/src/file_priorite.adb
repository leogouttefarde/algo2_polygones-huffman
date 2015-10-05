
With Ada.Text_IO;
use Ada.Text_IO;

package body File_Priorite is

	-- Cree et retourne une nouvelle file
	-- pouvant contenir au plus 'Taille' elements
	function Nouvelle_File(Taille : Positive) return File is
		F : File := new File_Interne(Taille);
	begin
		return F;
	end Nouvelle_File;

	-- Insère un élément de priorité donnée
	procedure Insertion(F : in out File; P : Priorite; D : Donnee) is
		Elem : Element;
		iCur, iPere : Natural;
	begin
		-- S'il reste de la place dans la file
		if F /= null and then F.Taille < F.Tas'Length then

			-- On ajoute l'élément à la prochaine position
			iCur := F.Taille + 1;
			F.Tas(iCur) := (P, D);

			-- Mise à jour de la taille de file
			F.Taille := iCur;

			-- On place le nouvel élément dans l'arbre :
			-- tant qu'il est meilleur que son père, on les permute
			iPere := iCur / 2;
			while (iCur > 1) and then Compare(F.Tas(iCur).P, F.Tas(iPere).P) = INF loop
				Elem := F.Tas(iCur);
				F.Tas(iCur) := F.Tas(iPere);
				F.Tas(iPere) := Elem;

				iCur := iPere;
				iPere := iCur / 2;
			end loop;
		end if;
	end Insertion;

	-- Récupère l'élément de meilleure priorité (le laisse dans la file)
	-- Met le statut à Faux si la file est vide
	procedure Meilleur(F : in File; P : out Priorite; D : out Donnee; Statut : out Boolean) is
	begin
		-- S'il y a un élément dans la file,
		-- on renvoie le premier (et donc le meilleur)
		if F /= null and then F.Taille > 0 then
			P := F.Tas(1).P;
			D := F.Tas(1).D;

			Statut := True;
		else
			Statut := False;
		end if;
	end;

	-- Supprime l'élément de meilleure priorité
	procedure Suppression(F : in out File) is
		Elem : Element;
		iCur, Fils : Natural;
		Fin : Boolean := False;
	begin
		-- S'il y a un élément dans la file,
		-- on supprime le premier et on réorganise la file
		if F /= null and then F.Taille > 0 then

			-- On place le dernier élément au début
			F.Tas(1) := F.Tas(F.Taille);

			-- On décrémente la taille
			F.Taille := F.Taille - 1;

			-- On réorganise la file tant qu'on est pas sur une feuille
			iCur := 1;
			while iCur <= (F.Taille / 2) and not Fin loop
				Fils := 2 * iCur;

				-- Si le fils gauche (Fils) n'est pas dernier élément et qu'il est
				-- moins bon que le fils droit, on va comparer le père au fils droit
				if (Fils /= F.Taille) and Compare(F.Tas(Fils).P, F.Tas(Fils + 1).P) /= INF then
					Fils := Fils + 1;
				end if;

				-- Si le fils à comparer est meilleur que son père, on les échange
				if Compare(F.Tas(iCur).P, F.Tas(Fils).P) = SUP then
					Elem := F.Tas(iCur);
					F.Tas(iCur) := F.Tas(Fils);
					F.Tas(Fils) := Elem;
					iCur := Fils;

				-- Sinon, réorganisation terminée
				else
					Fin := True;
				end if;
			end loop;
		end if;
	end;

	-- Libère une file
	procedure Liberation(F : in out File) is
	begin
		if F /= null then
			Liberer(F);
		end if;
	end;

end;
