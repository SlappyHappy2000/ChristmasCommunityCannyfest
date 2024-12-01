shader_type canvas_item;

uniform vec4 HighShade : source_color;
uniform vec4 MidShade : source_color;
uniform vec4 LowShade : source_color;
uniform vec4 ExtraShade : source_color;
uniform float alpha = 1.0;

void fragment(){
    vec4 t = texture(TEXTURE, UV);
    vec4 color = floor(t.rgba * 255.0);
    if (color == vec4(255, 255, 255, 255)) {
        COLOR = HighShade;
	} else if (color == vec4(255, 0, 0, 255)) {
        COLOR = MidShade;
	} else if (color == vec4(0, 0, 0, 255)) {
        COLOR = LowShade;
	} else if (color == vec4(0, 0, 255, 255)) {
        COLOR = ExtraShade;
    } else {
        COLOR = t;
    }
	if (COLOR.a != 0.0) {
		COLOR.a = alpha;
	}

}