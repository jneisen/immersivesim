extends RigidBody3D

var damage = 5
@export var size = 0

func _physics_process(_delta: float) -> void:
	look_at(linear_velocity * 10)

func _on_body_entered(body: Node) -> void:
	if(body is RigidBody3D && body.collision_layer & 8 > 0):
		body.damage(damage)
	if(body.collision_layer & 8 > 0 && body.has_method("hit")):
			body.hit(global_position)
	queue_free()
