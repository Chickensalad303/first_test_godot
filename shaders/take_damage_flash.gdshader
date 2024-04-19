shader_type canvas_item;

uniform bool is_active = false;
void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec4 og_color = texture(TEXTURE, UV);
	vec4 white_color = vec4(1.0, 1.0 - og_color.g, 1.0 - og_color.b, og_color.a);
	if (is_active == false) {
		white_color = og_color;
	}
	COLOR = white_color;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
