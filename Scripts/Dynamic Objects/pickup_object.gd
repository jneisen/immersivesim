extends RigidBody3D

@export var objectName = "Needle"
var objectType = "PickupFromWorld"

func getObjectType():
	return objectType

func interact():
	# delete this object
	self.call_deferred("queue_free")
