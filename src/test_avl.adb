
with AVL;
with Ada.Text_IO;
use Ada.Text_IO;
with Common; use Common;


procedure Test_AVL is

        package Arbre_Entiers is new AVL(Integer, "<", ">");
        use Arbre_Entiers;

        procedure Affiche_Entier(Entier : Integer) is
        begin
                Put_Line( Integer'Image(Entier) );
        end;

        procedure Affichage_AVL is new Arbre_Entiers.Affichage ( Affiche_Entier );

        cAVL, V_petit, V_Grand : Arbre_Entiers.Arbre;
        pNoeud_2 : Arbre_Entiers.Arbre;
        pNoeud_6 : Arbre_Entiers.Arbre;
        pNoeud_3 : Arbre_Entiers.Arbre;
        pNoeud_5 : Arbre_Entiers.Arbre;
        pNoeud_1 : Arbre_Entiers.Arbre;

        C_petits, C_Grands : Natural;
begin

        pNoeud_2 := Arbre_Entiers.Inserer(cAVL, 2);
        pNoeud_6 := Arbre_Entiers.Inserer(cAVL, 6);
        pNoeud_3 := Arbre_Entiers.Inserer(cAVL, 3);
        pNoeud_5 := Arbre_Entiers.Inserer(cAVL, 5);
        pNoeud_1 := Arbre_Entiers.Inserer(cAVL, 1);

        Noeuds_Voisins(pNoeud_5, V_petit, V_Grand);
        Compte_Position(pNoeud_5, C_petits, C_Grands);

        if V_petit /= null then
                Put_Line( "5 : V_petit = " & Integer'image( V_petit.C ));
        end if;

        if V_Grand /= null then
                Put_Line( "5 : V_Grand = " & Integer'image( V_Grand.C ));
        end if;

        Put_Line( "5 : C_petits = " & Natural'image( C_petits ));
        Put_Line( "5 : C_Grands = " & Natural'image( C_Grands ));



        Noeuds_Voisins(pNoeud_2, V_petit, V_Grand);
        Compte_Position(pNoeud_2, C_petits, C_Grands);

        if V_petit /= null then
                Put_Line( "2 : V_petit = " & Integer'image( V_petit.C ));
        end if;

        if V_Grand /= null then
                Put_Line( "2 : V_Grand = " & Integer'image( V_Grand.C ));
        end if;

        Put_Line( "2 : C_petits = " & Natural'image( C_petits ));
        Put_Line( "2 : C_Grands = " & Natural'image( C_Grands ));




        Noeuds_Voisins(pNoeud_1, V_petit, V_Grand);
        Compte_Position(pNoeud_1, C_petits, C_Grands);

        if V_petit /= null then
                Put_Line( "1 : V_petit = " & Integer'image( V_petit.C ));
        end if;

        if V_Grand /= null then
                Put_Line( "1 : V_Grand = " & Integer'image( V_Grand.C ));
        end if;

        Put_Line( "1 : C_petits = " & Natural'image( C_petits ));
        Put_Line( "1 : C_Grands = " & Natural'image( C_Grands ));




        Noeuds_Voisins(pNoeud_6, V_petit, V_Grand);
        Compte_Position(pNoeud_6, C_petits, C_Grands);

        if V_petit /= null then
                Put_Line( "6 : V_petit = " & Integer'image( V_petit.C ));
        end if;

        if V_Grand /= null then
                Put_Line( "6 : V_Grand = " & Integer'image( V_Grand.C ));
        end if;

        Put_Line( "6 : C_petits = " & Natural'image( C_petits ));
        Put_Line( "6 : C_Grands = " & Natural'image( C_Grands ));


        --Affichage_AVL(cAVL);
        Arbre_Entiers.Export("test_avl.dot", cAVL);

        Arbre_Entiers.Liberer(cAVL);
end;
