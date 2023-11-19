extends Node

var hammer = preload("res://Actors/Items/hammer.tscn")

var morphing_table : Dictionary = {
	["wood", "rock"]: hammer
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta) -> void:
	pass

func can_morph(item1_name: String, item2_name: String) -> bool:
	return [item1_name, item2_name] in morphing_table

func morph(item1: Item, item2: Item) -> void:
	var result_item: Item = morphing_table[[item1.item_name, item2.item_name]].instantiate()
	result_item.global_position = item1.global_position + Vector3(0,0, 0.2)
	item1.queue_free()
	item2.queue_free()
	add_child(result_item)
