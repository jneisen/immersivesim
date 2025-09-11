class_name Item

var item_name : String
var type : String
var description : String
var model : PackedScene

func get_model(m_item_name : String) -> PackedScene:
	var string = "res://Models/" + item_name + ".glb"
	return load(string)
func get_description(m_item_name : String) -> String:
	return "Sample description for an item (should be from xml file)"
