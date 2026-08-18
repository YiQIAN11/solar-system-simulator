#res://src/camera_switcher.gd
	#Copyright (C) 2026 Yi Qian
#
	#This program is free software: you can redistribute it and/or modify
	#it under the terms of the GNU General Public License as published by
	#the Free Software Foundation, either version 3 of the License, or
	#(at your option) any later version.
#
	#This program is distributed in the hope that it will be useful,
	#but WITHOUT ANY WARRANTY; without even the implied warranty of
	#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	#GNU General Public License for more details.
#
	#You should have received a copy of the GNU General Public License
	#along with this program.  If not, see <https://gnu.net.cn/licenses/>.

extends CanvasLayer

@export var camera_paths: Array[NodePath] = []
@export var camera_labels: Array[String] = []
@export var orbit_paths: Array[NodePath] = []
@export var orbit_labels: Array[String] = []

var cameras: Array[CharacterBody3D] = []
var orbit_nodes: Array[MeshInstance3D] = []
var active_camera_index: int = 0
var menu_visible: bool = false

@onready var menu_panel: Panel = $Control/Panel
@onready var vbox: VBoxContainer = $Control/Panel/ScrollContainer/VBoxContainer

func _ready():
	# Resolve NodePaths to actual camera nodes
	for path in camera_paths:
		var cam = get_node(path)
		if cam is CharacterBody3D:
			cameras.append(cam)

	# Resolve NodePaths to orbit ring meshes
	for path in orbit_paths:
		var orbit = get_node(path)
		if orbit is MeshInstance3D:
			orbit_nodes.append(orbit)

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

	_build_orbit_checkboxes()

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

func _build_orbit_checkboxes():
	if orbit_nodes.is_empty():
		return

	vbox.add_child(HSeparator.new())

	var title = Label.new()
	title.text = "Orbit Paths"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(title)

	for i in range(orbit_nodes.size()):
		var checkbox = CheckBox.new()
		checkbox.text = orbit_labels[i] if i < orbit_labels.size() else orbit_nodes[i].name
		checkbox.button_pressed = orbit_nodes[i].visible
		checkbox.toggled.connect(_on_orbit_toggled.bind(i))
		vbox.add_child(checkbox)

func _on_orbit_toggled(pressed: bool, index: int):
	if index >= 0 and index < orbit_nodes.size():
		orbit_nodes[index].visible = pressed
