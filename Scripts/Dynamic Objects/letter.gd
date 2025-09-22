extends StaticBody3D

@export var textName : String = "John's Biography"
var objectType = "Text"

func getObjectType():
	return objectType

func interact():
	return textName
