extends Node

#const PDF = preload("res://godotpdf/PDF.gd") # Caminho do PDF.gd do plugin

func gerar_relatorio(respostas: Array, acertos: int, erros: int):
	var caminho = "user://relatorio_quiz.txt"
	var arquivo = FileAccess.open(caminho, FileAccess.WRITE)
	arquivo.store_line(">> 	Relatório do Quiz")
	arquivo.store_line("	Acertos: %d" % acertos)
	arquivo.store_line("	Erros: %d" % erros)
	arquivo.store_line("")

	for i in respostas.size():
		var r = respostas[i]
		arquivo.store_line(">> 	Questão %d: %s" % [i + 1, r["pergunta"]])
		arquivo.store_line("	Resposta selecionada: [%s]" % [r["letra_selecionada"]])
		arquivo.store_line("	Resposta correta: [%s]" % r["resposta_correta"])
		arquivo.store_line("")

	arquivo.close()

	var caminho_absoluto = ProjectSettings.globalize_path(caminho)
	OS.shell_open(caminho_absoluto)

	print("Arquivo de texto salvo em: ", caminho_absoluto)

	
	#var pdf = PDF.new()
	#pdf.newPDF("Título", "Criador")
	#pdf.setTitle("Relatório do Quiz")
	#pdf.setCreator("CyberResistance")
	#
	#pdf.newPage() # <---- necessário
#
	#var linha = 1
#
	#pdf.newLabel(1, linha, "Relatório do Quiz", 14, "Helvetica-Bold")
	#linha += 2
	#
	#for i in respostas.size():
		#var r = respostas[i]
		#pdf.newLabel(1, linha, "Pergunta %d: %s" % [i + 1, r["pergunta"]])
		#linha += 1
		#pdf.newLabel(1, linha,"Resposta selecionada: [%s] %s" % [r["letra_selecionada"], r["texto_selecionado"]])
		#linha += 1
		#pdf.newLabel(1, linha,"Resposta correta: [%s]" % r["resposta_correta"])
		#linha += 1
		#pdf.newLabel(1, linha,"Explicação: %s" % r["explicacao"])
		#linha += 2
#
	#pdf.newLabel(1, linha,"Resumo final:")
	#linha += 1
	#pdf.newLabel(1, linha,"Acertos: %d" % acertos)
	#linha += 1
	#pdf.newLabel(1, linha,"Erros: %d" % erros)
	#linha += 1
#
	#var path = "res://relatorio_quiz.pdf" # Melhor usar `user://` do que `res://` para salvar
	#pdf.export(path)
#
	#print("Relatório salvo em: ", path)


	
