with Ada.Numerics.Elementary_Functions;
use Ada.Numerics.Elementary_Functions;

package body Geometry is

	function "+" (P1, P2 : Point) return Point is
		P : Point;
	begin
		P.X := P1.X + P2.X;
		P.Y := P1.Y + P2.Y;
		return P;
	end;

	function "-" (P1, P2 : Point) return Point is
		P : Point;
	begin
		P.X := P1.X - P2.X;
		P.Y := P1.Y - P2.Y;
		return P;
	end;

	function "*" (P : Point ; F : Float) return Point is
		R : Point;
	begin
		R.X := P.X * F;
		R.Y := P.Y * F;
		return R;
	end;

	function Rotate(P : Point ; Angle : Float) return Point is
		R : Point;
	begin
		R.X := P.X * Cos(Angle, 360.0) - P.Y * Sin(Angle, 360.0);
		R.Y := P.X * Sin(Angle, 360.0) + P.Y * Cos(Angle, 360.0);
		return R;
	end Rotate;

	function Rotate(P : Point ; O : Point ; Angle : Float) return Point is
		R : Point;
	begin
		R := P - O;
		R := Rotate ( R, Angle ) + O;
		return R;
	end Rotate;

	function Distance(P1, P2 : Point) return Float is
		Tmp : Point;
	begin
		Tmp := P2 - P1;
		return Sqrt(Tmp.X*Tmp.X+Tmp.Y*Tmp.Y);
	end Distance;

end Geometry;
