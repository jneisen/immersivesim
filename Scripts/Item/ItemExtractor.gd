class_name ItemExtractor

static var itemArray : Array
#var typesPossible = ["Consumable", "MeleeWeapon", "RangedWeapon", "Armor", "Grenade", "Tool"]
# Description of item types:
# consumable: 
# melee weapon has fairly obvious implementation
# ranged weapon too
# armor is an equipable item
# grenade is a ranged weapon but it disappears if it runs out of ammo
# tool describes lockpick / multitool where you point it and it takes time to use (but still consumable)
static func init() -> void:
	var parser = XMLParser.new()
	parser.open("res://Data/item_data.xml")
	var node_name : String
	var currentItem : Item
	while(parser.read() != ERR_FILE_EOF):
		if(parser.get_node_type() == XMLParser.NODE_ELEMENT):
			node_name = parser.get_node_name()
		elif(parser.get_node_type() == XMLParser.NODE_TEXT):
			var data = parser.get_node_data()
			match node_name:
				"type":
					currentItem = makeItem(data)
					currentItem.type = data
				"name":
					currentItem.setName(data)
				"description":
					currentItem.description = data
				"damage":
					currentItem.damage = data
				"swing_speed":
					currentItem.swing_speed = data
				"range":
					currentItem.range = data
		elif(parser.get_node_type() == XMLParser.NODE_ELEMENT_END):
			node_name = ""
			if(parser.get_node_name() == "item"):
				itemArray.append(currentItem)

static func makeItem(type : String) -> Item:
	match type:
		"Melee Weapon":
			return MeleeWeapon.new()
		_:
			return Item.new()

static func getItemArray():
	return itemArray
