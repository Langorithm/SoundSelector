extends PanelContainer

var preview_browser: VBoxContainer
var favorites_browser: VBoxContainer
const sound_button_scene = preload("res://components/SoundButton.tscn")
const PREVIEW_ITEM = preload("res://components/preview_item.tscn")

func _ready():
	preview_browser = find_child("PreviewBrowser",true)
	favorites_browser = find_child("FavoritesBrowser",true)
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
			display_favorites
		)
		item_preview.favorite_unchecked.connect(
			display_favorites
		)
		
		
	if browser == favorites_browser:
		item_preview.remove_child(item_preview.texture_button)


	return item_preview

func display_favorites():
	favorites_browser.get_children().map(
		func(child): favorites_browser.remove_child(child)
	)
	var favorites = preview_browser.get_children().filter(
		func(child:PreviewItem): return child.texture_button.button_pressed
	)
	favorites.map(
		func(favorite:PreviewItem):
			var new = make_new_item(favorite.file_path, favorites_browser)
	)
	

	#
#func add_to_favorites(preview_item: PreviewItem):
	#var favorited_item = make_new_item(preview_item.file_path, favorites_browser) as PreviewItem
	#favorited_item.texture_button.button_pressed = true
	#favorited_item.favorite_unchecked.connect(
		#remove_from_favorites.bind(favorited_item)
	#)
	#favorited_item.backlink = preview_item
	#preview_item.favorite_unchecked.connect(
		#remove_from_favorites.bind(favorited_item)
	#)
#
#
#func remove_from_favorites(preview_item: PreviewItem):
	#preview_item.backlink.texture_button.button_pressed = false
	#preview_item.get_parent().remove_child(preview_item)
	#preview_item.queue_free()
	#
