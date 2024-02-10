extends PanelContainer

var preview_browser: VBoxContainer
var favorites_browser: VBoxContainer

var favorites_dict: Dictionary

const sound_button_scene = preload("res://components/SoundButton.tscn")
const PREVIEW_ITEM = preload("res://components/preview_item.tscn")

func _ready():
	preview_browser = find_child("PreviewBrowser",true)
	favorites_browser = find_child("FavoritesBrowser",true)
	get_tree().get_root().files_dropped.connect(_on_files_dropped)
	

#func _shortcut_input(event: InputEvent) -> void:
	#if event.is_released() and event.as_text() == "B":
		#print()
		#display_favorites.call_deferred()

func _on_files_dropped(dropped_files):
	for path in dropped_files:
		#Path is Directory
		if DirAccess.dir_exists_absolute(path):
			var dir_filepaths = DirAccess.get_files_at(path)
			for file_name in dir_filepaths:
				make_new_item(path.path_join(file_name))
		#Path is File
		else:
			make_new_item(path)


func make_new_item(file_path: StringName) -> PreviewItem:
	var preview_item = PREVIEW_ITEM.instantiate()
	preview_item.file_path = file_path
	preview_browser.add_child(preview_item)
	
	
	preview_item.favorite_checked.connect(
		#display_favorites
		make_new_favorite.bind(preview_item)
	)
	preview_item.favorite_unchecked.connect(
		remove_favorite.bind(preview_item)
	)

	return preview_item
	
	
func make_new_favorite(preview_item: PreviewItem) -> PreviewItem:
	#var favorited_item = PREVIEW_ITEM.instantiate()
	#favorites_browser.add_child(favorited_item)
	var favorited_item : PreviewItem = PREVIEW_ITEM.instantiate()
	favorited_item.file_path = preview_item.file_path
	favorites_browser.add_child(favorited_item)
	favorited_item.favorite_unchecked.connect(
		func (): 
			if favorites_browser.get_child(-1) == favorited_item:
				if favorites_browser.get_child_count() == 1:
					preview_browser.find_next_valid_focus().grab_focus.call_deferred()
				else:
					favorites_browser.get_child(-2).find_next_valid_focus().grab_focus.call_deferred()
			else:
				favorited_item.find_valid_focus_neighbor(SIDE_BOTTOM).grab_focus()
			preview_item.favorite_button.button_pressed = false
	)
	favorited_item.favorite_button.button_pressed = true
	#favorited_item.favorite_unchecked.connect(
		#func (): 
			#print(favorited_item.favorite_button.find_next_valid_focus().to_string())
				##favorited_item.find_valid_focus_neighbor(SIDE_BOTTOM).grab_focus()
			#preview_item.favorite_button.button_pressed = false
	#)
	assert(not favorites_dict.has(preview_item))
	favorites_dict[preview_item] = favorited_item
	return favorited_item


func remove_favorite(preview_item) -> void:
	assert(favorites_dict.has(preview_item))
	var favorited_item: PreviewItem = favorites_dict[preview_item]
	
	favorites_dict.erase(preview_item)
	favorites_browser.remove_child(favorited_item)
	favorited_item.queue_free()

#
#func display_favorites():
	#
	#for child in favorites_browser.get_children():
		#favorites_browser.remove_child(child)
		#child.queue_free()
#
	##for favorite in favorites.keys():
		##make_new_item(favorite.file_path, favorites_browser)
	#var favorites = preview_browser.get_children().filter(
		#func(child:PreviewItem): return child.favorite_button.button_pressed
	#)
	#favorites.map(
		#func(favorite:PreviewItem): make_new_favorite(favorite)
	#)
	#
	#
#func add_to_favorites(preview_item):
	#assert(not favorites.has(preview_item))
	#
	#favorites[preview_item] = null
	#display_favorites()
#
#func remove_from_favorites(preview_item):
	#assert(favorites.has(preview_item))
	#
	#favorites.erase(preview_item)
	#display_favorites()
	
	#
#func add_to_favorites(preview_item: PreviewItem):
	#var favorited_item = make_new_item(preview_item.file_path, favorites_browser) as PreviewItem
	#favorited_item.favorite_button.button_pressed = true
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
	#preview_item.backlink.favorite_button.button_pressed = false
	#preview_item.get_parent().remove_child(preview_item)
	#preview_item.queue_free()
	#
