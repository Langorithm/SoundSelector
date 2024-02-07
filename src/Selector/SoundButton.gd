extends Button
class_name SoundPreview

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
var parent
var absolute_file_path
#@export var sound: AudioStream
#@export var file_path: StringName

func _ready() -> void:
	focus_entered.connect(audio_stream_player.play)
	focus_exited.connect(audio_stream_player.stop)
	parent = get_parent()

	
func load_file(file_path: StringName):
	absolute_file_path = file_path
	var file_data = FileAccess.open(file_path,FileAccess.READ)
	var stream
	match file_path.get_extension():
		"mp3":
			stream = AudioStreamMP3.new()
			stream.data = file_data.get_buffer(file_data.get_length())
			audio_stream_player.stream = stream
		"wav":
			stream = AudioStreamWAV.new()
			stream.data = file_data.get_buffer(file_data.get_length())
			audio_stream_player.stream = stream
		"ogg":
			audio_stream_player.stream = AudioStreamOggVorbis.load_from_file(file_path)
	

	text = file_path.get_file()
	

func play():
	if not audio_stream_player.playing:
		audio_stream_player.play()
	
