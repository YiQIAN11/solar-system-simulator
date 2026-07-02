   #res://src/revolution.gd
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
	
extends Node3D

@export var revolution_speed: float

func _process(delta):
	rotate_y(deg_to_rad(revolution_speed * delta))
