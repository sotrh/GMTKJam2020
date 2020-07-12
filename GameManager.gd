extends Node2D

const Maze = preload("res://Maze.gd")
const Player = preload("res://Player.gd")

const State = Player.State
const Orientation = Maze.Orientation

const HINTS = [
	"Ball: roll with LEFT and RIGHT, jump with SPACE",
	"Weight: sit around until you transform into something useful",
	"Spring: mouse to aim, SPACE to jump",
]

onready var maze: Maze = $Maze
onready var player: Player = $Player
onready var label: Label = $Timer
onready var hint: Label = $HintText

var next_state = State.Ball
var next_orientation = Orientation.DEG0

var time_since_last_change = 0.0
export(int) var time_between_changes = 10.0

func calc_next_state():
	match player.state:
		State.Ball:
			next_state = [State.Cube, State.Spring][randi() % 2]
		State.Cube:
			next_state = [State.Ball, State.Spring][randi() % 2]
		State.Spring:
			next_state = [State.Cube, State.Ball][randi() % 2]

func calc_next_orientation():
	var values = Orientation.values()
	next_orientation = values[randi() % values.size()]
	while next_orientation == maze.current_orientation:
		next_orientation = values[randi() % values.size()]
		
func update_hint_text():
	hint.text = HINTS[player.state]
			
func _ready():
	randomize()
	calc_next_state()
	player.state = next_state
	calc_next_state()
	update_hint_text()


func _process(delta):
	time_since_last_change += delta
	label.text = "Changing in %d" % int(time_between_changes - time_since_last_change + 1)
	
	if time_since_last_change > time_between_changes:
		player.state = next_state
		maze.desired_orientation = next_orientation
		time_since_last_change = 0
		calc_next_state()
		calc_next_orientation()
		update_hint_text()
		
