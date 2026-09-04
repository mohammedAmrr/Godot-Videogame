extends CharacterBody3D


const WALK_SPEED = 5.0
const SPRINT_SPEED = 8.0
const SENS = 0.005 
const JUMP_VELOCITY = 4.5
#bob vars
const BOB_FREQ = 2.0
const BOB_AMP = 0.08
var tbob = 0.0

@onready var head = $head
@onready var cam = $head/Camera3D

var speed

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func  _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENS)
		cam.rotate_x(-event.relative.y * SENS)
		cam.rotation.x = clamp(cam.rotation.x, deg_to_rad(-55), deg_to_rad(65))
	else:
		pass

func _physics_process(delta: float) -> void:
	
	
	if Input.is_action_pressed("sprint"):
		speed = SPRINT_SPEED
	else:
		speed = WALK_SPEED
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("space") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("a", "d", "w", "s")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	
	#head bob
	tbob += delta * velocity.length() * float(is_on_floor())
	cam.transform.origin = headbob(tbob)
	
	move_and_slide()
func headbob(time) ->Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = cos(time * BOB_FREQ / 2) * BOB_AMP
	return pos
