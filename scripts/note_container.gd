extends Control

@export var note_on_staff: PackedScene

func _ready() -> void:
	#populate_container_by_type()
	pass

func populate_container_by_type(type: String = "note_on_staff") -> void:
	var populated_scene: NoteOnStaff = note_on_staff.instantiate()
	add_child(populated_scene)
