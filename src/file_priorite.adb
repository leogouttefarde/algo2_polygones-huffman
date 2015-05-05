
With Ada.Text_IO;
use Ada.Text_IO;

package body File_Priorite is

	function Nouvelle_File(Taille: Positive) return File is
		F : File := new File_Interne;
	begin
		F.Taille_Max := Taille;
		F.Tete := null;
		F.Queue := null;

		return F;
	end Nouvelle_File;

	procedure Insertion(F: in out File; P: Priorite; D: Donnee) is
		Elem, cElem : pElement;
		Fin : Boolean := False;
	begin
		if F /= null and then F.Taille < F.Taille_Max then

			Elem := new Element'(P, D, null);
			cElem := F.Tete;

			if cElem = null then
				F.Tete := Elem;
				F.Queue := Elem;

			elsif Compare(P, cElem.P) = INF then
				F.Tete := Elem;
				Elem.Suiv := cElem;

			else
				while cElem.Suiv /= null and not Fin loop
					if Compare(P, cElem.Suiv.P) = INF then
						Fin := True;

						Elem.Suiv := cElem.Suiv;
						cElem.Suiv := Elem;
					end if;

					cElem := cElem.Suiv;
				end loop;

				if (cElem.Suiv = null) and not Fin then
					F.Queue.Suiv := Elem;
					F.Queue := Elem;
				end if;
			end if;

			F.Taille := F.Taille + 1;
		end if;
	end Insertion;

	procedure Meilleur(F: in File; P: out Priorite; D: out Donnee; Statut: out Boolean) is
	begin
		if F /= null and then F.Tete /= null then
			P := F.Tete.P;
			D := F.Tete.D;

			Statut := True;
		else
			Statut := False;
		end if;
	end;

	procedure Suppression(F: in out File) is
		Elem : pElement;
	begin
		if F /= null and then F.Tete /= null then
			Elem := F.Tete;
			F.Tete := Elem.Suiv;
			--Free(Elem);

			if F.Tete = null then
				F.Queue := null;
			end if;

			F.Taille := F.Taille - 1;
		end if;
	end;

end;
