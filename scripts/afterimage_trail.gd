class_name AfterimageTrail extends Node2D

## Reusable afterimage / dash-trail component.
##
## While active it stamps fading tinted silhouettes of [member source_sprite]'s
## current frame into the world, and (optionally) flashes the live sprite toward
## [member ghost_color] at the start. Drive it with [method start] / [method stop]
## (e.g. from a dodge state). Ghosts are independent nodes that finish fading on
## their own, so the trail tails off smoothly after [method stop].

const AFTERIMAGE_SHADER: Shader = preload("res://shaders/afterimage.gdshader")
const FLASH_SHADER: Shader = preload("res://shaders/flash.gdshader")

## The sprite to clone for ghosts and to flash.
@export var source_sprite: AnimatedSprite2D
## Silhouette + flash color.
@export var ghost_color: Color = Color(0.3, 0.9, 1.0)
## Seconds between spawned ghosts while active.
@export var spawn_interval: float = 0.035
## Seconds for a single ghost to fully fade out.
@export var ghost_lifetime: float = 0.3
## Initial opacity of a freshly spawned ghost.
@export_range(0.0, 1.0) var start_alpha: float = 0.6
## Extra z_index offset applied to ghosts, relative to the source sprite.
## Ghosts render behind the player via tree order (see _spawn_ghost), so this is
## usually left at 0.
@export var z_offset: int = 0
## Whether to flash the live sprite at the start of the trail.
@export var flash_enabled: bool = true
## Seconds for the player flash to fade back to normal.
@export var flash_duration: float = 0.15
## Peak strength of the player flash (0 = none, 1 = solid color).
@export_range(0.0, 1.0) var flash_strength: float = 0.8

var _active: bool = false
var _accumulator: float = 0.0
var _ghost_material: ShaderMaterial
var _flash_material: ShaderMaterial

func _ready() -> void:
	# Template material; every ghost gets its own duplicate so they fade
	# independently.
	_ghost_material = ShaderMaterial.new()
	_ghost_material.shader = AFTERIMAGE_SHADER
	_ghost_material.set_shader_parameter("tint", ghost_color)

	# The flash material sits on the live sprite at flash_amount = 0 (no visible
	# effect) until start() drives it.
	if flash_enabled and source_sprite:
		_flash_material = ShaderMaterial.new()
		_flash_material.shader = FLASH_SHADER
		_flash_material.set_shader_parameter("flash_color", ghost_color)
		_flash_material.set_shader_parameter("flash_amount", 0.0)
		source_sprite.material = _flash_material

## Begin emitting the trail (and flash the live sprite).
func start() -> void:
	if not source_sprite:
		push_warning("AfterimageTrail: source_sprite is not set.")
		return
	_active = true
	_accumulator = 0.0
	_spawn_ghost()
	if flash_enabled and _flash_material:
		_flash_material.set_shader_parameter("flash_amount", flash_strength)
		var tween := create_tween()
		tween.tween_property(_flash_material, "shader_parameter/flash_amount", 0.0, flash_duration)

## Stop emitting new ghosts. Existing ghosts keep fading to completion.
func stop() -> void:
	_active = false

func _process(delta: float) -> void:
	if not _active:
		return
	_accumulator += delta
	while _accumulator >= spawn_interval:
		_accumulator -= spawn_interval
		_spawn_ghost()

func _spawn_ghost() -> void:
	if not source_sprite or source_sprite.sprite_frames == null:
		return
	var frames := source_sprite.sprite_frames
	var anim := source_sprite.animation
	if not frames.has_animation(anim):
		return

	var ghost := Sprite2D.new()
	ghost.texture = frames.get_frame_texture(anim, source_sprite.frame)
	ghost.global_position = source_sprite.global_position
	ghost.global_rotation = source_sprite.global_rotation
	ghost.global_scale = source_sprite.global_scale
	ghost.flip_h = source_sprite.flip_h
	ghost.flip_v = source_sprite.flip_v
	ghost.offset = source_sprite.offset
	ghost.centered = source_sprite.centered
	ghost.z_index = source_sprite.z_index + z_offset
	ghost.texture_filter = source_sprite.texture_filter

	var mat: ShaderMaterial = _ghost_material.duplicate()
	mat.set_shader_parameter("tint", ghost_color)
	mat.set_shader_parameter("fade", start_alpha)
	ghost.material = mat

	# Parent to the player's parent (not the moving player) so the ghost stays
	# put, then slot it just before the player in the tree. The player and the
	# background often share a z_index, so tree order — not z_index — is what
	# keeps the ghost behind the player yet above the background.
	var player_node: Node = source_sprite.get_parent()
	var world: Node = player_node.get_parent() if player_node else null
	if world == null:
		world = get_tree().current_scene
	world.add_child(ghost)
	if player_node and player_node.get_parent() == world:
		world.move_child(ghost, player_node.get_index())

	var tween := ghost.create_tween()
	tween.tween_property(mat, "shader_parameter/fade", 0.0, ghost_lifetime)
	tween.tween_callback(ghost.queue_free)
