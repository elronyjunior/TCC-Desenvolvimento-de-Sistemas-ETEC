extends Control

@onready var days_label: Label = $DayControl/Days
@onready var hours_label: Label = $ClockBG/ClockControl/hours
@onready var minutes_label: Label = $ClockBG/ClockControl/minutes

func _on_time_system_updated_time(date_time: DateTime) -> void:
	update_label(days_label, date_time.days, false)
	update_label(hours_label, date_time.hours)
	update_label(minutes_label, date_time.minutes)

func add_leading_zero(label: Label, value: int) -> void:
	if value < 10:
		label.text += '0'

func update_label(label: Label, value: int, should_have_zero: bool = true) -> void:
	label.text = ""
	if should_have_zero:
		add_leading_zero(label, value)
	label.text += str(value)
