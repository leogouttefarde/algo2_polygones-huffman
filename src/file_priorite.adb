
With Ada.Text_IO;
use Ada.Text_IO;

package body File_Priorite is

	function Nouvelle_File(Taille: Positive) return File is
		F : File := new File_Interne(Taille);
	begin
		return F;
	end Nouvelle_File;

	procedure Insertion(F: in out File; P: Priorite; D: Donnee) is
		Elem : Element;
		iCur, iPere : Natural;
	begin
		if F /= null and then F.Taille < F.Tas'Length then
		
			iCur := F.Taille + 1;
			iPere := iCur / 2;

			F.Taille := iCur;
			F.Tas(iCur) := (P, D);

			while (iCur > 1) and then Compare(F.Tas(iCur).P, F.Tas(iPere).P) = INF loop
				Elem := F.Tas(iCur);
				F.Tas(iCur) := F.Tas(iPere);
				F.Tas(iPere) := Elem;

				iCur := iPere;
				iPere := iCur / 2;
			end loop;
		end if;
	end Insertion;

	procedure Meilleur(F: in File; P: out Priorite; D: out Donnee; Statut: out Boolean) is
	begin
		if F /= null and then F.Taille > 0 then
			P := F.Tas(1).P;
			D := F.Tas(1).D;

			Statut := True;
		else
			Statut := False;
		end if;
	end;

	procedure Suppression(F: in out File) is
		Elem : Element;
		iCur, Fils : Natural;
	begin
		if F /= null and then F.Taille > 0 then
			F.Tas(1) := F.Tas(F.Taille);
			F.Taille := F.Taille - 1;

			iCur := 1;
			while iCur <= (F.Taille / 2) loop
				Fils := 2 * iCur;
				if (Fils /= F.Taille) and Compare(F.Tas(Fils).P, F.Tas(Fils + 1).P) /= INF then
					Fils := Fils + 1;
				end if;

				if Compare(F.Tas(iCur).P, F.Tas(Fils).P) = SUP then
					Elem := F.Tas(iCur);
					F.Tas(iCur) := F.Tas(Fils);
					F.Tas(Fils) := Elem;
					iCur := Fils;
				else
					exit;
				end if;
			end loop;
		end if;
	end;

end;
