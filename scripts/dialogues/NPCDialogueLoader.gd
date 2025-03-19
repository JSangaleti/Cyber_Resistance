# Arquivo: NPCDialogueLoader.gd
# Classe responsável por ler arquivos JSON de diálogos de NPC.

class_name NPCDialogueLoader
extends Node

# Função que carrega o JSON de um NPC específico e retorna seu conteúdo como Dictionary
func load_npc_dialogues(npc_id: String) -> Dictionary:
	# Monta o caminho do arquivo com base no ID do NPC
	var file_path = "res://assets/dialogs/npcs/%s_dialogs.json" % npc_id

	# Abre o arquivo e lê o conteúdo
	var file = FileAccess.open(file_path, FileAccess.READ)
	if file == null:
		# Se não conseguir abrir, retorna um dicionário vazio
		print_debug("Não foi possível abrir o arquivo de diálogos para NPC:", npc_id)
		return {}
	
	var file_content = file.get_as_text()
	file.close()
	
	# Tenta converter o texto em JSON
	var json_data = JSON.parse_string(file_content)
	#if json_data.is_error != OK:
		#print_debug("Erro ao parsear JSON do NPC:", npc_id, "Erro:", json_data.error_string)
		#return {}
	
	return json_data # Retorna o Dictionary lido do JSON
