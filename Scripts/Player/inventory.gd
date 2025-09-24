extends Node3D

@export var playerUI : Control
@export var playerHand : Node3D

var hotbar : Array
var currentEquipped = -1
var inventory : Array
var itemArray : Array

func _ready():
	hotbar.resize(10)
	ItemExtractor.init()
	itemArray = ItemExtractor.getItemArray()

func addItem(m_name : String):
	var newItem
	for i in range(itemArray.size()):
		if(itemArray[i].item_name == m_name):
			newItem = itemArray[i]
	if(newItem == null):
		print("Error, item not found")
		return
	inventory.append(newItem)
	# add it to the first empty hotbar slot
	for i in range(hotbar.size()):
		if(!hotbar[i]):
			hotbar[i] = newItem
			playerUI.changeHotbarSlot(newItem.item_name, i)
			break;

func hotbarInteraction(number : int):
	number -= 1
	if(number == currentEquipped):
		currentEquipped = -1
		playerHand.notHoldingItem()
	else:
		if(!hotbar[number]):
			currentEquipped = -1
			playerHand.notHoldingItem()
			return
		currentEquipped = number
		playerHand.holdingItem(hotbar[number])
	
func getHotbarItem(number : int):
	return hotbar[number]

func get_type(m_item_name : String) -> String:
	return "MeleeWeapon"
