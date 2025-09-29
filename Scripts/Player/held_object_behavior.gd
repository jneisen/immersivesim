extends Node3D

@export var player : CharacterBody3D
@export var animationPlayer : AnimationPlayer
@export var hitCast : RayCast3D

var currentObjectModel = null
var currentObject = null

var currentMeleeRange : float

var drawingBow : bool = false
var started : bool = false
var timePassed : float = 0

func _physics_process(delta: float) -> void:
	if(drawingBow && (animationPlayer.current_animation == "" || started)):
		started = true
		if(Input.is_action_pressed("fire")):
			if(animationPlayer.current_animation == ""):
				animationPlayer.play("ranged_weapon_shudder")
			timePassed += delta
			# when its released, fire the projectile
		else:
			var arrow = currentObject.projectile.instantiate()
			var look_dir = player.getLookDir()
			var look_vector3 = Vector3(sin(look_dir.x), sin(-look_dir.y - PI / 72), -cos(look_dir.x))
			var firing_time = currentObject.projectile_speed * min(1, timePassed / currentObject.firing_speed)
			arrow.linear_velocity = currentObject.projectile_speed * look_vector3 * firing_time
			arrow.position = global_position
			arrow.look_at_from_position(global_position, arrow.linear_velocity * 10)
			get_tree().root.add_child(arrow)
			animationPlayer.play("ranged_weapon_fire")
			timePassed = 0
			drawingBow = false
			started = false
func holdingItem(object : Item):
	notHoldingItem()
	if(!object):
		return
	# show the model stored in that item
	currentObject = object
	var itemObject = object.model.instantiate()
	currentObjectModel = itemObject
	add_child(itemObject)
	animationPlayer.stop()

func notHoldingItem():
	if(currentObjectModel):
		currentObjectModel.queue_free()
	currentObjectModel = null
	currentObject = null

func isHoldingItem():
	if(currentObject == null):
		return false
	return true

func useHeldItem():
	if(!currentObject):
		return
	elif(currentObject.type == "Melee Weapon"):
		animationPlayer.speed_scale = currentObject.swing_speed
		currentMeleeRange = currentObject.range
		animationPlayer.play("melee_weapon_swing")
	elif(currentObject.type == "Ranged Weapon"):
		if(currentObject.firing_type == "gun" && animationPlayer.current_animation == ""):
			# spawn a bullet in look_dir
			var bullet = currentObject.projectile.instantiate()
			var look_dir = player.getLookDir()
			var look_vector3 = Vector3(sin(look_dir.x), sin(-look_dir.y - PI / 72), -cos(look_dir.x))
			bullet.linear_velocity = currentObject.projectile_speed * look_vector3
			bullet.look_at_from_position(global_position, bullet.linear_velocity * 10)
			bullet.position = global_position
			get_tree().root.add_child(bullet)
			animationPlayer.speed_scale = currentObject.firing_speed
			animationPlayer.play("ranged_weapon_fire")
		if(currentObject.firing_type == "bow"):
			animationPlayer.speed_scale = 1.5
			drawingBow = true

func raycastInFront():
	# use player raycast
	var look_dir = player.getLookDir()
	hitCast.target_position = Vector3(0, 0, -currentMeleeRange * 2.5)
	hitCast.rotation = Vector3(-look_dir.y, 0, 0)
	var collision = hitCast.get_collider()
	if(collision == null):
		return
	# collision layer 4
	if(collision.collision_layer & 8 > 0):
		collision.damage(currentObject.damage)
