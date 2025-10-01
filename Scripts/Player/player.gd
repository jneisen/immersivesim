extends Node3D

var health = 100

func add_health(val):
	health += val
	if(health > 100):
		health = 100
	if(health < 1):
		died()

func died():
	pass
