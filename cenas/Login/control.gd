extends Control

var db_reference: FirebaseDatabaseReference = null
@export var Email:LineEdit=null
@export var Senha:LineEdit=null
@export var errorlbl:Label=null

func _ready() -> void:
	Firebase.Auth.login_succeeded.connect(on_login_succeeded)
	Firebase.Auth.login_failed.connect(on_login_failed)
	Firebase.Auth.signup_succeeded.connect(on_sign_up_succeeded)
	Firebase.Auth.signup_failed.connect(on_sign_up_failed)
	#if OS.is_debug_build():
		##Global.email="teste2@gmail.com"
		##get_tree().change_scene_to_file("res://cenas/title screem/title_screem.tscn")
		#Email.text="teste2@gmail.com"
		#Senha.text="12345678"
		#_on_btn_login_pressed()
 #Verifica se existe um usuário logado ao iniciar a cena


func _on_btn_login_pressed() -> void:
	var email = Email.text
	var senha = Senha.text
	Firebase.Auth.login_with_email_and_password(email, senha)

func on_login_succeeded(auth):
	print("Login successful:", auth["email"])
	Global.email=auth["email"]
	print(str("valor do email Global:",Global.email))
	get_node("/root").add_child(load("res://data/CriaPastaUser.tscn").instantiate())
	get_tree().change_scene_to_file("res://cenas/title screem/title_screem.tscn")

func on_login_failed(error_code, message):
	errorlbl["theme_override_colors/font_color"]=Color(255,0,0,255)
	errorlbl.text="login não encontrado"
	errorlbl.visible=true
	print(error_code, message)

# Outras funções de manipulação de senha e cadastro
func _on_btn_sing_up_pressed() -> void:
	var email = Email.text
	var senha = Senha.text
	Firebase.Auth.signup_with_email_and_password(email, senha)

func _on_btn_ver_pressed() -> void:
	var Textsenha =Senha
	if(Textsenha["secret"]==true):
		Textsenha["secret"]=false
	else:
		Textsenha["secret"]=true


func on_sign_up_succeeded(auth):
	#print(auth)
	print(FirebaseAuth.RESPONSE_SIGNIN)
	Global.email=auth["email"]
	get_node("/root").add_child(load("res://data/CriaPastaUser.tscn").instantiate())
	get_tree().change_scene_to_file("res://cenas/title screem/title_screem.tscn")
	
	
func on_sign_up_failed(error_code, message):
	errorlbl["theme_override_colors/font_color"]=Color(255,0,0,255)
	if(Senha.text.length())<6:
		errorlbl.text="senha fraca"
	else:
		errorlbl.text="Email invalido"
	errorlbl.visible=true
	print(error_code)
	print(message)


func _on_button_pressed() -> void:
	if(Email.text!=""):
		Firebase.Auth.send_password_reset_email(Email.text)
		errorlbl["theme_override_colors/font_color"]=Color(0,236,84,255)
		errorlbl.text="Email enviado"
		errorlbl.visible=true
	else:
		errorlbl.text="Insira o Email e clique novamente"
		errorlbl["theme_override_colors/font_color"]=Color(0,236,84,255)
		errorlbl.visible=true
		
