class_name ItemExtractor

static var itemArray : Array
# Description of item types:
# melee weapon: damage, swing_speed, range
# ranged weapon: projectile, projectile speed, damage, firing speed, reload_speed, clip_size, [internal] ammo_in_clip, number_of_clips
# armor [will only resist physical damage]: resistance, max_durability, [internal] durability
# consumable: variety (food/drink) [for anim/sound effects], health_added, [internal] amount
# grenade: projectile, [internal] amount
# tool: variety (lockpick / multitool), [internal] amount
static func init() -> void:
	var parser = XMLParser.new()
	parser.open("res://Data/item_data.xml")
	var node_name : String
	var item_type : String
	var currentItem : Item
	while(parser.read() != ERR_FILE_EOF):
		if(parser.get_node_type() == XMLParser.NODE_ELEMENT):
			node_name = parser.get_node_name()
		elif(parser.get_node_type() == XMLParser.NODE_TEXT):
			var data = parser.get_node_data()
			if node_name == "type":
					item_type = data
					currentItem = makeItem(data)
					currentItem.type = data
			if node_name == "name":
					currentItem.setName(data)
			elif node_name == "description":
				currentItem.description = data
			elif(item_type == "Melee Weapon"):
				match node_name:
					"damage":
						currentItem.damage = data
					"swing_speed":
						currentItem.swing_speed = data
					"range":
						currentItem.range = data
			elif(item_type == "Consumable"):
				match node_name:
					"variety":
						currentItem.variety = data
					"health_amount":
						currentItem.health_amount = data
			elif(item_type == "Ranged Weapon"):
				match node_name:
					"projectile":
						currentItem.projectile = getProjectile(data)
					"projectile_speed":
						currentItem.projectile_speed = data
					"damage":
						currentItem.damage = data
					"firing_type":
						currentItem.firing_type = data
					"firing_speed":
						currentItem.firing_speed = data
					"reload_speed":
						currentItem.reload_speed = data
					"clip_size":
						currentItem.clip_size = data
			elif(item_type == "Grenade"):
				match node_name:
					"projectile":
						currentItem.projectile = getProjectile(data)
			elif(item_type == "Tool"):
				match node_name:
					"variety":
						currentItem.variety = data
			elif(item_type == "Armor"):
				match node_name:
					"resistance":
						currentItem.resistance = data
					"max_durability":
						currentItem.max_durability = data
		elif(parser.get_node_type() == XMLParser.NODE_ELEMENT_END):
			node_name = ""
			if(parser.get_node_name() == "item"):
				itemArray.append(currentItem)

static func getProjectile(projectile : String):
	var path = "res://Prefabs/Projectiles/" + projectile + ".tscn"
	return load(path)

static func makeItem(type : String) -> Item:
	match type:
		"Melee Weapon":
			return MeleeWeapon.new()
		"Ranged Weapon":
			return RangedWeapon.new()
		"Armor":
			return Armor.new()
		"Consumable":
			return Consumable.new()
		"Grenade":
			return Grenade.new()
		"Tool":
			return Tool.new()
		_:
			return Item.new()

static func getItemArray():
	return itemArray
