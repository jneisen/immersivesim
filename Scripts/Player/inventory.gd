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

func _ready():
	hotbar.resize(10)

func addItem(m_name : String):
	var type = get_type(m_name)
	var newItem
	
	if(type == "MeleeWeapon"):
		newItem = MeleeWeapon.new(m_name, type)
	
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
			return
		currentEquipped = number
		playerHand.holdingItem(hotbar[number])
	
func getHotbarItem(number : int):
	return hotbar[number]

func get_type(m_item_name : String) -> String:
	return "MeleeWeapon"
