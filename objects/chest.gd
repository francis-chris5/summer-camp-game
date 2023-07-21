extends CharacterBody3D

var coin_class = preload("res://objects/coin.tscn")

@export var SPEED = 5.0
var choose_direction = 0;
var direction_timer = Timer.new()
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var turn_around = false
var check_position = true

@onready var animation_tree = $AnimationTree

var active = true

func _ready():
	direction_timer.connect("timeout", choosing)
	direction_timer.one_shot = false
	direction_timer.wait_time = 3.0
	add_child(direction_timer)
	direction_timer.start()
	
func choosing():
	choose_direction = randf_range(-90.0, 90.0)
	
func check_again():
	check_position = true

func _physics_process(delta):
	if active:
		if not is_on_floor():
			velocity.y -= gravity * delta		
		if check_position:
			if position.z > 46.5 or position.z < -46.5 or position.x > 46.5 or position.x < -46.5:
				check_position = false
				turn_around = true
				var next_check = Timer.new()
				next_check.connect("timeout", check_again)
				next_check.one_shot = true
				next_check.wait_time = 0.5
				add_child(next_check)
				next_check.start()
		else:
			pass		
		if turn_around:
			choose_direction = rotation.y + 180
			turn_around = false
		rotation.y = rotation.y + deg_to_rad(choose_direction)*delta
		var direction = (transform.basis * Vector3(0, 0, 1)).normalized()
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)

		#
		move_and_slide()


func open_up():
	var amount = 0
	if active:
		animation_tree["parameters/conditions/is_opening"] = true
		amount = randi_range(1, 10)
		for c in amount:
			var coin = coin_class.instantiate()
			coin.position.x = coin.position.x + randf_range(0, 2 * c)
			coin.position.z = coin.position.z + randf_range(0, 2 * c)
			coin.rotation = Vector3(
				deg_to_rad(randi_range(0, 90)),
				deg_to_rad(randi_range(0, 90)),
				deg_to_rad(randi_range(0, 90))
				)
			coin.position.y = coin.position.y + 3
			add_child(coin)
		active = false
		var remove_timer = Timer.new()
		remove_timer.connect("timeout", delete_chest)
		remove_timer.wait_time = 2.0
		remove_timer.one_shot = true
		add_child(remove_timer)
		remove_timer.start()
	return amount


func delete_chest():
	queue_free()














#####
