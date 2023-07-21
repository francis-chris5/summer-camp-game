extends CanvasLayer

@onready var score_label = $Panel/score_label
var score = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	score_label.text = "Score: " + str(score)
