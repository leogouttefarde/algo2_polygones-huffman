
with Ada.Strings.Unbounded;
with Ada.Text_IO;
with Ada.Containers.Doubly_Linked_Lists;
with Ada.Unchecked_Deallocation;
with Ada.Characters.Handling;
use Ada.Strings.Unbounded;
use Ada.Text_IO;
use Ada.Characters.Handling;

package Tree is

	type Tree is private;

	-- Crée un arbre contenant uniquement un noeud racine
	function New_Tree return Tree;

	-- Insère un mot dans un arbre
	procedure Insertion(T : in out Tree ; Word : in String);

	-- Recherche les mots correspondant aux lettres demandées dans un arbre
	procedure Search_And_Display(T : in Tree ; Letters : in String);

	-- Libère récursivement un arbre
	procedure Free_Tree(T : in out Tree);

private

	package String_Lists is new Ada.Containers.Doubly_Linked_Lists ( Unbounded_String );
	type pString_List is access String_Lists.List;

	M : constant Natural := 512;

	type Node;
	type Tree is access Node;
	type Trees is array ( Natural range 0 .. M ) of Tree;

	type Node is record
		Parent : Tree;
		Childs : Trees;
		Words : pString_List;
	end record;

	procedure Free_Node is new Ada.Unchecked_Deallocation(Node, Tree);
	procedure Free_List is new Ada.Unchecked_Deallocation(String_Lists.List, pString_List);

	subtype Lowercase is Character range 'a' .. 'z';
	type Alphabet is array ( Lowercase ) of Natural;

end Tree;
