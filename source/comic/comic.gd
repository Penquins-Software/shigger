class_name Comic
extends MenuElement

@export var _left_button: Button
@export var _right_button: Button
@export var exit_button: Button

@export var _pages: Array[ComicPage]

var _current_page: int = 0


func _ready():
	_left_button.pressed.connect(_to_left)
	_right_button.pressed.connect(_to_right)
	
	_to_first()


func show_and_focus() -> void:
	show()
	focus_element.grab_focus()
	_to_first()


func _to_first() -> void:
	_pages[_current_page].visible = false
	_current_page = 0
	_pages[0].visible = true
	_pages[0].to_first()
	_check_buttons()


func _to_left() -> void:
	if not _pages[_current_page].prev_frame():
		_check_buttons()
		return
	
	var new_page = _current_page - 1
	if new_page > -1:
		_pages[_current_page].visible = false
		_pages[new_page].visible = true
		_pages[new_page].play_current_frame()
		_current_page = new_page
	_check_buttons()


func _to_right() -> void:
	if not _pages[_current_page].next_frame():
		_check_buttons()
		return
	
	var new_page = _current_page + 1
	if new_page < _pages.size():
		_pages[_current_page].visible = false
		_pages[new_page].visible = true
		_pages[new_page].to_first()
		_current_page = new_page
	_check_buttons()


func _check_buttons() -> void:
	var current_page = _pages[_current_page]
	var last_page = _pages[_pages.size() - 1]
	_left_button.disabled = _pages[0].current_frame == 0
	_right_button.disabled = current_page == last_page and last_page.current_frame == current_page.frames - 1
