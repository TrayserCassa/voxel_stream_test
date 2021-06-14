extends Camera

export var sensitivity = 0.3
export var min_angle = -90
export var max_angle = 90
export var min_distance = 1
export var max_distance = 3
export var capture_mouse = true
export var distance = 1.1

export var max_zoom = 2.0
export var min_zoom = 0.8
export var zoom_speed = 0.09
var zoom = 1.5

var _yaw = 0
var _pitch = 0
var _offset = Vector3()

func _ready():
  _offset = get_translation()
  if capture_mouse:
    Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
  if event is InputEventMouseButton:
    if event.pressed and Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
      if capture_mouse:
        Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
    
    if event.is_action_pressed("mouse_zoom_in"):
      zoom -= zoom_speed
    elif event.is_action_pressed("mouse_zoom_out"):
      zoom += zoom_speed
      
    zoom = clamp(zoom, min_zoom, max_zoom)
    update_rotations()
  
  elif event is InputEventMouseMotion:
    if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED || not capture_mouse:
      # Get mouse delta
      var motion = event.relative
      
      # Add to rotations
      _yaw -= motion.x * sensitivity
      _pitch += motion.y * sensitivity
      
      # Clamp pitch
      var e = 0.001
      if _pitch > max_angle-e:
        _pitch = max_angle-e
      elif _pitch < min_angle+e:
        _pitch = min_angle+e
      
      # Apply rotations
      update_rotations()
  
  elif event is InputEventKey:
    if event.is_action_pressed("ui_cancel"):
      Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func update_rotations():
  set_translation(Vector3())
  set_rotation(Vector3(0, deg2rad(_yaw), 0))
  rotate(get_transform().basis.x.normalized(), -deg2rad(_pitch))
  set_translation(get_transform().basis.z * zoom + _offset)
