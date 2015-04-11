
with Ada.Text_IO, Ada.Float_Text_IO, Ada.Integer_Text_IO;
use Ada.Text_IO, Ada.Float_Text_IO, Ada.Integer_Text_IO;
with Common; use Common;

package SVG is

        type Color is (Red, Green, Blue, Black);


        -- Génère le header SVG, à exécuter en premier
        procedure Svg_Header(iWidth, iHeight : Natural);

        -- Prépare l'affichage des points donnés
        -- à l'échelle des dimensions déclarées via Svg_Header
        procedure Svg_Scale(Points : Point_Lists.List);

        -- Affiche une ligne de P1 à P2
        procedure Svg_Line(P1, P2 : SimplePoint ; C : Color);

        -- Affiche un polygone
        procedure Svg_Polygon(Points : Point_Lists.List);

        -- Génère le footer SVG, à exécuter à la fin
        procedure Svg_Footer;

end SVG;
