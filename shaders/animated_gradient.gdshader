shader_type canvas_item;

const float offset = 1.0;
const float speed = 1.0;


float calc(float val) {
	float v = val + offset + TIME * speed;
	return abs(sin(v));
}

void fragment() {
	vec3 color = vec3(calc(UV.x), 1.0 - calc(UV.y), 1.0);
	COLOR.gbr = color;
}

