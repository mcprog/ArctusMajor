extends Node

const Nouns = [
	"Atom",
	"Aerolite",
	"Aphelion",
	"Archimedes",
	"Argon",
	"Aurora",
	"Boyle",
	"Corona",
	"Curie",
	"Deuterium",
	"Digit",
	"Dwarf",
	"Dyanmite",
	"Element",
	"Emission",
	"Fitzgerald",
	"Ground",
	"Illimination",
	"Impulse",
	"Kepler",
	"Meson",
	"Neptune",
	"Nova",
	"Parallax",
	"Planck",
	"Tensor",
	"Umbra"
];

const Adjectives = [
	"Alpha",
	"Abosolute",
	"Artificial",
	"Atomic",
	"Binary",
	"Beta",
	"Celestial",
	"Conic",
	"Cosmic",
	"Dark",
	"Delta",
	"Diurnal",
	"Ecliptic",
	"Falling",
	"Fourth",
	"Gamma",
	"Heavy",
	"Hygroscopic",
	"Inert",
	"Inverse",
	"Magellenic",
	"Nuclear",
	"Open",
	"Radical",
	"Second",
	"Solar",
	"Squared",
	"Static",
	"Stereo",
	"Variable"
];

var rng:RandomNumberGenerator

func _ready():
	rng = RandomNumberGenerator.new();
	rng.randomize();

func generate_name() -> String:
	var ret = "";
	var noun_i = rng.randi_range(0, Nouns.size() - 1);
	var adj_i = rng.randi_range(0, Adjectives.size() - 1);
	ret += str(Nouns[noun_i]) + str(Adjectives[adj_i]);
	return ret;