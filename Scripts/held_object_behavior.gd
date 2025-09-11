extends Node3D

@export var animationPlayer : AnimationPlayer

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
	if(currentObject.type == "MeleeWeapon"):
		animationPlayer.play("melee_weapon_swing")
		# raycast out damage
		
