extends DirectionalLight2D

@export var day_color: Color
@export var night_color: Color
@export var dawn_color: Color # Cor para o amanhecer
@export var dusk_color: Color # Cor para o anoitecer

@export var day_start: DateTime
@export var dawn_start: DateTime
@export var dusk_start: DateTime
@export var night_start: DateTime

@export var transition_time: int = 30 # Em minutos
@export var time_system: TimeSystem

var in_transition: bool = false

# Definindo os novos estados
enum DayState {DAWN, DAY, DUSK, NIGHT}
var current_state: DayState = DayState.DAY

# Mapas de tempo e cor para cada estado
@onready var time_map: Dictionary = {
	DayState.DAWN: dawn_start,
	DayState.DAY: day_start,
	DayState.DUSK: dusk_start,
	DayState.NIGHT: night_start,
}

@onready var transition_map: Dictionary = {
	DayState.DAWN: DayState.DAY,
	DayState.DAY: DayState.DUSK,
	DayState.DUSK: DayState.NIGHT,
	DayState.NIGHT: DayState.DAWN,
}

@onready var color_map: Dictionary = {
	DayState.DAWN: dawn_color,
	DayState.DAY: day_color,
	DayState.DUSK: dusk_color,
	DayState.NIGHT: night_color,
}

func _ready() -> void:
	var current_time = time_system.date_time
	var diff_day_start = current_time.diff_without_days(day_start)
	var diff_night_start = current_time.diff_without_days(night_start)
	var diff_dawn_start = current_time.diff_without_days(dawn_start)
	var diff_dusk_start = current_time.diff_without_days(dusk_start)

	if diff_night_start < 0 and diff_dusk_start > 0:
		current_state = DayState.NIGHT
	elif diff_dawn_start < 0 and diff_day_start > 0:
		current_state = DayState.DAY
	elif diff_dusk_start < 0 and diff_night_start > 0:
		current_state = DayState.DUSK
	elif diff_day_start < 0 and diff_dawn_start > 0:
		current_state = DayState.DAWN

func _process(_delta: float) -> void:
	# Atualiza o estado a cada frame
	update_state(time_system.date_time)


func update_state(game_time: DateTime) -> void:
	var next_state = transition_map[current_state]
	var change_time = time_map[next_state]
	var time_diff = change_time.diff_without_days(game_time)

	if in_transition:
		update_transition(time_diff, next_state)
	elif time_diff > 0 and time_diff < (transition_time * 60):
		in_transition = true
		update_transition(time_diff, next_state)
	else:
		color = color_map[current_state]


func update_transition(time_diff: int, next_state: DayState) -> void:
	var ratio = 1 - (time_diff as float / (transition_time * 60))
	ratio = clamp(ratio, 0, 1)  # Limita o ratio entre 0 e 1

	if ratio >= 1:
		# Transição concluída
		current_state = next_state
		in_transition = false
	else:
		# Interpolação de cor suave entre os estados
		color = color_map[current_state].lerp(color_map[next_state], ratio)
