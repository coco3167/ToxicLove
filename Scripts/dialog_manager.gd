extends Control

@export_category("Nodes")
@export var name_box : Label;
@export var dialog_box : Label;
@export var visual_left : TextureRect;
@export var visual_right : TextureRect;

@export_category("Dialogs")
@export var dialogs : Array[Dialog];

@export_category("Parameters")
@export var keyboard_typing_duration : float;

var current_dialog_index : int = 0;
var current_dialog : Dialog;

var dialog_tween : Tween;

func _ready() -> void:
	if(dialogs.is_empty()):
		push_error("no dialogs");
		return;
	
	dialog_tween = get_tree().create_tween();
	current_dialog = dialogs[current_dialog_index];
	update_dialog();

func _input(event: InputEvent) -> void:
	if(event.is_action_released("ui_accept")):
		next_dialog();

func next_dialog():
	if(dialog_tween.is_running()):
		dialog_tween.kill();
		dialog_box.visible_ratio = 1;
		$DialogContainer/MainDialog/TextureRect.visible = true;
		return;
	
	if(current_dialog_index >= dialogs.size()-1):
		print("no more dialogs");
		return;
	
	current_dialog_index+=1;
	current_dialog = dialogs[current_dialog_index];
	update_dialog();

func update_dialog():
	$DialogContainer/MainDialog/TextureRect.visible = false;
	name_box.text = current_dialog.name;
	dialog_box.text = current_dialog.text;
	visual_left.texture = current_dialog.visual_left;
	visual_right.texture = current_dialog.visual_right;
	
	if(!dialog_tween.is_valid()):
		dialog_tween = get_tree().create_tween();
	dialog_box.visible_ratio = 0;
	dialog_tween.tween_property(dialog_box, "visible_ratio", 1, keyboard_typing_duration);
	dialog_tween.tween_property($DialogContainer/MainDialog/TextureRect, "visible", true, 0);
