extends Projectile

@export var velocity: Vector3 = Vector3.FORWARD

func _init(): 
	speed = velocity.length()
	direction = velocity / speed

func destroy(): 
	call_deferred("remove_child", hitbox)
	call_deferred("remove_child", hurtbox)
	queue_free()


func _on_hurt(_hitbox: HitBox):
	%StatComponent.take_damage(_hitbox)
