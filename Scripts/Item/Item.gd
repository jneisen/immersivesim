class_name Item

var item_name : String
var type : String
var description : String
var model : PackedScene

func setName(m_item_name : String):
	item_name = m_item_name
	model = get_model(item_name)

func get_model(m_item_name : String) -> PackedScene:
	var string = "res://Models/" + item_name + ".glb"
	return load(string)
