class_name MeleeWeapon 

extends Item

var damage : float
	
func _init(m_item_name : String, m_type : String):
	item_name = m_item_name
	model = super.get_model(m_item_name)
	type = m_type
	description = super.get_description(m_item_name)
	damage = get_damage(m_item_name)

func get_damage(m_item_name : String) -> float:
	return 5.0
