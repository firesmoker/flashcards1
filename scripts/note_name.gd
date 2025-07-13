class_name NoteName extends NoteElement
@onready var label: Label = $Label
@onready var button: Button = $Button


func _ready() -> void:
	source = self
	label.text = note


func _on_button_button_up() -> void:
	print("puff")
