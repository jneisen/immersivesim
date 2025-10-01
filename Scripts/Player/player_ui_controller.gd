extends Control

var emptyHotbarSlot : Texture2D = preload("res://Icons/blank.png")
var styleBox = preload("res://Misc/text_style_box.tres")
var initialHotbarImageLocation : Vector2
var initialHotbarTextLocation : Vector2
var offset = Vector2(75, 0)
var textSize = Vector2(70, 50)

var hotbarImageArray : Array
var hotbarTextArray : Array

var startOfHotbar = 50
var distanceBetweenHotbarElements = 30

var writtenTextUI : Control

func _ready() -> void:
	get_tree().get_root().size_changed.connect(updateWindow)
	updateWindow()
	# setup written text overlay
	var overlay = preload("res://Scenes/UI/WrittenTextUI.tscn")
	writtenTextUI = overlay.instantiate()
	add_child(writtenTextUI)
	writtenTextUI.hide()
	# add a hotbar image to hold the whole hotbar together
	
	for i in range(10):
		var hotbarImage = TextureRect.new()
		hotbarImage.texture = emptyHotbarSlot
		hotbarImage.position = initialHotbarImageLocation + offset * i
		hotbarImage.scale = Vector2(2, 2)
		
		var hotbarText = RichTextLabel.new()
		hotbarText.position = initialHotbarTextLocation + offset * i
		hotbarText.size = textSize
		hotbarText.bbcode_enabled = true
		hotbarText.text = ""
		
		add_child(hotbarImage)
		add_child(hotbarText)
		
		hotbarImageArray.append(hotbarImage)
		hotbarTextArray.append(hotbarText)

func updateWindow():
	var scaling_amount = get_viewport_rect().size.x / 1300
	scale = Vector2(scaling_amount, scaling_amount)
	var y_pos = get_viewport_rect().size.y - get_viewport_rect().size.y / 10
	initialHotbarImageLocation = Vector2(250, y_pos)
	initialHotbarTextLocation = Vector2(245, y_pos + 65)

func changeHotbarSlot(itemName : String, hotbarSlot : int):
	if(hotbarSlot > 9 || hotbarSlot < 0):
		print("Wrong number for hotbar slot!!!")
		return
	
	hotbarImageArray[hotbarSlot].texture = load("res://Icons/" + itemName + ".png")
	var textToBe = "[center]" + itemName + "[/center]"
	hotbarTextArray[hotbarSlot].text = textToBe

func displayTextbox(m_name : String):
	writtenTextUI.show()
	writtenTextUI.changeText(m_name)

func hideTextbox():
	writtenTextUI.hide()
