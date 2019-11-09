extends Area2D

class_name Drop

export var texture_path: String = "raw_iron";
export var count: int = 9001;

onready var sprite = $Sprite;
onready var count_label = $Count;

const HideCount = false;

func _ready():
	sprite.texture = load("res://textures/" + texture_path + ".png");
	if (HideCount):
		count_label.visible = false;
		return;
	count_label.text = str(count);

