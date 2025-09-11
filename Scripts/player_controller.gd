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

const SQRTOFTWO = 1.4142

var forward : bool = false
var left : bool = false
var right : bool = false
var backward : bool = false

var look_dir : Vector2 # way that the character is facing

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
	hotbarInput()

func hotbarInput():
	if(Input.is_action_just_pressed("hotbar_slot_1")):
		inventory.hotbarInteraction(1)

func _physics_process(_delta: float) -> void:
	basicMovement()
	
	handleRaycast()
	
	rotation = Vector3(0, -look_dir.x, 0)
	camera.rotation = Vector3(-look_dir.y, 0, 0)
	move_and_slide()
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider().get_collision_layer_value(2):
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
	lookRay.rotation = Vector3(-look_dir.y, 0, 0)
	var collision = lookRay.get_collider()
	if(collision == null):
		objectHighlighter.hide()
		return
	if(collision.collision_layer & 2 > 0):
		# highlight
		objectHighlighter.unhide()
		objectHighlighter.move(camera.global_position, collision.global_position)
		if(Input.is_action_pressed("interact")):
			# value is null unless an object was picked up
			var value = collision.interact()
			if(value):
				inventory.addItem(collision.get_name())
		return
	objectHighlighter.hide()
