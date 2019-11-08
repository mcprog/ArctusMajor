extends Node

enum Difficulty {
	Easy, Normal, Hard
	

}

static func get_difficulty_str(diff: int):
	if (diff == 0):
		return "easy";
	elif (diff == 1):
		return "normal";
	else:
		return "hard";

class SaveData:
	var filename: String;
	var Name: String;
	var Seed: int;
	var difficulty: int;
	var date_fmt: String;
	
	func to_str() -> String:
		return "{ " + filename + ", " + Name + ", " + str(Seed) + ", " + str(difficulty) + ", " + date_fmt + " }";
	
	static func sort(a:SaveData, b:SaveData) -> bool:
		var listA = a.date_fmt.split('-');
		var listB = b.date_fmt.split('-');
		var yearA = int(listA[0]);
		var yearB = int(listB[0]);
		if (yearA == yearB):
			var monthA = int(listA[1]);
			var monthB = int(listB[1]);
			if (monthA == monthB):
				var dayA = int(listA[2]);
				var dayB = int(listB[2]);
				if (dayA == dayB):
					var hourA = int(listA[3]);
					var hourB = int(listB[3]);
					if (hourA == hourB):
						return int(listA[4]) > int(listB[4]);
					return hourA > hourB;
				return dayA > dayB;
			return monthA > monthB;
		return yearA > yearB;

var saves: Array;
var savenames: Array;

static func save_new_game(Name:String, Seed:int, difficulty:int) -> void:
	var date_fmt = get_date_fmt()
	var savename = "save" + date_fmt + ".save";
	Global.ActiveFilename = savename;
	Global.ActiveName = Name;
	Global.ActiveSeed = Seed;
	Global.ActiveDifficulty = difficulty;
	Global.ActiveDatetime = date_fmt;
	save_game(Name, savename, Seed, difficulty);

static func get_date_fmt() -> String:
	var dict = OS.get_datetime();
	var date_fmt = str(dict.year) + "-" + str(dict.month) + "-" + str(dict.day) + "-" + str(dict.hour) + "-" + str(dict.minute);
	return date_fmt;	

static func save_active_game() -> void:
	save_game(Global.ActiveName, Global.ActiveFilename, Global.ActiveSeed, Global.ActiveDifficulty);

static func save_game(Name:String, filename:String, Seed:int, difficulty:int) -> void:
	var save_file = File.new();
	save_file.open("user://" + filename, File.WRITE);
	save_file.store_line(get_date_fmt());
	save_file.store_line(Name)
	save_file.store_line(str(Seed))
	save_file.store_line(str(difficulty))
	save_file.close();

func load_all_saves() -> void:
	saves = [];
	for savename in savenames:
		var save_data = SaveData.new();
		var file = File.new();
		file.open("user://" + savename, File.READ);
		save_data.filename = savename;
		save_data.date_fmt = file.get_line();
		save_data.Name = file.get_line();
		save_data.Seed = int(file.get_line());
		save_data.difficulty = int(file.get_line());
		file.close();
		add_save(save_data);
	saves.sort_custom(SaveData, "sort");

func present_save_data() -> void:
	for s in saves:
		print(s.to_str());

func add_save(save: SaveData) -> void:
	saves.append(save);

func init_save_filenames() -> void:
	savenames = [];
	var dir = Directory.new();
	dir.open("user://");
	dir.list_dir_begin();
	var file = dir.get_next();
	while (file):
		if (file.ends_with(".save")):
			savenames.append(file);
		file = dir.get_next()
	dir.list_dir_end();
	savenames.sort();
	savenames.invert();

