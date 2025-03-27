shader_type canvas_item;

void fragment() {
	vec4 base_color = texture(TEXTURE, UV);
	vec4 glow = vec4(1.0, 1.0, 0.0, 1.0); // Yellow glow
	float alpha = smoothstep(0.1, 0.1, base_color.a); // Glow intensity
	COLOR = mix(base_color, glow, alpha * 0.);
}
