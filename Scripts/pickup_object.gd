extends RigidBody3D

@export var objectName = "Sword"
var objectType = "PickupFromWorld"

func interact():
	# delete this object
	self.call_deferred("queue_free")
	return objectName
