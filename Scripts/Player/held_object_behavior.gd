extends Node3D

@export var player : CharacterBody3D
@export var animationPlayer : AnimationPlayer
@export var hitCast : RayCast3D

var currentObjectModel = null
var currentObject = null

func holdingItem(object : Item):
	# show the model stored in that item
	currentObject = object
	var itemObject = object.model.instantiate()
	currentObjectModel = itemObject
	add_child(itemObject)

func notHoldingItem():
	currentObjectModel.queue_free()
	currentObjectModel = null
	currentObject = null

func useHeldItem():
	if(!currentObject):
		return
	elif(currentObject.type == "MeleeWeapon"):
		animationPlayer.play("melee_weapon_swing")
		# raycast out damage

func raycastInFront():
	# use player raycast
	var look_dir = player.getLookDir()
	hitCast.rotation = Vector3(-look_dir.y, 0, 0)
	var collision = hitCast.get_collider()
	if(collision == null):
		return
	# collision layer 4
	if(collision.collision_layer & 8 > 0):
		collision.damage(currentObject.damage)
