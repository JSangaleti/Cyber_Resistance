extends Node2D

#Global.coins -> Variável responsável por armazenar o valor das moedas

func _ready():
	# Inicializa UI e conecta eventos
	$UI/LbCoins.text = str(Global.coins)
	$UI/BtTask.pressed.connect(_abrir_painel_de_tarefas)

func _abrir_painel_de_tarefas():
	$UI/PnTask.visible = !$UI/PnTask.visible
	print("passou aquiasikdjnasikdjnalsikjdnaskjidna")
	

#func _iniciar_tarefa():
	#$UI/PnTask/LbTaskInstructions.text = "Fale com o NPC Professor para completar a tarefa."
	#$UI/PnTask.visible = false
	##$UI/PnTask/BtClaimReward.visible = false  # Recompensa ainda não disponível.
	#tarefa_concluida = false
	#recompensa_reclamada = false


#func disable_pnTask():
	#print("deu certo aqui")
		## Se a cena atual for a do Computador ou a Tela Inicial, o painel se oculta e não atualiza
	## Se tirar isso, vai dar problema. O painel de missões não pode ser acessado do computador.	
	#if Global.actual_scene == "Computer" || Global.actual_scene == "MainMenuScreen":
		#if $UI/PnTask.visible:
			#$UI/PnTask.visible = false
			#$UI/BtTask.visible = false
			#$UI/LbCoins.visible = false
		#return
	#else:
		#$UI/PnTask.visible = true
		#$"../BtTask".visible = true
		#$"../LbCoins".visible = true
					
