extends Control

@export var hotbarImage1 : TextureRect
@export var hotbarText1 : RichTextLabel

var hotbarImageArray : Array
var hotbarTextArray : Array

var startOfHotbar = 50
var distanceBetweenHotbarElements = 30

func _ready() -> void:
	for i in range(10):
		hotbarImageArray.append(hotbarImage1)
		hotbarTextArray.append(hotbarText1)
		hotbarImageArray[i].texture = load("res://Icons/blank.png")
		hotbarTextArray[i].text = ""
	

func changeHotbarSlot(itemName : String, hotbarSlot : int):
	if(hotbarSlot > 9 || hotbarSlot < 0):
		print("Wrong number for hotbar slot!!!")
		return
	
	hotbarImageArray[hotbarSlot].texture = load("res://Icons/" + itemName + ".png")
	hotbarTextArray[hotbarSlot].text = itemName	
