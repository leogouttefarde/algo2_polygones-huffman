
with Ada.Text_IO;
use Ada.Text_IO;
with Common; use Common;
with Parseur; use Parseur;
with Decompose; use Decompose;


procedure Test_Comp is

        Points : Point_Lists.List;
        Segments : Segment_Lists.List;
begin
        Lire_Polygone("test/1.in", Points);
        Segments := Generate_Segments(Points);


end;
