class_name RangedWeapon

extends Item

# ranged weapon: projectile, projectile speed, damage, firing speed, reload_speed, clip_size, [internal] ammo_in_clip, number_of_clips
var projectile : PackedScene
var projectile_speed : float
var damage : float
var firing_type : String # bow / gun
var firing_speed : float
var reload_speed : float
var clip_size : int

var ammo_in_clip : int = 0
var number_of_clips : int = 0
