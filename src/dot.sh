

files=AVL_dot/*.dot


for f in $files; do dot -Tpng "$f" > "$f.png"; done
# for f in $files; do echo "$f"; done


