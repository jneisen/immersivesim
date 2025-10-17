extends RigidBody3D

# all base enemy will do is bleed when hit
var health = 100
@export var blood_particle : PackedScene
var blood
var timer = Timer.new()

func _ready() -> void:
	add_child(timer)
	timer.timeout.connect(delete_blood)

func damage(amount):
	print(health)
	health -= amount
	if(health <= 0):
		queue_free()
	# bleed where the projectile hit
	if(blood != null):
		blood.queue_free()
	blood = blood_particle.instantiate()
	add_child(blood)
	blood.emitting = true
	timer.start(1)


func delete_blood():
	if(blood):
		blood.queue_free()
