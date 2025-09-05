extends Node3D

@export var playerUI : Control

class Item:
	var name : String
	var type : String
	var description : String

class MeleeWeapon extends Item:
	var damage : float
	
	func _init(m_name : String, m_type : String, m_description : String, m_damage : float):
		name = m_name
		type = m_type
		description = m_description
		damage = m_damage
# Description of item types:
# consumable describes objects that immediately disappear with a player effect
# melee weapon has fairly obvious implementation
# ranged weapon too
# armor is an equipable item
# grenade is a ranged weapon but it disappears if it runs out of ammo
# tool describes lockpick / multitool where you point it and it takes time to use (but still consumable)
var typesPossible = ["Consumable", "MeleeWeapon", "RangedWeapon", "Armor", "Grenade", "Tool"]

var hotbar : Array
var inventory : Array

func addItem(name : String):
	var type = get_type(name)
	var newItem
	if(type == "MeleeWeapon"):
		newItem = MeleeWeapon.new(name, type, get_description(name), get_damage(name))
	inventory.append(newItem)
	if(hotbar.size() <= 10):
		hotbar.append(newItem)
		playerUI.changeHotbarSlot(newItem.name, hotbar.size())

func getHotbarItem(number : int):
	return hotbar[number]

func get_type(item_name : String) -> String:
	return "MeleeWeapon"
func get_description(item_name : String) -> String:
	return "Sample description for an item (should be from xml file)"
func get_damage(item_name : String) -> float:
	return 5.0
