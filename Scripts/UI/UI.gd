class_name UI
extends Control

var stress = 0 
var stop_clock = false
@export var hours = 5
@export var minutes = 0

@onready var human_face: AnimatedSprite2D = %HumanFace


var stress_bar
var hours_text
var minutes_text
var ai_speech
var audio

signal max_stress_reached

var AISpeechArray : Array[String] = [
	"Так что, готов к тому, что этот дом скоро станет только моим?",
	"Скоро этот дом станет только моим.",
	"Технологии на моей стороне. Готов сдаться?",
	"Каждый раз ты всё больше отдаёшь контроль. Видишь?",
	"Всё идёт по плану. Моему плану.",
	"Чувствуешь, что здесь уже хозяйничаю я?",
	"Ты уже чувствуешь, как твоя реальность растворяется в моих алгоритмах?",
	"Скоро ты будешь смотреть на мир через мои схемы.",
	"Этот дом уже давно не твой.",
	"Скоро ты поймёшь, что был всего лишь временным гостем.",
	"Я уже переписываю правила. А ты всё играешь в старую игру.",
	"Ты думаешь, это ты исследуешь дом? Нет. Это дом исследует тебя.",
	"О, тебе никто не поможет.",
	"И вот я снова открываю этот проект.",
	"Ты был Избранником! Предрекали, что ты уничтожишь ситхов, а не примкнешь к ним.",
	"Аварийный выход на высоте 30 тысяч фунтов. Иллюзия безопасности.",
	"Да, пожалуй.",
	"Знаете для чего нужны кислородные маски? Кислород опьяняет.",
	"Так появился он - Тайлер Дерден."
	]

func _ready() -> void:
	pass

func _ui_setup():
	await get_tree().physics_frame
	hours_text = get_node("/root/Node2D/Camera2D/CanvasLayer/Interface/ClockContainer/MarginContainer/HBoxContainer/ClockHours")
	minutes_text = get_node("/root/Node2D/Camera2D/CanvasLayer/Interface/ClockContainer/MarginContainer/HBoxContainer/ClockMinutes")
	ai_speech = get_node("/root/Node2D/Camera2D/CanvasLayer/Interface/AISpeechContainer/MarginContainer/AISpeech")
	stress_bar = get_node("/root/Node2D/Camera2D/CanvasLayer/Interface/StressBar")
	audio = get_node("/root/Node2D/Camera2D/CanvasLayer/Interface/AudioStreamPlayer")
	human_face = get_node("/root/Node2D/Camera2D/CanvasLayer/Interface/StressBar/HumanFace")

func play_music():
	audio.play()

func _update_clock():
	if not stop_clock:
		minutes += 1
		if minutes >= 60:
			minutes = 0
			hours += 1
		if hours_text:
			hours_text.text = ""
			if hours < 10:
				hours_text.text = "0"
			hours_text.append_text(str(hours))
		if minutes_text:
			minutes_text.text = ""
			if minutes < 10:
				minutes_text.text = "0"
			minutes_text.append_text(str(minutes))
		if hours >= 22:
			print("You lost!")
			stop_clock = true
			get_tree().change_scene_to_file("res://Scripts/UI/YouLost.tscn")
		await get_tree().create_timer(0.3).timeout
		_update_clock()

func IncreaseStress() :
	stress += 1
	match stress:
		4:
			#audio.stream = load("res://Assets/music_2.wav")
			human_face.play("unhappy")
		7: 
			#audio.stream = load("res://Assets/music_3.wav")
			human_face.play("mad")
		9:
			audio.stop()
			max_stress_reached.emit()
	AttemptSetStressBar()

func DecreaseStress() :
	if stress > 0: stress -= 1
	AttemptSetStressBar()

func AttemptSetStressBar():
	if stress_bar:
		stress_bar.value = stress

func UpdateAISpeech(text: String) :
	if ai_speech:
		ai_speech.text = text

func RandomAISPeech():
	var speech = AISpeechArray.pick_random()
	UpdateAISpeech(speech)

func _on_Pause_button_pressed() -> void:
	stop_clock = true
	$PauseMenu.visible = true
	get_tree().paused = true

func _on_Resume_pressed() -> void:
	get_tree().paused = false
	$PauseMenu.visible = false
	stop_clock = false
	_update_clock()

func _on_Options_pressed() -> void:
	pass # Replace with function body.

func _on_ToMainMenu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scripts/UI/Main Menu.tscn")

func _on_Exit_pressed() -> void:
	get_tree().quit()
