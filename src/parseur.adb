


package body Parseur is

        function ParseLine(File : File_Type) return Slice_Set is
                Elems : Slice_Set;
        begin
                if not End_Of_File(File) then
                        declare
                                Line : String := Get_Line(File);
                        begin
                                Create(Elems, Line, " " , Mode => Multiple);
                        end;
                end if;

                return Elems;
        end;

        procedure Lire_Polygone(Chemin : in String ; Points : out Point_Lists.List) is
                File : File_Type;
                Elems : Slice_Set;

                Count : Natural := 0;
                cPoint : Point;
                sPoint : SimplePoint;
        begin
                Open( File => File, Mode => In_File, Name => Chemin );

                Elems := ParseLine(File);
                Count := Integer'Value( Slice(Elems, 1) );



                for i in 1 .. Count loop

                        Elems := ParseLine(File);

                        sPoint.X := Float'Value( Slice(Elems, 1) );
                        sPoint.Y := Float'Value( Slice(Elems, 2) );
                        cPoint.Pt := sPoint;

                        Point_Lists.Append( Points, cPoint );

                end loop;


        exception
                -- Si une exception est levée,
                -- le fichier est invalide : on arrête l'exécution.
                when others =>
                        Put_Line("Polygone invalide.");
                        GNAT.OS_Lib.OS_Exit (1); -- On quitte le programme.
        end;

end Parseur;


