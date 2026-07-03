extends CanvasLayer

@export var camera_paths: Array[NodePath] = []
@export var camera_labels: Array[String] = []

var cameras: Array[CharacterBody3D] = []
var active_camera_index: int = 0
var menu_visible: bool = false

@onready var menu_panel: Panel = $Control/Panel
@onready var vbox: VBoxContainer = $Control/Panel/VBoxContainer

func _ready():
	# Resolve NodePaths to actual camera nodes
	for path in camera_paths:
		var cam = get_node(path)
		if cam is CharacterBody3D:
			cameras.append(cam)

	if cameras.is_empty():
		return

	# Only the first camera (free camera) is active by default
	for i in range(cameras.size()):
		cameras[i].set_active(i == 0)
	active_camera_index = 0

	# Build buttons dynamically from exported labels
	for i in range(camera_labels.size()):
		var btn = Button.new()
		btn.text = camera_labels[i]
		btn.pressed.connect(_on_camera_button_pressed.bind(i))
		vbox.add_child(btn)

	menu_panel.hide()

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		toggle_menu()

func toggle_menu():
	menu_visible = !menu_visible
	if menu_visible:
		menu_panel.show()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		menu_panel.hide()
		if cameras.size() > active_camera_index:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_camera_button_pressed(index: int):
	if index < 0 or index >= cameras.size():
		return
	if index == active_camera_index:
		toggle_menu()
		return

	# Deactivate current camera
	cameras[active_camera_index].set_active(false)

	# Activate selected camera
	active_camera_index = index
	cameras[active_camera_index].set_active(true)

	# Close menu and capture mouse
	menu_visible = false
	menu_panel.hide()
