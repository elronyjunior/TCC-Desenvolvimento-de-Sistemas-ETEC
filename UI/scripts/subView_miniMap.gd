extends SubViewport
#
#@onready var camera = $Camera2D
#@onready var maker = $"../maker2"
#
## Variável para armazenar o player instanciado (independente da classe)
#var player: Node2D
#
#func _ready() -> void:
	## Encontre o nó instanciado dentro de "Ysort/Personagens"
	#var parent_node = get_node("Ysort/Personagens")
	#for child in parent_node.get_children():
		#if child is Node2D:  # Verifica se é um Node2D (ou qualquer tipo esperado)
			#player = child
			#break
#
	## Verifique se o nó do player foi encontrado
	#if player:
		#print("Player instanciado:", player.name)
	#else:
		#print("Nenhum player encontrado em 'Ysort/Personagens'!")
#
#func _physics_process(_delta: float) -> void:
	#if player:  # Certifique-se de que o nó foi encontrado
		#camera.position = player.position  # Atualiza a posição da câmera com base no player
	#
	## Ajuste o tamanho do SubViewport
	#self.size = Vector2(Global.proporcional(66, 1200), Global.proporcional(66, 1200))
	#
	## Ajuste a escala e posição do maker
	#maker.scale = Vector2(Global.proporcional(2, 6) / 100, Global.proporcional(2, 6) / 100)
	#maker.centered = true
	#maker.position = Vector2(Global.proporcional(33, 1200), Global.proporcional(33, 1200))
