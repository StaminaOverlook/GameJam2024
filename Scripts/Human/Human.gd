extends CharacterBody2D

var StressLevel: float = 0.0
var movement_speed: float = 100.0
var current_target_position: Vector2 = Vector2(60.0,180.0)
var current_target
@export var Destinations: Array[InteractableObject] = []
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
var movement_allowed = false
var i = 0
var last_direction: Vector2 = Vector2.DOWN  # Для запоминания последнего направления

signal movement_over

#region Actor Setup
func _ready():
	navigation_agent.path_desired_distance = 4.0
	navigation_agent.target_desired_distance = 4.0
	animation.play("idle")  # Начинаем с анимации покоя
	call_deferred("actor_setup")

func actor_setup():
	await get_tree().physics_frame
	current_target = Destinations[i]
	set_movement_target(current_target)
	movement_allowed = false
#endregion

#region Movement
func set_movement_target(target):
	current_target = target
	current_target_position = current_target.global_position
	navigation_agent.target_position = current_target_position

func _physics_process(delta):
	if movement_allowed:
		if navigation_agent.is_navigation_finished():
			animation.play("idle-front")  # Останавливаемся - анимация покоя
			movement_over.emit()
			if current_target is InteractableObject:
				_attempt_interact()
			movement_allowed = false
			return
	
		var current_agent_position: Vector2 = global_position
		var next_path_position: Vector2 = navigation_agent.get_next_path_position()
		var direction: Vector2 = current_agent_position.direction_to(next_path_position)
		
		# Обновляем анимацию в зависимости от направления
		_update_animation(direction)
		
		velocity = direction * movement_speed
		move_and_slide()

func _update_animation(direction: Vector2):
	# Определяем основное направление (по наибольшей компоненте)
	if abs(direction.x) > abs(direction.y):
		if direction.x > 0:
			animation.play("walking-front")
		else:
			animation.play("walking-front")
	else:
		if direction.y > 0:
			animation.play("walking-front")
		else:
			animation.play("walking-front")
	
	# Запоминаем последнее направление для анимации покоя
	if direction.length() > 0.1:
		last_direction = direction
#endregion

func _attempt_interact():
	# Анимация взаимодействия
	animation.play("interact")
	
	if current_target.state == current_target.State.BUGGED:
		Interface.IncreaseStress()
		if Interface.stress >= 9:
			_exit_game()
			return
		draw_call(-1)
	if current_target.state == current_target.State.USABLE:
		draw_call(-2)
	current_target.connect("interaction_over", interaction_over)

func interaction_over(flag: int):
	# Возвращаемся к анимации покоя после взаимодействия
	animation.play("idle")
	
	if flag >= 0:
		Interface.IncreaseStress()
		if Interface.stress >= 9:
			_exit_game()
			return
		draw_call(-1)
	if flag == -1:
		pass
	if flag == -2:
		Interface.DecreaseStress()
	current_target.interaction_over.disconnect(interaction_over)
	_continue_movement()
	
func draw_call(i: int) :
	var callable
	if not current_target.Selected_Action:
		current_target.NPC_interact()
	else:
		callable = current_target.Selected_Action.npc_function_name
		current_target.call(callable, i)

func _continue_movement():
	Interface.RandomAISPeech()
	i += 1
	if i >= Destinations.size():
		print("You lost!")
		get_tree().change_scene_to_file("res://Scripts/UI/YouLost.tscn")
	set_movement_target(Destinations[i])
	movement_allowed = true

func _exit_game():
	Interface.max_stress_reached.emit()
