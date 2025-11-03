extends Area3D

var direction : Vector3

func _ready():
	direction = Vector3(cos(rotation.y), 0, sin(rotation.y))
	print(direction)

func _on_body_entered(body: Node3D) -> void:
	if(body.name == "CharacterBody3D"):
		body.climbingLadder = true
		body.ladderPos = position
		body.ladderDir = direction


func _on_body_exited(body: Node3D) -> void:
	if(body.name == "CharacterBody3D"):
		body.climbingLadder = false
