class_name NoteElement extends Control

static var notes_properties: Dictionary = {
	"A4":{"location":5,"color":Color.AQUA},
	"B4":{"location":6,"color":Color.AQUA},
	"C4":{"location":0,"color":Color.AQUA},
	"D4":{"location":1,"color":Color.AQUA},
	"E4":{"location":2,"color":Color.AQUA},
	"F4":{"location":3,"color":Color.AQUA},
	"G4":{"location":4,"color":Color.AQUA},
}
static var stem_reverse_location_threshold: int

var note: String
@onready var game_manager: GameManager = %GameManager

func _ready() -> void:
	stem_reverse_location_threshold = notes_properties["B4"]["location"]
	pass

func change_note(new_note: String) -> void:
	note = new_note

func play_success_effects() -> void:
	pass

func set_element_theme(theme: String = "light") -> void:
	match theme:
		"light":
			pass
		"dark":
			pass

#func position_note(new_note: String) -> void:
	#pass
