shader_type sky;

uniform vec3 sky_color : source_color;
uniform sampler2D cloudy;
uniform vec2 wind = vec2(2.3, 3.3);
void sky() {
	vec2 direction = (TIME * wind) * 0.003;
	vec3 final_color = mix(sky_color, texture(cloudy, SKY_COORDS + direction).rgb, 0.7);
	
	COLOR = final_color;
}
