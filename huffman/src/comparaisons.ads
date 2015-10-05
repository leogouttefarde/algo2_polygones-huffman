
-- Introduit le type énuméré des comparaisons
package Comparaisons is

	type Comparaison is (EQ, INF, SUP) ;

	-- Comparaison pour l'ordre "<=" sur les Integer
	function Compare(X,Y: Integer) return Comparaison ;

	-- Comparaison pour l'ordre "<=" sur les Character
	function Compare(X,Y: Character) return Comparaison ;

	-- Comparaison pour l'ordre "<=" sur les String
	function Compare(S1,S2: String) return Comparaison ;

end Comparaisons ;
