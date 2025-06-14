class_name InteractableObject
extends TextureButton

@export var Name: String = "Object" # Название объекта
@export var ColorBugged : Color = Color("e0a8ad")
@export var ColorUnusable : Color = Color ("a0a0a0")
@export var Actions : Array[ObjectAction] = []; # Массив действий
@export var Selected_Action: ObjectAction
enum State { USABLE, BUGGED, UNUSABLE } # Состояния
@export var state: State # Состояние

@export var InteractionTime: float = 5.0

@onready var popup = $CloudPopUp # Облачко поп-ап
@onready var modifier = $Modifier

signal interaction_over(flag: int)
# >=0 - NPC was interrupted by player
# -1 - NPC repaired item
# -2 - NPC successfully used item

# Что происходит при загрузке сцены?
func _ready() -> void:
	state = State.USABLE
	DeactivatePopUp()
	$Modifier.visible = false
	# Генерация кнопок
	generate_buttons()
	$FlowContainer.visible = false

func generate_buttons():
	for i in Actions.size():
		var button = Button.new()
		var action = Actions[i]
		button.text = action.Name
	#	button.pressed.connect()
		$FlowContainer.add_child(button)

# Что происходит когда игрок взаимодействовал?
func Player_interaction() :
	pass

func NPC_interact():
	pass

# Что происходит когда подходит НПС?
func NPC_repair() :
	pass

# Функции для управления поп-апом
#region PopUp Management
func ChangeIcon(icon: String) :
	var texture : Texture2D = load(icon) 
	$CloudPopUp/CloudImage/Icon.texture = texture
	
func ActivatePopUp() :
	$CloudPopUp.visible = true
	
func DeactivatePopUp() :
	$CloudPopUp.visible = false

func ActivateModifier() :
	$Modifier.visible = true
	$Modifier/AnimationPlayer.play("walking-front")

func DeactivateModifier() :
	$Modifier.visible = false
	$Modifier/AnimationPlayer.stop()
#endregion

#region Buttons Selection
func _on_pressed() -> void:
	$FlowContainer.visible = true

func _on_focus_exited() -> void:
	$FlowContainer.visible = false
