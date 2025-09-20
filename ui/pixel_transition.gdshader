shader_type canvas_item;

uniform float progress : hint_range(0, 1);
uniform float pixels : hint_range(10, 1000);
uniform vec4 color : source_color = vec4(0.0, 0.0, 0.0, 1.0);

void fragment() {
    float xFraction = fract(UV.x * pixels);
    float yFraction = fract(UV.y * pixels);

    float xDistance = abs(xFraction - 0.5);
    float yDistance = abs(yFraction - 0.5);

    if (xDistance + yDistance + UV.x + UV.y < progress * 4.0) {
        COLOR = color;
    } else {
        COLOR = vec4(0.0, 0.0, 0.0, 0.0);
    }
}