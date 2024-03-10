extends Label
var node
var middle
func on_viewport_resize():
	middle = get_viewport_rect().size / 2
	if node != null:
		node.set_position(middle, false)
		
#func play_mp3(path):
	#var file = FileAccess.open(path, FileAccess.READ)
	#var sound = AudioStreamMP3.new()
	#sound.data = file.get_buffer(file.get_length())
	#return sound

# Called when the node enters the scene tree for the first time.
func _ready():
	middle = get_viewport_rect().size / 2
	get_tree().get_root().size_changed.connect(on_viewport_resize)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _input(event):
	if event is InputEventJoypadButton or event is InputEventJoypadMotion:
		pass
	if event is InputEventKey and event.is_pressed():
		if event.keycode == KEY_SPACE: 
			if node != null:
				node.queue_free()
			

			node = Label.new()
			node.set_name("popup")
			node.set_text("Bom")
			node.set_position(middle, false)
			var audio_player = $bom_player
			if !audio_player.playing:
				#audio_player.stream = play_mp3("res://public/mp3/Boom (Big Shaq).mp3")
				audio_player.play()
				

			add_child(node)
	
