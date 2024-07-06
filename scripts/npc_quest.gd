extends Control

# Sinal para fechar os baloezinhos de Missão
signal chat_missao_fechado

var missao_01_ativa = false
var missao_01_completa = false

func _process(delta):
	pass

# Função para ativar o balãozinho da Missão 01. O player terá a opção de aceitar ou não a Missão
func missao_01_chat():
	$Quest_01.visible = true
	Global.nome_missao = "Missão 01"
	
# Esta função verifica qual a próxima missão a ser realizada. 
# Detalhes: Ela verifica um array global, identifica a última missão realizada. Com o valor da última missão realizada, ela soma 1 e por meio de um macth, seleciona
# a próxima missão a ser realizada. Se não houver, nada acontece.
# Para desenvolvimentos futuros: É possível que apenas algumas missões estejam vinculadas ao NPC, sendo assim, é possível verificar as mesmas e executar a função de início
# das mesmas. 
func proxima_missao():
	var quant_de_missoes : int = 0
	var num_da_missao : int = 0
	
	if Global.missoes_concluidas == []:
		missao_01_chat()
	else:
		quant_de_missoes = len(Global.missoes_concluidas) - 1
		num_da_missao = Global.missoes_concluidas[(quant_de_missoes)] + 1
		
		match num_da_missao:
			2: 
				# missao_02_chat()
				print("Missão 2")
			3:
				# missao_03_chat()
				print("Missão 3")
			

	

# Função criada para que, quando o player terminar uma missão, ele seja notificado disso, com o Finished_quest. 
func player_terminou_missao():
#	Tocar efeito sonoro
	ControleMusica.missao_concluida()
	$Finished_quest.visible = true
	await get_tree().create_timer(5).timeout
	$Finished_quest.visible = false

# Sinal pressed vindo do botão SIM (Yes_button_01); 
func _on_yes_button_01_pressed():
	$Quest_01.visible = false
	missao_01_ativa = true
	Global.missao_ativa = true
	#Tocando efeito sonoro
	ControleMusica.clique_simples()
	emit_signal("chat_missao_fechado")

# Sinal pressed vindo do botão NÃO (No_button_01);
func _on_no_button_01_pressed():
	$Quest_01.visible = false
	missao_01_ativa = false
	Global.missao_ativa = false
	Global.nome_missao = ""
	#meetTocando efeito sonoro
	ControleMusica.clique_simples()
	emit_signal("chat_missao_fechado")
	
# Sinal vindo do nó Player. Este sinal permite verificar se o player acessou determinado local, referido no script Player. 
# Isso é útil para a realização de determinadas missões, como no caso, da missão 01, onde é necessário que o Player acesse o Computador.
# Feito tais verificações, realizo as configurações necessárias para indicar a finalização da missão. 
# Observação: Esse sinal também pode ser usado para verificar passos de uma missão. Exemplo:
	#if Global.nome_missao == "Missão 02" and Global missao_ativa == true:
		#print("Próximo passo é pressionar a tecla enter") 
		#if Input.is_just_pressed("Enter"):
			#pass; Isso é apenas um exemplo simples, onde passar em tal LOCAL é necessário. 
func _on_player_local_acessado():
	if Global.nome_missao == "Missão 01" and Global.missao_ativa == true:
		print("Missão 01 realizada com sucesso!")
		missao_01_ativa = false
		missao_01_completa = true
		Global.missao_ativa = false
		Global.nome_missao = ""
		Global.missoes_concluidas = Global.missoes_concluidas + [1]
		print("Array ->> ", Global.missoes_concluidas)
		player_terminou_missao()
		
	
	
