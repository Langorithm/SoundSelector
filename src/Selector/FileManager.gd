extends PanelContainer

var preview_browser: VBoxContainer
var favorites_browser: VBoxContainer
const sound_button_scene = preload("res://components/SoundButton.tscn")
const PREVIEW_ITEM = preload("res://components/preview_item.tscn")

func _ready():
	preview_browser = find_child("PreviewBrowser",true)
	favorites_browser = find_child("SelectedsBrowser",true)
	get_tree().get_root().files_dropped.connect(_on_files_dropped)
	

func _on_files_dropped(dropped_files):
	for path in dropped_files:
		#Path is Directory
		if DirAccess.dir_exists_absolute(path):
			var dir_filepaths = DirAccess.get_files_at(path)
			for file_name in dir_filepaths:
				make_new_item(path.path_join(file_name),preview_browser)
		#Path is File
		else:
			make_new_item(path, preview_browser)


func make_new_item(file_path: StringName, browser: BoxContainer) -> PreviewItem:
	var item_preview = PREVIEW_ITEM.instantiate()
	item_preview.file_path = file_path
	browser.add_child(item_preview)
	
	
	if browser == preview_browser:
		item_preview.favorite_checked.connect(
			add_to_favorites.bind(file_path),
			CONNECT_ONE_SHOT
		)
		item_preview.favorite_checked.connect(
			add_to_favorites.bind(file_path),
			CONNECT_ONE_SHOT
		)
	return item_preview
	
func add_to_favorites(file_path):
	var item = make_new_item(file_path, favorites_browser)
	item.favorite_unchecked.connect()


	
func unfavorite_item(preview_item: PreviewItem):
	preview_item.get_parent().remove_child(preview_item)
	preview_item.queue_free()
	
