"""
	!
	Os seguintes algoritmos seguem os limites impostos pela linguagem que está sendo utilizada.
	Sendo assim, não estranhe as "gambiarras" que podem ser encontradas".
	!
"""

extends TextEdit

@onready var rtx_label = $"../RichTextLabel"
@onready var docker = "res://scripts/docker.gd"

var USR_DIR = "/home/unknowndev"
var CUR_DIR = USR_DIR
var prompt = "%s - %s - >> " % [Time.get_time_string_from_system(), CUR_DIR]

func bash(comando_princ: String, vec_comando: PackedStringArray):
	"""
	Função responsável por executar os comandos. Foi criada afim de simplificar 
	as entradas e saídas para que, assim, possa ser melhor utilizada ao longo do código
	"""
	var output = []
	var error_code = OS.execute(comando_princ, vec_comando, output, 1)
	return ["\n%s" % output, error_code]

func exec_comando(comando: String):
	"""
	Função responsável por tratar a entrada e permitir que apenas os comandos designados 
	sejam executadas e da maneira esperada, mantendo controle sobre o usuário
	"""
	var output = []
	
	var vec_comando = comando.rsplit(" ")
	var comando_princ = vec_comando[0]
	vec_comando.remove_at(0)
	
	match comando_princ:
		"ls":
			vec_comando.append(CUR_DIR)
			output = bash(comando_princ, vec_comando)
			return output[0]
		"cd":
			var caminho = ""
			if (len(vec_comando) == 0):
				vec_comando.append("")
				caminho = USR_DIR
			elif vec_comando[0][0] != "/":
				caminho = "%s/%s" % [CUR_DIR, vec_comando[0]]
			else:
				caminho = vec_comando[0]
			vec_comando.set(0, soluc_caminho(caminho))
			output = bash(comando_princ, vec_comando)
			if output[1] == 0:
				CUR_DIR = vec_comando[0]
			return output[0]
		"echo":
			pass
		_:
			return "\nComando não existe. Cheque a sintáxe.\n"
	return "%s" % output[0]
	
func soluc_caminho(caminho: String):
	"""
	Esta função está designada para encontrar o caminho real absoluto, 
	resolvendo os atalhos relativos ao CUR_DIR
	"""
	
	var vec_caminho = caminho.rsplit("/")
	vec_caminho.remove_at(0)
	var caminho_def = []
	caminho = ""
	
	var cont = 0
	for i in range(len(vec_caminho) - 1, -1, -1):
		if cont > 0:
			cont -= 1
			continue
		elif vec_caminho[i] == "..":
			cont = 1
			continue
		elif vec_caminho[i] == ".":
			continue
		else:
			caminho_def.append(vec_caminho[i])
			
	caminho_def.reverse()
	
	for i in caminho_def:
		caminho += "/%s" % i

	return caminho
	
func reset():
	# Reinicia o prompt do terminal
	select_all()
	delete_selection()
	prompt = "%s - >> " % CUR_DIR
	insert_text_at_caret(prompt)

func _gui_input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ENTER:
			# Quando a tecla Enter for pressionada, o texto escrito
			# pelo usuário será verificado e executado, caso seja um comando
			accept_event()
			
			var comando = get_line(get_caret_line())
			comando = comando.replace(prompt, "")
			var output: String = exec_comando(comando)
			
			rtx_label.add_text(prompt + comando + output + "\n")
			reset()

func _ready():
	# Preparação; quando o terminal for iniciado, o prompt será criado
	prompt = "%s - >> " % CUR_DIR
	insert_text_at_caret(prompt)
