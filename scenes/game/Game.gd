extends Node2D

onready var grid_manager: Node = $GridManager
onready var score_label: Label = $UI/TopBar/ScoreLabel
onready var end_panel: Panel = $UI/EndPanel
onready var result_label: Label = $UI/EndPanel/ResultLabel
onready var score_line: Label = $UI/EndPanel/ScoreLine


func _ready() -> void:
	grid_manager.connect("score_changed", self, "_on_score_changed")
	grid_manager.connect("game_over", self, "_on_game_over")
	grid_manager.connect("game_won", self, "_on_game_won")
	score_label.text = "Score: %d" % Globals.score


func _on_score_changed(new_score: int) -> void:
	score_label.text = "Score: %d" % new_score


func _on_game_over() -> void:
	Globals.try_save_high_score()
	result_label.text = "GAME OVER"
	score_line.text = "Score: %d   Best: %d" % [Globals.score, Globals.high_score]
	end_panel.visible = true


func _on_game_won() -> void:
	Globals.try_save_high_score()
	result_label.text = "BOARD CLEARED!"
	score_line.text = "Score: %d   Best: %d" % [Globals.score, Globals.high_score]
	end_panel.visible = true


func _on_RestartButton_pressed() -> void:
	Globals.reset_score()
	get_tree().reload_current_scene()


func _on_HomeButton_pressed() -> void:
	get_tree().change_scene("res://scenes/home/Home.tscn")


func _on_BackButton_pressed() -> void:
	get_tree().change_scene("res://scenes/home/Home.tscn")
