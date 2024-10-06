extends Node2D

# Este é um script configurado para ser Global. Configurações do projeto > autoload
# Para cada efeito sonoro, uma função deve ser criada. Ela será chamada onde o mesmo deve ser executado.

func porta():
	$Porta.play()

func missao_concluida():
	$MissaoConcluida.play()
	
func clique_simples():
	$CliqueSimples.play()
	
func risos():
	$Risos.play()
	await get_tree().create_timer(4).timeout
	$Risos.stop()

