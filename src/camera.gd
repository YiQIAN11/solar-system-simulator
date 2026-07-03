   #res://src/camera.gd
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
	
extends CharacterBody3D

@export var speed: float
@export var mouse_sensitivity: float
@export var vertical_speed: float = 1.0
@export var is_active: bool = true

@onready var camera: Camera3D = $Camera3D

func _ready():
	if is_active:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func set_active(active: bool):
	is_active = active
	camera.current = active
	if active:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _input(event):
	if not is_active:
		return
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)
		camera.rotate_x(-event.relative.y * mouse_sensitivity)

func _physics_process(_delta):
	if not is_active:
		return
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	var vertical = 0.0
	if Input.is_action_pressed("ui_accept"):
		vertical += vertical_speed
	if Input.is_action_pressed("move_down"):
		vertical -= vertical_speed

	direction.y = vertical

	velocity = direction * speed
	move_and_slide()
