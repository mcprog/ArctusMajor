extends Area2D


export var texture_path: String = "raw_iron";

onready var sprite = $Sprite;

func _ready():
	sprite.texture = load("res://textures/" + texture_path + ".png");


