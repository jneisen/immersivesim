extends RigidBody3D

var damage = 5

func _physics_process(_delta: float) -> void:
	look_at(linear_velocity * 10)

func _on_body_entered(body: Node) -> void:
	if(body is RigidBody3D && body.collision_layer & 8 > 0):
		body.damage(damage)
	queue_free()
