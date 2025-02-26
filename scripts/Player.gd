#extends CharacterBody2D
#class_name Player
#var save_file_path="use"
#var save_file_name="Player_data"
#var playerData=PlayerData.new()
#var config=Config.new()
#var load_data=playerData.load_game(str("user://data/",Global.email,"/save_game_",Global.slot,".tres"))
##pega os playback do animation_tree para depois usar o travel()
#var state_machine
##estado de ataque do PLayer
#var is_attackin:bool=false
##um vetor[2] que guarda a movimentação
#var direction:Vector2 =Vector2(Input.get_axis("esquerda","direita"),Input.get_axis("cima","baixo"))
##carregando o Player no código e outros objetos dele
#@onready var player = $"."
#@export var marker_2d:Marker2D=null
#const ice := preload("res://projeteis/ice_bullet/ice_bullet.tscn")
#const fire:= preload("res://projeteis/fire_bullet/fire_bullet.tscn")
#const neutro := preload("res://projeteis/neutro.tscn")
##exportando variaveis para melhor manipulação de seu valor
#@export_category("movimento")
#@export var move_speed:float =64
#@export var aceleration:float=0.4
#@export var friction:float=0.8
##atribuindo objetos a variaveis é a mesma coisa que carregar objetos
#@export_category("objetos")
#@export var animation_tree: AnimationTree = null 
#@export var attack_timer: Timer = null
##criação de um vetor para guardar o ultimo valor que não seja ZERO nas casas 0 e 1
#var dir:Vector2=Vector2(-1,0)
##responsavel pela direção do personagem usando um Vector2
#func direcao():
	##pega os valores dos inputs e coloca no vetor direction
	#direction=Vector2(Input.get_axis("esquerda","direita"),Input.get_axis("cima","baixo"))
	#if(direction != Vector2.ZERO):
		##dir é um vetor que guarda a ultimo valor do vetor direction que não seja 0 nos dois espaços
		#dir=direction
	#"""uma seria de verificações para alterar a posição do marker_2d"""
	##diagonal superior esquerda
	#if(dir[0]==-1 && dir[1]==-1):
		#marker_2d.position.x=-20
		#marker_2d.position.y=-10
	##diagonal inferior esquerda
	#elif(dir[0]==-1 && dir[1]==1):
		#marker_2d.position.x=-10
		#marker_2d.position.y=10
	##diagonal inferior direita
	#elif(dir[0]==1 && dir[1]==1):
		#marker_2d.position.x=10
		#marker_2d.position.y=10
	##diagonal superior direita
	#elif(dir[0]==1 && dir[1]==-1):
		#marker_2d.position.x=20
		#marker_2d.position.y=-10
	##baixo
	#elif(dir[1]==1):
		#marker_2d.position.x=0
		#marker_2d.position.y=23
	##cima
	#elif(dir[1]==-1):
		#marker_2d.position.x=0
		#marker_2d.position.y=-23
	##esquerda
	#elif(dir[0]==-1):
		#marker_2d.position.x=-27
		#marker_2d.position.y=0
	##direita
	#elif(dir[0]==1):
		#marker_2d.position.x=27
		#marker_2d.position.y=0
##essa função é executada quandoo jogo inicia
#func _ready():
	#config.load_key_binds()
	#Hud()
	#Menu()
	#create_timers()
	#load_save_player()
	##pega os playback do animation_tree para depois usar o travel()
	#state_machine= animation_tree["parameters/playback"]
##essa função é chamada 30 vezes por segundo seguindo o valor de _delta
#func _physics_process(_delta):
	#time_await()
	#habilidades()
	#direcao()
	#attack()
	#animated()
	#move()
	#move_and_slide()
##movimentação do personagem
#func move():
	#if(direction != Vector2.ZERO):
		##é passado um valor para a animação do blendspace2D que ativa as etapas da animação
		#animation_tree["parameters/idle/BlendSpace2D/blend_position"]=direction
		#animation_tree["parameters/walk/BlendSpace2D/blend_position"]=direction
		#animation_tree["parameters/attack/BlendSpace2D/blend_position"]=direction
		##movimento é aplicado de fato ao personagem
		##movimento com aceleração,normalizado e interpolado 
		#velocity.x=lerp(velocity.x, direction.normalized().x * move_speed,aceleration)
		#velocity.y=lerp(velocity.y, direction.normalized().y * move_speed,aceleration)
		#return
		##fricção do movimento
	#velocity.x=lerp(velocity.x, direction.normalized().x * move_speed,friction)
	#velocity.y=lerp(velocity.y, direction.normalized().y * move_speed,friction)
##attack do Player
#func attack():
	##verica o botão de attack e se está em coldown 
	#if (Input.is_action_just_pressed("attack") && is_attackin == false):
		#set_physics_process(false)
		#attack_timer.start()
		#is_attackin=true
##ativa as animaçoes
#func animated():
	##temos verificações para ver qual animação deve ser chamada
	#if(is_attackin==true):
		##atravez do state_machine podemos chamar o travel() que inicia a animação
		#state_machine.travel("attack")
		#return
	#if(velocity.length()>2):
		#state_machine.travel("walk")
		#return
	#state_machine.travel("idle")
##cria projéteis
#func projeteis(tipo:String):
	#var vazio:bool=false
	##instancia vazia
	#var instancia
	##instancia de objeto neutro apenas para manipular durante o código
	#instancia=neutro.instantiate()
	##um switch só que na linguagem da godot
	#match tipo:
		#"ice":
			##atribuindo o tiro de gelo a instancia
			#instancia=ice.instantiate()
		#"fire":
			#instancia=fire.instantiate()
			#StatusPlayer.set_XP(StatusPlayer.get_XP()+1)
		#"empty":
			#vazio=true
	##uma serie de verificações para definir a rotação do projétil
	##utilizando o rotate() para conseguir alguns angulos como PI/4
	#if(!vazio):
		#if(dir[0]==-1 && dir[1]==-1):
			#instancia.rotate(5*PI/4)
			#
		#elif(dir[0]==-1 && dir[1]==1):
			#instancia.rotate(3*PI/4)
		#elif(dir[0]==1 && dir[1]==1):
			#instancia.rotate(PI/4)
		#elif(dir[0]==1 && dir[1]==-1):
			#instancia.rotate(7*PI/4)
		#elif(dir[0]==-1):
			#instancia.scale.x=instancia.scale.x*-1
		#elif(dir[1]==-1):
			#instancia.rotate(PI/2*-1)
		#elif(dir[1]==1):
			#instancia.rotate(PI / 2)
		##definindo a posição do projétil igual o marker_2d que acompanha a direção
		##do Player
		#instancia.global_position=marker_2d.global_position
		#instancia.set_direction(dir)
		#get_parent().add_child.call_deferred(instancia)
	#
##um couldown para o attack
#func _on_attack_timer_timeout():
	#set_physics_process(true)
	#is_attackin=false
	#
#func create_timers():
	#for timers in Global.habilidades:
		#if(Global.habilidades[timers][0]!="empty"):
			#var time=Timer.new()
			#time.name=str(timers)
			#time.one_shot=true
			#time.wait_time=Global.habilidades[timers][1]
			#var func_ref = get(str("timeout_",timers))
			#time.timeout.connect(func_ref)
			#player.add_child(time)
#
#func time_await():
	#for elementos in Global.habilidades:
		#if(Global.habilidades[elementos][0]!="empty"):
			#var time_aw=get_node(str(elementos))
			#Global.time_await[elementos]=floor(time_aw.time_left * 10)/10
#func Hud():
	#var hud:=preload("res://Player/hb.HUD/hud.tscn").instantiate()
	##call_deferrend é uma função que agenda uma ação caso o nó solicitado esteja ocupado
	#get_parent().add_child.call_deferred(hud)
#func Menu():
	#var menu:=preload("res://Player/menu.HUD/menu/menu.tscn").instantiate()
	#get_parent().add_child.call_deferred(menu)
#func timeout_0():
	#Global.coldown_0=false
#func timeout_1():
	#Global.coldown_1=false
#func timeout_2():
	#Global.coldown_2=false
#
#func load_save_player():
	#player.global_position=load_data.Save_Player_Position
#func habilidades():
	#if(Input.is_action_just_pressed("0") && !Global.coldown_0 && Global.habilidades[0][0]!="empty"):
		#projeteis(Global.habilidades[0][0])
		#var name0:Timer=get_node("0")
		#name0.start()
		#Global.coldown_0=true
	#if(Input.is_action_just_pressed("1") && !Global.coldown_1 && Global.habilidades[1][0]!="empty"):
		#projeteis(Global.habilidades[1][0])
		#var name1:Timer=get_node("1")
		#name1.start()
		#Global.coldown_1=true
	#if(Input.is_action_just_pressed("2") && !Global.coldown_2 && Global.habilidades[2][0]!="empty"):
		#projeteis(Global.habilidades[2][0])
		#var name2:Timer=get_node("2")
		#name2.start()
		#Global.coldown_2=true
