extends Area2D

func _on_body_entered(body: Node2D) -> void:
	$Label.text = "Instruções: 
1. Na lateral direita há o painel de Missões, onde você pode verificar a descrição do que precisa ser feito e coletar suas recompensas. Comece por lá."
	$Label2.text = "Comandos: \nE: Entrar e Sair;\nC: Conversar;\nEsc: Sair do computador/minigames;\nWASD: Movimentação do player."

func _on_body_exited(body: Node2D) -> void:
	$Label.text = ""
