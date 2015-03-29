with Ada.Text_IO, Ada.Float_Text_IO, Ada.Integer_Text_IO;
use Ada.Text_IO, Ada.Float_Text_IO, Ada.Integer_Text_IO;

package body SVG is

        Display_Width, Display_Height : Float;

        procedure Svg_Line(P1, P2 : SimplePoint ; C : Color) is
        begin
                Put("<line x1=""");
                Put(P1.X);
                Put(""" y1=""");
                Put(P1.Y);
                Put(""" x2=""");
                Put(P2.X);
                Put(""" y2=""");
                Put(P2.Y);
                Put(""" style=""stroke:");
                case C is
                        when Red => Put("rgb(255,0,0)");
                        when Green => Put("rgb(0,255,0)");
                        when Blue => Put("rgb(0,0,255)");
                        when Black => Put("rgb(0,0,0)");
                end case;
                Put_Line(";stroke-width:0.2""/>");
        end Svg_Line;

        procedure Svg_Header(Width, Height : Natural) is
        begin
                Put_Line("<svg width="""
                & Natural'Image( Width )
                & """ height="""
                & Natural'Image( Height )
                & """>");

                Display_Width := Float(Width);
                Display_Height := Float(Height);
        end Svg_Header;

        -- Svg_Rect(Width, Height : Integer ; Color : Color)
        -- (type Points is array(Positive range<>) of Float;)

        procedure Svg_Polygon(Points : Point_Lists.List) is
                Point_Pos : Point_Lists.Cursor;
                cPoint : Point;
        begin
                Put("<polygon points=""");

                -- algo + print new segs
                Point_Pos := Point_Lists.First( Points );

                while Point_Lists.Has_Element( Point_Pos ) loop
                        cPoint := Point_Lists.Element( Point_Pos );

                        Put(Float'Image(cPoint.Pt.X) & "," & Float'Image(cPoint.Pt.Y) & " ");

                        Point_Lists.Next( Point_Pos );
                end loop;

                Put_Line(""" style=""fill:blue;fill-opacity:0.5""/>");

        end Svg_Polygon;

        procedure Svg_Footer is
        begin
                Put_Line("</svg>");
        end Svg_Footer;

end SVG;
