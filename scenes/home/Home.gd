extends Control

onready var high_score_label: Label = $HighScoreLabel
onready var quit_button: Button = $ButtonBox/QuitButton
onready var settings_panel: Panel = $SettingsPanel
onready var sound_button: Button = $SettingsPanel/SoundButton


func _ready() -> void:
	high_score_label.text = "High Score: %d" % Globals.high_score
	_refresh_sound_button()
	# Browsers can't be closed programmatically -- hide Quit on Web export.
	if OS.get_name() == "HTML5":
		quit_button.visible = false


func _on_StartButton_pressed() -> void:
	Globals.reset_score()
	get_tree().change_scene("res://scenes/game/Game.tscn")


func _on_SettingsButton_pressed() -> void:
	settings_panel.visible = true


func _on_CloseSettingsButton_pressed() -> void:
	settings_panel.visible = false


func _on_SoundButton_pressed() -> void:
	Globals.toggle_sound()
	_refresh_sound_button()


func _refresh_sound_button() -> void:
	sound_button.text = "Sound: ON" if Globals.sound_on else "Sound: OFF"


func _on_QuitButton_pressed() -> void:
	get_tree().quit()
