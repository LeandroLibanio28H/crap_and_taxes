extends YSort



export var _food_types : Array

var _food_scene = preload("res://interactible/food/FoodScene.tscn")


func _ready() -> void:
	get_tree().create_timer(rand_range(3.0, 6.0)).connect("timeout", self, "_make_food")



func _make_food() -> void:
	var food_type : int = randi() % _food_types.size()
	
	for __ in range(5):
		var index = randi() % get_child_count()
		
		if get_child(index).get_child_count() == 0:
			var _food = _food_scene.instance()
			_food._food = _food_types[food_type]
			get_child(index).add_child(_food)
	
	get_tree().create_timer(rand_range(2.5, 4.5)).connect("timeout", self, "_make_food")
