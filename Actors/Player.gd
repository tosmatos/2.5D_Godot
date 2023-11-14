extends CharacterBody3D

@export var animation_column = 0
@export var SPEED = 2.5
@export var JUMP_VELOCITY = 4.5
@export var facing = 12

func _ready():
	pass
	# $AnimationPlayer.play("movement")

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 8

func _physics_process(delta):
	gravity = 8# ProjectSettings.get_setting("physics/3d/default_gravity")
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction = (Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	# Call animation helpers
	update_facing(input_dir)
	#if velocity != Vector3(0,0,0):
#		$AnimationPlayer.play("movement")
#	else:
#		$AnimationPlayer.play("idle")
#	update_animation()
	
	move_and_slide()
	
	
func update_animation():
	$Sprite3D.frame = animation_column * 8 + facing

func update_animation_row():
	$Sprite3D.frame = animation_column + facing * 8


func update_facing(input_dir):

	# Face away from camera
	if input_dir == Vector2(0,-1):
		facing = 8
	# Face towards camera
	if input_dir == Vector2(0,1):
		facing = 12
	# Face right
	if input_dir == Vector2(1,0):
		facing = 10
	# Face left
	if input_dir == Vector2(-1,0):
		facing = 14
	
	# 8d
	# Face SE
	if input_dir.x > 0 and input_dir.y > 0:
		facing = 11
	# Face SW
	if input_dir.x < 0 and input_dir.y > 0:
		facing = 13
	# Face NE
	if input_dir.x > 0 and input_dir.y < 0:
		facing = 9
	# Face NW
	if input_dir.x < 0 and input_dir.y < 0:
		facing = 15



