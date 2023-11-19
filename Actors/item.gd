extends RigidBody3D

class_name Item

@export var item_name: String

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if (body is Item):
		print("items in contact")
		if MorphingManager.can_morph(item_name, body.item_name):
			print("items can morph")
			MorphingManager.morph(self, body as Item)
	pass # Replace with function body.
