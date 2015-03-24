
package Geometry is

	type Point is record
		X : Float;
		Y : Float;
	end record;

	--addition de vecteur
	--s'utilise comme ca : P : Point := P1 + P2;
	function "+" (P1, P2 : Point) return Point;
	function "-" (P1, P2 : Point) return Point;
	--multiplication d'un vecteur par un flotant
	--permet par exemple de calculer facilement
	--le milieu d'un segment
	--M : Point := (P1+P2)*0.5;
	function "*" (P : Point ; F : Float) return Point;
	--tourne un point P de Angle degres autour de l'origine
	function Rotate(P : Point ; Angle : Float) return Point;
	function Rotate(P : Point ; O : Point ; Angle : Float) return Point;
	--retourne la distance entre 2 points
	function Distance(P1, P2 : Point) return Float;

end Geometry;
