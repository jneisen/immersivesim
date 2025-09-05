extends Sprite3D

@export var camera : Camera3D

# input positions should be global locations
func move(playerCameraPosition : Vector3, objectPosition : Vector3):
	# move the highlighter to between the player and the object
	position = objectPosition - Vector3(0, 1, 0) + (playerCameraPosition - objectPosition) / 2
	look_at(playerCameraPosition)

func unhide():
	if(visible == false):
		visible = true
