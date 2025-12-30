extends RigidBody2D

func _ready() -> void:
	# Set up physics properties
	gravity_scale = 1.0
	linear_damp = 0.1
	angular_damp = 0.5
	physics_material_override = PhysicsMaterial.new()
	physics_material_override.friction = 0.8
	physics_material_override.bounce = 0.2