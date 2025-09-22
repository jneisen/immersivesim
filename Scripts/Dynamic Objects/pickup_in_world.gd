extends RigidBody3D

#@export var objectName = "Box"
@export var damageable = true
@export var health = 1
@onready var collider = $CollisionShape3D
var objectType = "PickupInWorld"
var follow = null
var rotationFollow = null

func _ready() -> void:
	contact_monitor = true
	max_contacts_reported = 5

func damage(amount : int):
	if(!damageable):
		return
	health -= amount
	if(health <= 0):
		self.queue_free()

func getObjectType():
	return objectType

func _physics_process(_delta: float) -> void:
	if(follow):
		# try to get to follow.global_position
		linear_velocity = (follow.global_position - global_position) * 10
		look_at(rotationFollow.global_position)
		if(horizontalDistance(global_position - follow.global_position) > 2):
			# tell the player to drop
			rotationFollow.droppedHeldObject()
			drop(Vector3.ZERO)

func interact(player : CharacterBody3D, heldObjectPosition : Node3D):
	# bind this object to the held object position
	follow = heldObjectPosition
	rotationFollow = player
	#return collider

func drop(m_velocity : Vector3):
	follow = null
	rotationFollow = null
	angular_velocity = Vector3.ZERO
	if(200 / mass < 2):
		linear_velocity = m_velocity * 200 / mass
	else:
		linear_velocity = m_velocity * 2
		
func horizontalDistance(vector : Vector3):
	return distance(Vector3(vector.x, 0, vector.z))
func distance(vector : Vector3):
	var sqddst = vector.x * vector.x + vector.y * vector.y + vector.z * vector.z
	return sqrt(sqddst)
