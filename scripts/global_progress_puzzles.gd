extends Node

var password_parts: Array[String] = []
var acertos_quiz : int = 0


func add_password_part(part: String) -> void:
	if part not in password_parts:
		password_parts.append(part)

func get_full_password() -> String:
	return "".join(password_parts)




# Armazena as partes coletadas pelo jogador
var collected_password: Array = []

# Marca se os desafios foram concluídos
var challenges_completed: Dictionary = {}

func add_password_piece(challenge_name: String) -> void:
	if not challenges_completed.has(challenge_name):
		challenges_completed[challenge_name] = true
		print("PALAVRA ADICIONADA: ", challenge_name)
	print("CHALLEGES_COMPLETED::: ", challenges_completed)


func all_challenges_done(required_challenges: Array) -> bool:
	for c in required_challenges:
		print("Missões completadas: ", challenges_completed)
		print("Missão requerida: ", c)
		#print("COMPARAÇÃO 2: ", challenges_completed[c])
		print("COMPARAÇÃO 1: ", challenges_completed.has(c))
		if not challenges_completed.has(c) or challenges_completed[c] == false:
			return false
	return true
