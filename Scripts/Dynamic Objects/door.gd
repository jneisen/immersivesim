extends StaticBody3D

@export var unlocked : bool = true
@export_range (-1, 100, 1) var lock_strength : int = 0
@export var health = 100
@onready var center : Node3D = $Center

var open : bool = false
var rotateTo : float
var objectType = "Interact"

const rotationRate = 2

func _ready() -> void:
	rotateTo = rotation.y

func _physics_process(delta: float) -> void:
	# rotate to rotateTo
	if(rotation.y != rotateTo):
		# get direction to rotate
		var direction = 1
		if(rotation.y > rotateTo):
			direction = -1
		var difference = abs(rotation.y - rotateTo)
		if(difference > 0.05):
			rotation.y += direction * rotationRate * delta
		else:
			rotation.y = rotateTo

func damage(amount : float):
	health -= amount
	if(health < 0):
		self.queue_free()

func buttonInteract():
	var temp = unlocked
	unlocked = true
	interact()
	unlocked = temp

func interact():
	if(!unlocked):
		return
	if(open):
		rotateTo -= PI / 2
	else:
		rotateTo += PI / 2
	open = !open

func getObjectType():
	return objectType

func getHighlightPosition():
	return center.global_position
