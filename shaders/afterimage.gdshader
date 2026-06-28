// Afterimage ghost shader.
// Discards the sprite's color and renders a flat tint, using the texture's
// alpha as the silhouette shape. `fade` controls overall opacity (1 -> 0).
shader_type canvas_item;

uniform vec4 tint : source_color = vec4(0.3, 0.9, 1.0, 1.0);
uniform float fade : hint_range(0.0, 1.0) = 1.0;

void fragment() {
	float a = texture(TEXTURE, UV).a;
	COLOR = vec4(tint.rgb, a * fade);
}
