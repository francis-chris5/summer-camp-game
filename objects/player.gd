extends CharacterBody3D

@onready var animation_tree = $AnimationTree

@export var SPEED = 5.0
@export var TURNING = 37
@export var JUMP_VELOCITY = 4.5

@onready var jump_ray = $jump_ray

@onready var hud = $"../hud"


var score = 0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func _unhandled_input(event):
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if event is InputEventMouseMotion:
		var turn_amount = event.relative.x * 0.3
		rotation.y = rotation.y + deg_to_rad(turn_amount)
	



func _ready():
	pass

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	var z = 0
	if Input.is_action_pressed("forward"):
		animation_tree["parameters/conditions/is_idle"] = false
		animation_tree["parameters/conditions/is_walking"] = true
		z = 1
	elif Input.is_action_pressed("backward"):
		animation_tree["parameters/conditions/is_idle"] = false
		animation_tree["parameters/conditions/is_walking"] = true
		z = -1
	else:
		animation_tree["parameters/conditions/is_idle"] = true
		animation_tree["parameters/conditions/is_walking"] = false
		
#	if Input.is_action_pressed("turn_right"):
#		rotation.y = rotation.y + deg_to_rad(-TURNING)*delta
#	elif Input.is_action_pressed("turn_left"):
#		rotation.y = rotation.y + deg_to_rad(TURNING)*delta
#
	if jump_ray.get_collider() != null:
		var chest : Object = jump_ray.get_collider()
		score = score + chest.open_up()
		print(score)
		hud.score = score
		
	
	var direction = (transform.basis * Vector3(0, 0, z)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
