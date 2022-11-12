extends Node2D
class_name Weapon

export (PackedScene) var AmmoType
export (float, 0.1, 2) var AmmoScale = 1.0
export (float) var AmmoSpeed = 100.0
export (int, 1, 50) var RateOfFire = 10 # per seconds
