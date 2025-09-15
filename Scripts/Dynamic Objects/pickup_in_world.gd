extends RigidBody3D

#@export var objectName = "Box"
@export var damageable = true
@export var health = 1
var objectType = "PickupInWorld"
var follow = null
var rotationFollow = null

func damage(amount : int):
	if(!damageable):
		return
	health -= amount
	if(health <= 0):
		self.queue_free()

func getObjectType():
	return objectType

func _physics_process(delta: float) -> void:
	if(follow):
		global_position = follow.global_position
		look_at(rotationFollow.global_position)

func interact(player : CharacterBody3D, heldObjectPosition : Node3D):
	# bind this object to the held object position
	follow = heldObjectPosition
	rotationFollow = player

func drop(m_velocity : Vector3):
	follow = null
	rotationFollow = null
	if(200 / mass < 2):
		linear_velocity = m_velocity * 200 / mass
	else:
		linear_velocity = m_velocity * 2
