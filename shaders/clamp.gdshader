shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_nearest;

group_uniforms Colour;
uniform vec3 colour : source_color;
group_uniforms;

vec3 hsv_to_rgb(vec3 hsv){
	if(hsv.y == 0.0){
		return vec3(hsv.z,hsv.z, hsv.z);
	}
	
	float h = hsv.x * 6.0;
	float c = hsv.z * hsv.y;
	float x = c * (1.0 - abs(mod(h, 2) - 1.0));
	float m = hsv.z - c;
	
	vec3 rgb;
	
	if(h < 1.0){
		rgb = vec3(c, x, 0);
	} else if(h < 2.0){
		rgb = vec3(x, c, 0);
	} else if(h < 3.0){
		rgb = vec3(0, c, x);
	} else if(h < 4.0){
		rgb = vec3(0, x, c);
	} else if(h < 5.0){
		rgb = vec3(x, 0, c);
	} else {
		rgb = vec3(c, 0, x);
	}
	
	rgb = vec3(rgb.r + m, rgb.g + m, rgb.b + m);
	
	return rgb;
}

vec3 rgb_to_hsv(vec3 rgb){
	float c_max = max(rgb.x, max(rgb.y, rgb.z));
	float c_min = min(rgb.x, min(rgb.y, rgb.z));
	float delta = c_max - c_min;
	
	float value = c_max;
	
	float sat = 0.0;
	
	if (value != 0.0){
		sat = delta/c_max;
	}
	
	float hue;
	
	if(delta == 0.0){
		hue = 0.0;
	} else if (c_max == rgb.r){
		hue = mod((rgb.g - rgb.b) / delta, 6);
	} else if (c_max == rgb.g){
		hue = ((rgb.b - rgb.r) / delta) + 2.0;
	} else{
		hue = ((rgb.r - rgb.g) / delta) + 4.0;
	}
	
	hue /= 6.0;
	
	if(hue < 0.0){
		hue += 1.0;
	}
	
	return vec3(hue, sat, value);
}

void fragment() {
	vec4 original_sc = texture(SCREEN_TEXTURE, SCREEN_UV);
	
	vec3 hsv_sc = rgb_to_hsv(original_sc.rgb);
	vec3 hsv_in = rgb_to_hsv(colour);
	
	//take hue and saturation from the input and value from the screen
	vec3 hsv_out = vec3(hsv_in.x, hsv_in.y, hsv_sc.z);
	
	vec3 rgb_out = hsv_to_rgb(hsv_out);
	
	COLOR = vec4(rgb_out, 1);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
