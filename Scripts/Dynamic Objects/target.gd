extends StaticBody3D

@export var indicator : PackedScene
var radius : float
var m_basis : Basis
var max_indicators : int = 5
var num_indicators : int = 0
var indicators : Array

func _ready() -> void:
	radius = $CollisionShape3D.shape.radius
	calculateBasis()
	indicators.resize(max_indicators)

func calculateBasis():
	var x_rotation = rotation.x + (PI / 2 - rotation.x)
	var reverse = 1
	if(rotation.x > PI / 2): reverse = -1
	m_basis.x = Vector3(cos(rotation.y), 0, 0) * reverse
	m_basis.y = -Vector3(0, cos(x_rotation), sin(x_rotation))
	m_basis.z = -Vector3(sin(rotation.y), 0, 0) * reverse

func hit(pos : Vector3):
	# instantiate a red sphere at the location
	var newObj = indicator.instantiate()
	
	num_indicators += 1
	if(num_indicators > max_indicators):
		indicators[num_indicators % max_indicators].queue_free()
	indicators[num_indicators % max_indicators] = newObj
	
	newObj.position = pos - global_position
	add_child(newObj)
	newObj.position = m_basis * newObj.position
	if(newObj.position.x * newObj.position.x + newObj.position.z * newObj.position.z > radius * radius):
		newObj.position = radius * newObj.position.normalized()

func damage(value):
	# could display a damage text?
	pass
 
