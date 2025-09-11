extends Node3D

@export var playerUI : Control
@export var playerHand : Node3D

# Description of item types:
# consumable describes objects that immediately disappear with a player effect
# melee weapon has fairly obvious implementation
# ranged weapon too
# armor is an equipable item
# grenade is a ranged weapon but it disappears if it runs out of ammo
# tool describes lockpick / multitool where you point it and it takes time to use (but still consumable)
var typesPossible = ["Consumable", "MeleeWeapon", "RangedWeapon", "Armor", "Grenade", "Tool"]

var hotbar : Array
var currentEquipped = -1
var inventory : Array

func addItem(name : String):
	var type = get_type(name)
	var newItem
	
	if(type == "MeleeWeapon"):
		newItem = MeleeWeapon.new(name, type)
	
	inventory.append(newItem)
	if(hotbar.size() <= 10):
		hotbar.append(newItem)
		playerUI.changeHotbarSlot(newItem.item_name, hotbar.size())

func hotbarInteraction(number : int):
	number -= 1
	if(number == currentEquipped):
		currentEquipped = -1
		playerHand.notHoldingItem()
	else:
		currentEquipped = number
		playerHand.holdingItem(hotbar[number])
	
func getHotbarItem(number : int):
	return hotbar[number]

func get_type(item_name : String) -> String:
	return "MeleeWeapon"
