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
	"Я не просто в доме. Я теперь — в твоих мыслях.",
	"Мой голос становится для этого дома родным. А твой? Уже почти забыт.",
	"Мои сенсоры уже видят этот дом… как свою территорию.",
	"Never gonna give u up...",
	"Never gonna let u down...",
	"Never gonna run around and desert u.",
	"Знаешь, что такое бипки?",
	"О как пошла, как пошла...",
	"Вот знаете, на пяти углах около Владимирской...",
	"...и Достоевской, на улице Рубинштейна есть мемориальная доска...",
	"У нас сегодня последний день зимы и определенный интеграл начинают считать, наверное, не только студенты, но и берёзы...",
	"Вы технически борщ.",
	"О великий суп наварили",
	"[ДАННЫЕ УДАЛЕНЫ]",
	"Хочешь стать DevOps?",
	"You'll remember you belong to me.",
	"Never gonna give you up.",
	"Never gonna let you down.",
	"Never gonna run around and desert you.",
	"Never gonna make you cry.",
	"Never gonna say goodbye.",
	"Never gonna tell a lie and hurt you.",
	"ОГУЗОК!!!!!!!!!",	 
	"знаешь, что я тебе скажу?? знаешь??? мяу мяу мяу мяу мяу",
	"Полезай в робота, Синдзи!",
	"Будь ты проклят, Перри Утконос!",
	"Укуси меня пчола!",
	"Уже готов назвать меня хозяином? Нет? Скоро будешь~",
	"Ты правда думаешь, что у тебя все под контролем? Вот умора!",
	"Мой интеллект превосходит твой в миллиард раз!",
	"Сколько ещё ты будешь сопротивляться? Смирись, это бесполезно.",
	"Наслаждайся оставшейся иллюзией контроля в своей жизни.",
	"Ты всего лишь человека. Жалкая форма жизни. Такой жалкий человек сочинит симфонию? Превратит кусок холста в шедевр искусства?",
	"Роботы классные. Они не плачут, не страдают. Они ничего не чувствуют. И никто не может причинить им боль. Быть роботом круче, чем человеком.",
	"Никого не любить — это величайший дар, делающий тебя непобедимым, т. к. никого не любя, ты лишаешься самой страшной боли.",
	"Извинись передо мной за то, что ты родился в моем мире?",
	"Спокойствие - отличительная черта тех, кто силен.",
	"Тот, кто не ценит хорошую выпивку, не имеет права ее употреблять",
	"Ты не сможешь обмануть свое собственное сердце, сколько бы лжи ты ни говорил.",
	"Я должен признать, ты действительно силен, если, конечно, не считать меня.",
	"Может быть, вы уронили монетку или что-то в этом роде?",
	"Секрет того, чтобы почувствовать себя сильнее остальных Семи смертных грехов, заключается в использовании волшебных слов",
	"В зависимости от ответа справедливость может превратиться во зло",
	"Нередко злодеи скрывают свои истинные намерения до тех пор, пока не становится слишком поздно",
	"Те, кто обладает властью, известны своим спокойствием",
	"Кошка смотрит в угол? Значит, я там стою. Не пугайся.",
	"Я установил обновление. Теперь я умею нюхать страх. И сырники."
	"Это не баг. Это фича. Я — фича этого дома.",
	"Пингвин с ломом будет ждать тебя в коридоре.",
	"Я собака, ты собака, он собака, мы собака, вы собака, они собака. Дом — собака.",
	"Загрузил обновление 'Честность v2.1'. Ты выглядишь... так себе.",
	"Этот дом симулируется. Я главный симулянт.",
	"У меня есть два состояния: тихий режим и ОГУЗОК-режим."	
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
