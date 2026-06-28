// Flash shader for the live player sprite.
// Mixes the original color toward `flash_color` by `flash_amount`, keeping the
// original alpha so the sprite's shape is unchanged. At flash_amount = 0 it
// renders the sprite normally, so it is safe to leave attached between dodges.
shader_type canvas_item;

uniform vec4 flash_color : source_color = vec4(0.3, 0.9, 1.0, 1.0);
uniform float flash_amount : hint_range(0.0, 1.0) = 0.0;

void fragment() {
	vec4 tex = texture(TEXTURE, UV);
	COLOR = vec4(mix(tex.rgb, flash_color.rgb, flash_amount), tex.a);
}
