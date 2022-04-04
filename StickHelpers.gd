static func transfer_stick_properties(from_stick, to_stick):
	to_stick.strength = from_stick.strength

const textures = {
	"wood": {
		"default": [
			preload("res://sprites/materials/sticks/1.png"),
			preload("res://sprites/materials/sticks/2.png"),
			preload("res://sprites/materials/sticks/3.png"),
			preload("res://sprites/materials/sticks/4.png"),
			preload("res://sprites/materials/sticks/5.png")
		],
		"braced": [
			preload("res://sprites/materials/sticks/1-braced.png"),
			preload("res://sprites/materials/sticks/2-braced.png"),
			preload("res://sprites/materials/sticks/3-braced.png"),
			preload("res://sprites/materials/sticks/4-braced.png"),
			preload("res://sprites/materials/sticks/5-braced.png")
		],
		"alert": [
			preload("res://sprites/materials/sticks/1-alert.png"),
			preload("res://sprites/materials/sticks/2-alert.png"),
			preload("res://sprites/materials/sticks/3-alert.png"),
			preload("res://sprites/materials/sticks/4-alert.png"),
			preload("res://sprites/materials/sticks/5-alert.png")
		]
	} ,
	"metal": {
		"default": [
			preload("res://sprites/materials/metal/1.png"),
			preload("res://sprites/materials/metal/2.png"),
			preload("res://sprites/materials/metal/3.png"),
			preload("res://sprites/materials/metal/4.png"),
			preload("res://sprites/materials/metal/5.png")
		],
		"braced": [
			preload("res://sprites/materials/metal/1-braced.png"),
			preload("res://sprites/materials/metal/2-braced.png"),
			preload("res://sprites/materials/metal/3-braced.png"),
			preload("res://sprites/materials/metal/4-braced.png"),
			preload("res://sprites/materials/metal/5-braced.png")
		],
		"alert": [
			preload("res://sprites/materials/metal/1-alert.png"),
			preload("res://sprites/materials/metal/2-alert.png"),
			preload("res://sprites/materials/metal/3-alert.png"),
			preload("res://sprites/materials/metal/4-alert.png"),
			preload("res://sprites/materials/metal/5-alert.png")
		]
	}
}
