extends Menu

@onready var selected = $Selected

const SELECTED_FORMAT = "%s:\n\"%s\"\n\nHigh Score: %d\nBest Time: %s\nBest Rank: %d"
const HEADERS = [
	"High Score",
	"Best Time",
	"Best Rank"
]
const PADDING = "   "
var TABLE_FORMAT = ""

var level_data : Array
var current : LevelData

func _ready():
	RenderingServer.set_default_clear_color(bg_color)
	GS.play_music(music)
	for i in HEADERS:
		TABLE_FORMAT += "%s%%%ds%s" % [PADDING, i.length(), PADDING]
	$ColumnHeader.text = TABLE_FORMAT % HEADERS
	
	level_data = parent.emit(GS.MAN_ID.NULL, "GET PTHRUS").get_prop("level_data")
	for i in range(level_data.size()):
		button_group.add_child(LevelSelectButton.new(level_data[i], i, level_selected, TABLE_FORMAT))

func level_selected(data : LevelData):
	current = data
	var stats = [data.level_ID, tr("GAME_Level" + data.level_ID), data.highscore, GS.format_seconds(data.besttime), data.bestrank]
	selected.text = SELECTED_FORMAT % stats

func _on_level_start_pressed() -> void:
	if current != null:
		parent.emit(GS.MAN_ID.NULL, "%d %s" % [GS.MAN_ID.LEVEL, current.level_ID])
	else:
		print("GO FUCK YOURSELF")
