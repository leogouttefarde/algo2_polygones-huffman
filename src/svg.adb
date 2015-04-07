
package body SVG is

        Width, Height : Float;
        Scale : Float := 1.0;
        Base : SimplePoint := (0.0, 0.0);


        -- Améliore la compatibilité des valeurs Float au sein du fichier SVG
        -- en enlevant l'espace mis au début par Float'Image.
        -- KolourPaint ne reconnaît pas les lignes notamment sinon.
        function SClean(iString : String) return String is
        begin
                return iString(iString'First + 1 .. iString'Last);
        end;

        procedure PutF(Value : Float) is
        begin
                Put( SClean( Float'Image(Value) ) );
        end;


        -- Prépare l'affichage des points donnés
        -- à l'échelle des dimensions déclarées via Svg_Header
        procedure Svg_Scale(Points : Point_Lists.List) is
                Point_Pos : Point_Lists.Cursor;
                cPoint : Point;
                sPoint : SimplePoint;
                X_Min : Float := 0.0;
                X_Max : Float := Width;
                Y_Min : Float := 0.0;
                Y_Max : Float := Height;
                rWidth : Float := Width;
                rHeight : Float := Height;
                Scale_X : Float := 1.0;
                Scale_Y : Float := 1.0;
        begin
                Point_Pos := Point_Lists.First( Points );

                cPoint := Point_Lists.Element( Point_Pos );
                sPoint := cPoint.Pt;

                X_Min := sPoint.X;
                X_Max := sPoint.X;
                Y_Min := sPoint.Y;
                Y_Max := sPoint.Y;

                while Point_Lists.Has_Element( Point_Pos ) loop
                        cPoint := Point_Lists.Element( Point_Pos );
                        sPoint := cPoint.Pt;

                        if sPoint.X > X_Max then
                                X_Max := sPoint.X;
                        end if;

                        if sPoint.X < X_Min then
                                X_Min := sPoint.X;
                        end if;

                        if sPoint.Y > Y_Max then
                                Y_Max := sPoint.Y;
                        end if;

                        if sPoint.Y < Y_Min then
                                Y_Min := sPoint.Y;
                        end if;

                        Point_Lists.Next( Point_Pos );
                end loop;

                -- Calcul des dimensions réelles de la figure
                rWidth := X_Max - X_Min;
                rHeight := Y_Max - Y_Min;

                -- Calcul du redimensionnement à appliquer à la figure
                Scale_X := Width / rWidth;
                Scale_Y := Height / rHeight;
                Scale := Float'Min(Scale_X, Scale_Y);
                Scale := Scale * 0.8;

                -- Calcul de la translation à appliquer à la figure
                Base.X := 0.1 * Scale_X * rWidth - X_Min * Scale;
                Base.Y := 0.1 * Scale_Y * rHeight - Y_Min * Scale;

        end Svg_Scale;


        -- Affiche une ligne de P1 à P2
        procedure Svg_Line(P1, P2 : SimplePoint ; C : Color) is
                cP1 : SimplePoint := Base + P1 * Scale;
                cP2 : SimplePoint := Base + P2 * Scale;
        begin
                Put("<line x1=""");
                PutF(cP1.X);
                Put(""" y1=""");
                PutF(cP1.Y);
                Put(""" x2=""");
                PutF(cP2.X);
                Put(""" y2=""");
                PutF(cP2.Y);
                Put(""" stroke=""");
                case C is
                        when Red => Put("red");
                        when Green => Put("green");
                        when Blue => Put("blue");
                        when Black => Put("black");
                end case;
                Put_Line(""" stroke-width=""4""/>");
        end Svg_Line;

        procedure Svg_Rect(iWidth, iHeight : Natural) is
        begin
                Put_Line("<rect width="""
                & Natural'Image( iWidth )
                & """ height="""
                & Natural'Image( iHeight )
                & """ fill=""white""/>");

                Width := Float(iWidth);
                Height := Float(iHeight);
        end;

        -- Génère le header SVG, à exécuter en premier
        procedure Svg_Header(iWidth, iHeight : Natural) is
        begin
                Put_Line("<svg width="""
                & Natural'Image( iWidth )
                & """ height="""
                & Natural'Image( iHeight )
                & """>");

                Svg_Rect(iWidth, iHeight);


                Width := Float(iWidth);
                Height := Float(iHeight);
        end Svg_Header;

        -- Affiche un polygone
        procedure Svg_Polygon(Points : Point_Lists.List) is
                Point_Pos : Point_Lists.Cursor;
                cPoint : Point;
        begin
                Put("<polygon points=""");

                -- Parcours et affichage de chaque point du polygone
                Point_Pos := Point_Lists.First( Points );

                while Point_Lists.Has_Element( Point_Pos ) loop
                        cPoint := Point_Lists.Element( Point_Pos );
                        cPoint.Pt := Base + cPoint.Pt * Scale;

                        PutF(cPoint.Pt.X);
                        Put(",");
                        PutF(cPoint.Pt.Y);
                        Put(" ");

                        Point_Lists.Next( Point_Pos );
                end loop;

                Put_Line(""" style=""fill:royalblue;fill-opacity:0.5""/>");

        end Svg_Polygon;

        -- Génère le footer SVG, à exécuter à la fin
        procedure Svg_Footer is
        begin
                Put_Line("</svg>");
        end Svg_Footer;

end SVG;
