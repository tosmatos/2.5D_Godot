extends CharacterBody3D

@export var animation_column = 0
@export var SPEED = 2.5
@export var JUMP_VELOCITY = 4.5
@export var facing = 12

const THROW_FORCE = 2

var current_liftable_item: RigidBody3D
var lifted_item: RigidBody3D
var lifting_item: bool = false
var throw_cooldown: float

func _ready():
	pass
	# $AnimationPlayer.play("movement")

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 8

func _physics_process(delta):
	gravity = 8 # ProjectSettings.get_setting("physics/3d/default_gravity")
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

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

	item_pickup()
	item_throw()
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

func item_pickup():
	if current_liftable_item != null && Input.is_action_just_pressed("interact"):
		lifted_item = current_liftable_item
		print("trying to pick up")
		lifted_item.freeze = true
		lifting_item = true
		throw_cooldown = 0.2
		
	if lifting_item:
		lifted_item.global_position = global_position + Vector3(0, 0.5, 0)

func item_throw():
	if lifted_item != null && Input.is_action_just_pressed("interact"):
		if throw_cooldown <= 0:
			print("throwing!")
			lifted_item.freeze = false
			if velocity != Vector3.ZERO:
				lifted_item.apply_impulse(velocity * THROW_FORCE)
			else: lifted_item.apply_impulse(Vector3(0, 0, 1))
			lifted_item = null
			lifting_item = false
	elif throw_cooldown > 0:
		throw_cooldown -= get_process_delta_time()

func _on_pickup_range_body_entered(body):
	if body.is_in_group("liftable") && body is RigidBody3D:
		current_liftable_item = body


func _on_pickup_range_body_exited(body):
	if body == current_liftable_item:
		current_liftable_item = null
