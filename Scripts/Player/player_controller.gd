extends CharacterBody3D

@export_range(5, 20, 1) var speed : float = 10
var friction : float = 0.8
var airFriction : float = 0.98
@export_range(0, 1, 0.05) var airAccelerationFraction : float = 0.1
@export_range(0, 10, 0.1) var acceleration : float = 1.5
@export_range(5, 20, 1) var jump : float = 10

@export var camera : Camera3D
@export var lookRay : RayCast3D

@export var playerUI : Control
@export var objectHighlighter : Sprite3D
@export var inventory : Node3D
@export var playerHand : Node3D
@export var heldObjectNode : Node3D

# true if holding an object
var heldObject : Node3D = null

const SQRTOFTWO = 1.4142

var forward : bool = false
var left : bool = false
var right : bool = false
var backward : bool = false

var look_dir : Vector2 # way that the character is facing

var lookingAtText : bool = false

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		look_dir += event.relative * 0.005

func _process(_delta : float) -> void:
	if(Input.is_action_pressed("forward")):
		forward = true
	else:
		forward = false
	if(Input.is_action_pressed("left")):
		left = true
	else:
		left = false
	if(Input.is_action_pressed("right")):
		right = true
	else:
		right = false
	if(Input.is_action_pressed("backward")):
		backward = true
	else:
		backward = false
	
	if(Input.is_action_just_pressed("fire")):
		playerHand.useHeldItem()
	
	if(Input.is_action_just_pressed("esc")):
		if(lookingAtText):
			# hide the text
			playerUI.hideTextbox()
			unpauseGame()
		else:
			# show the main menu and pause
			pauseGame()
	
	hotbarInput()

func hotbarInput():
	if(Input.is_action_just_pressed("hotbar_slot_1")):
		inventory.hotbarInteraction(1)
	elif(Input.is_action_just_pressed("hotbar_slot_2")):
		inventory.hotbarInteraction(2)
	elif(Input.is_action_just_pressed("hotbar_slot_3")):
		inventory.hotbarInteraction(3)
	elif(Input.is_action_just_pressed("hotbar_slot_4")):
		inventory.hotbarInteraction(4)
	elif(Input.is_action_just_pressed("hotbar_slot_5")):
		inventory.hotbarInteraction(5)
	elif(Input.is_action_just_pressed("hotbar_slot_6")):
		inventory.hotbarInteraction(6)
	elif(Input.is_action_just_pressed("hotbar_slot_7")):
		inventory.hotbarInteraction(7)
	elif(Input.is_action_just_pressed("hotbar_slot_8")):
		inventory.hotbarInteraction(8)
	elif(Input.is_action_just_pressed("hotbar_slot_9")):
		inventory.hotbarInteraction(9)
	elif(Input.is_action_just_pressed("hotbar_slot_0")):
		inventory.hotbarInteraction(10)

func _physics_process(_delta: float) -> void:
	basicMovement()
	
	handleRaycast()
	
	rotation = Vector3(0, -look_dir.x, 0)
	camera.rotation = Vector3(-look_dir.y, 0, 0)
	move_and_slide()
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if(c.get_collider() == RigidBody3D && c.get_collider().collision_layer & 2 > 0):
			c.get_collider().apply_central_impulse(-c.get_normal()*1)

func basicMovement():
	var airCoefficient = 1
	if(!is_on_floor()):
		airCoefficient = airAccelerationFraction
	if(forward):
		velocity += airCoefficient * acceleration * Vector3(sin(look_dir.x), 0, -cos(look_dir.x))
	if(left):
		velocity += airCoefficient * acceleration * Vector3(-cos(look_dir.x), 0, -sin(look_dir.x))
	if(right):
		velocity += airCoefficient * acceleration * Vector3(cos(look_dir.x), 0, sin(look_dir.x))
	if(backward):
		velocity += airCoefficient * acceleration * Vector3(-sin(look_dir.x), 0, cos(look_dir.x))
	
	if(Input.is_action_just_pressed("jump") && is_on_floor()):
		velocity.y += jump
	elif(is_on_floor()):
		velocity.y = 0
	else:
		velocity += get_gravity() * 0.05
	
	#friction
	if(is_on_floor()):
		velocity.x *= friction
		velocity.z *= friction
	else:
		velocity.x *= airFriction
		velocity.z *= airFriction
	
	# limit velocity in the z and x directions
	var velocityxz = Vector2(velocity.x, velocity.z)
	if(velocityxz.length() > speed * SQRTOFTWO):
		velocityxz = (velocityxz.normalized() * speed)
		velocity = Vector3(velocityxz.x, velocity.y, velocityxz.y)

func handleRaycast():
	if(heldObject):
		if(Input.is_action_just_pressed("interact")):
			dropHeldObject()
		return
	
	lookRay.rotation = Vector3(-look_dir.y, 0, 0)
	var collision = lookRay.get_collider()
	if(collision == null):
		objectHighlighter.hide()
		return
	if(collision.collision_layer & 2 > 0):
		# highlight
		objectHighlighter.unhide()
		objectHighlighter.move(camera.global_position, collision)
		if(Input.is_action_just_pressed("interact")):
			if(collision.getObjectType() == "PickupFromWorld"):
				collision.interact()
				inventory.addItem(collision.objectName)
			elif(collision.getObjectType() == "PickupInWorld" && !inventory.isHoldingItem()):
				collision.interact(self, heldObjectNode)
				heldObject = collision
				objectHighlighter.hide()
			elif(collision.getObjectType() == "Text"):
				if(!lookingAtText):
					lookingAtText = true
					playerUI.displayTextbox(collision.interact())
					pauseGame()
				else:
					lookingAtText = false
					playerUI.hideTextbox()
					unpauseGame()
			elif(collision.getObjectType() == "Interact"):
				collision.interact()
		return
	objectHighlighter.hide()

func getLookDir():
	return look_dir

func dropHeldObject():
	var dropVelocity = 4 * Vector3(sin(look_dir.x), 2 * max(-sin(look_dir.y), 0.5), -cos(look_dir.x))
	heldObject.drop(dropVelocity)
	await get_tree().create_timer(0.1).timeout
	heldObject = null

func droppedHeldObject():
	await get_tree().create_timer(0.1).timeout
	heldObject = null

func pauseGame():
	pass
func unpauseGame():
	pass
