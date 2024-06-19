extends Node2D


#Variável para identificar de que Cena o personagem veio. 
#Será usada para auxiliar com o Posicionamento do player após passar por uma transição de cenas. 
var from_scene
#Variável criada com o intuito de retirar o erro de precisar de uma position na Cena Computador. 
#Com essa variável, é possível verificar em que cena está e então, se estiver na cena Computador, ignorará a Position
var cena : String

#Nas configurações do projeto, esta cena foi adicionada como Global. Contudo, todas as variáveis e funções
#aqui incluídas, poderão ser acessadas de qualquer cena ou nó do projeto. 
