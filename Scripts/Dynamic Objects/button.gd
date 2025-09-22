extends StaticBody3D

@export var linkedObject : Node3D
var objectType = "Interact"

func interact():
	if(linkedObject.has_method("buttonInteract")):
		linkedObject.buttonInteract()
	else:
		linkedObject.interact()

func getObjectType():
	return objectType
