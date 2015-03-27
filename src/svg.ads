
with Common; use Common;

package SVG is

        --type pPoint is access all Point;

        type Color is (Red, Green, Blue, Black);


        --appeller Svg_Header avant toute autre operation
        procedure Svg_Header(Width, Height : Natural);

        procedure Svg_Line(P1, P2 : SimplePoint ; C : Color);


        procedure Svg_Polygon(Points : Point_Lists.List);

        --appeller Svg_Footer lorsque l'image est terminee
        procedure Svg_Footer;

end SVG;
