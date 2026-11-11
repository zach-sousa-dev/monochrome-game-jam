//  -- 2d shader
shader_type canvas_item;

// -- how full it is: 1.0 = full,  0.0 = empty
uniform float progress : hint_range(0.0, 1.0) = 1.0;
// -- true = fills from the bottom up
uniform bool fill_from_bottom = true;
// -- how burry the line is between 
uniform float edge_softness : hint_range(0.0, 0.1) = 0.01;
// -- how dark the empty part is
uniform float empty_brightness : hint_range(0.0, 2.0) = 0.6;

// -- runs once for every pixel of the image
void fragment() {
	
	// -- the pixels normal color from the image
	vec4 tex = texture(TEXTURE, UV);
	
	// -- how high up this pixel is (0.0 = bottom, 1.0 = top
	float pos = fill_from_bottom ? 1.0 - UV.y : UV.y;
	
	// is this pixel in the full? (1.0 = full, 0.0 = empty
	float filled;
	if (progress >= 1.0) {
		filled = 1.0;
	} else if (progress <= 0.0) {
		filled = 0.0;
	} else {
		filled = 1.0 - smoothstep(progress - edge_softness, progress + edge_softness, pos);
	}
	
	// -- the darker colour used for the empty part
	vec3 empty_col = tex.rgb * empty_brightness;
	
	// -- blender empty and nomarl colour 
	COLOR = vec4(mix(empty_col, tex.rgb, filled), tex.a);
}