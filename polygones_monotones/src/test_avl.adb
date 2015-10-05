
with AVL;
with Common; use Common;
with Ada.Text_IO; use Ada.Text_IO;


procedure Test_AVL is

        package Arbre_Entiers is new AVL(Integer, "<", ">");
        package AVL_Entiers_Disp is new Arbre_Entiers.Generic_Display ( Integer'Image );
        use Arbre_Entiers;

        cAVL, V_petit, V_Grand : Arbre;
        pNoeud_2 : Arbre;
        pNoeud_6 : Arbre;
        pNoeud_3 : Arbre;
        pNoeud_5 : Arbre;
        pNoeud_1 : Arbre;
        pNoeud : Arbre;

        C_petits, C_Grands : Natural;
begin

        pNoeud_2 := Inserer(cAVL, 2);
        pNoeud_6 := Inserer(cAVL, 6);
        pNoeud_3 := Inserer(cAVL, 3);
        pNoeud_5 := Inserer(cAVL, 5);
        pNoeud_1 := Inserer(cAVL, 1);

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


        pNoeud := Rechercher(cAVL, 2);
        --AVL_Entiers_Disp.Affichage(pNoeud);

        if pNoeud /= null and then pNoeud.C = 2 then
                Put_Line( "Recherche de 2 : OK");
        else
                Put_Line( "Recherche de 2 : Erreur");
        end if;


        --AVL_Entiers_Disp.Affichage(cAVL);
        AVL_Entiers_Disp.Export("test_avl.dot", cAVL);

        Arbre_Entiers.Liberer(cAVL);
end;
