shader_type canvas_item;

render_mode unshaded, blend_mix;

uniform vec3 uv1_scale = vec3(1.0, 1.0, 1.0);
uniform vec3 uv1_offset = vec3(0.0, 0.0, 0.0);
uniform float variation = 0.0;
varying float elapsed_time;
void vertex() {
	elapsed_time = TIME;
	UV = UV*uv1_scale.xy+uv1_offset.xy;
}
float rand(vec2 x) {
    return fract(cos(mod(dot(x, vec2(13.9898, 8.141)), 3.14)) * 43758.5453);
}
vec2 rand2(vec2 x) {
    return fract(cos(mod(vec2(dot(x, vec2(13.9898, 8.141)),
						      dot(x, vec2(3.4562, 17.398))), vec2(3.14))) * 43758.5453);
}
vec3 rand3(vec2 x) {
    return fract(cos(mod(vec3(dot(x, vec2(13.9898, 8.141)),
							  dot(x, vec2(3.4562, 17.398)),
                              dot(x, vec2(13.254, 5.867))), vec3(3.14))) * 43758.5453);
}
float param_rnd(float minimum, float maximum, float seed) {
	return minimum+(maximum-minimum)*rand(vec2(seed));
}
vec3 rgb2hsv(vec3 c) {
	vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
	vec4 p = c.g < c.b ? vec4(c.bg, K.wz) : vec4(c.gb, K.xy);
	vec4 q = c.r < p.x ? vec4(p.xyw, c.r) : vec4(c.r, p.yzx);
	float d = q.x - min(q.w, q.y);
	float e = 1.0e-10;
	return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}
vec3 hsv2rgb(vec3 c) {
	vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
	vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
	return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}
// Based on https://www.shadertoy.com/view/ldl3W8
// The MIT License
// Copyright © 2013 Inigo Quilez
vec3 iq_voronoi(vec2 x, vec2 size, vec2 stretch, float randomness, vec2 seed) {
	vec2 n = floor(x);
	vec2 f = fract(x);
	vec2 mg, mr, mc;
	float md = 8.0;
	for (int j=-1; j<=1; j++)
	for (int i=-1; i<=1; i++) {
		vec2 g = vec2(float(i),float(j));
		vec2 o = randomness*rand2(seed + mod(n + g + size, size));
		vec2 c = g + o;
		vec2 r = c - f;
		vec2 rr = r*stretch;
		float d = dot(rr,rr);
		if (d<md) {
			mc = c;
			md = d;
			mr = r;
			mg = g;
		}
	}
	md = 8.0;
	for (int j=-2; j<=2; j++)
	for (int i=-2; i<=2; i++) {
		vec2 g = mg + vec2(float(i),float(j));
		vec2 o = randomness*rand2(seed + mod(n + g + size, size));
		vec2 r = g + o - f;
		vec2 rr = (mr-r)*stretch;
		if (dot(rr,rr)>0.00001)
	   		md = min(md, dot(0.5*(mr+r)*stretch, normalize((r-mr)*stretch)));
	}
	return vec3(md, mc+n);
}
vec4 voronoi(vec2 uv, vec2 size, vec2 stretch, float intensity, float randomness, float seed) {
	uv *= size;
	vec3 v = iq_voronoi(uv, size, stretch, randomness, rand2(vec2(seed, 1.0-seed)));
	return vec4(v.yz, intensity*length((uv-v.yz)*stretch), v.x);
}
float pingpong(float a, float b)
{
  return (b != 0.0) ? abs(fract((a - b) / (b * 2.0)) * b * 2.0 - b) : 0.0;
}
vec2 get_from_tileset(float count, float seed, vec2 uv) {
	return clamp((uv+floor(rand2(vec2(seed))*count))/count, vec2(0.0), vec2(1.0));
}
vec2 custom_uv_transform(vec2 uv, vec2 cst_scale, float rnd_rotate, float rnd_scale, vec2 seed) {
	seed = rand2(seed);
	uv -= vec2(0.5);
	float angle = (seed.x * 2.0 - 1.0) * rnd_rotate;
	float ca = cos(angle);
	float sa = sin(angle);
	uv = vec2(ca*uv.x+sa*uv.y, -sa*uv.x+ca*uv.y);
	uv *= (seed.y-0.5)*2.0*rnd_scale+1.0;
	uv /= cst_scale;
	uv += vec2(0.5);
	return uv;
}
vec3 blend_normal(vec2 uv, vec3 c1, vec3 c2, float opacity) {
	return opacity*c1 + (1.0-opacity)*c2;
}
vec3 blend_dissolve(vec2 uv, vec3 c1, vec3 c2, float opacity) {
	if (rand(uv) < opacity) {
		return c1;
	} else {
		return c2;
	}
}
vec3 blend_multiply(vec2 uv, vec3 c1, vec3 c2, float opacity) {
	return opacity*c1*c2 + (1.0-opacity)*c2;
}
vec3 blend_screen(vec2 uv, vec3 c1, vec3 c2, float opacity) {
	return opacity*(1.0-(1.0-c1)*(1.0-c2)) + (1.0-opacity)*c2;
}
float blend_overlay_f(float c1, float c2) {
	return (c1 < 0.5) ? (2.0*c1*c2) : (1.0-2.0*(1.0-c1)*(1.0-c2));
}
vec3 blend_overlay(vec2 uv, vec3 c1, vec3 c2, float opacity) {
	return opacity*vec3(blend_overlay_f(c1.x, c2.x), blend_overlay_f(c1.y, c2.y), blend_overlay_f(c1.z, c2.z)) + (1.0-opacity)*c2;
}
vec3 blend_hard_light(vec2 uv, vec3 c1, vec3 c2, float opacity) {
	return opacity*0.5*(c1*c2+blend_overlay(uv, c1, c2, 1.0)) + (1.0-opacity)*c2;
}
float blend_soft_light_f(float c1, float c2) {
	return (c2 < 0.5) ? (2.0*c1*c2+c1*c1*(1.0-2.0*c2)) : 2.0*c1*(1.0-c2)+sqrt(c1)*(2.0*c2-1.0);
}
vec3 blend_soft_light(vec2 uv, vec3 c1, vec3 c2, float opacity) {
	return opacity*vec3(blend_soft_light_f(c1.x, c2.x), blend_soft_light_f(c1.y, c2.y), blend_soft_light_f(c1.z, c2.z)) + (1.0-opacity)*c2;
}
float blend_burn_f(float c1, float c2) {
	return (c1==0.0)?c1:max((1.0-((1.0-c2)/c1)),0.0);
}
vec3 blend_burn(vec2 uv, vec3 c1, vec3 c2, float opacity) {
	return opacity*vec3(blend_burn_f(c1.x, c2.x), blend_burn_f(c1.y, c2.y), blend_burn_f(c1.z, c2.z)) + (1.0-opacity)*c2;
}
float blend_dodge_f(float c1, float c2) {
	return (c1==1.0)?c1:min(c2/(1.0-c1),1.0);
}
vec3 blend_dodge(vec2 uv, vec3 c1, vec3 c2, float opacity) {
	return opacity*vec3(blend_dodge_f(c1.x, c2.x), blend_dodge_f(c1.y, c2.y), blend_dodge_f(c1.z, c2.z)) + (1.0-opacity)*c2;
}
vec3 blend_lighten(vec2 uv, vec3 c1, vec3 c2, float opacity) {
	return opacity*max(c1, c2) + (1.0-opacity)*c2;
}
vec3 blend_darken(vec2 uv, vec3 c1, vec3 c2, float opacity) {
	return opacity*min(c1, c2) + (1.0-opacity)*c2;
}
vec3 blend_difference(vec2 uv, vec3 c1, vec3 c2, float opacity) {
	return opacity*clamp(c2-c1, vec3(0.0), vec3(1.0)) + (1.0-opacity)*c2;
}
vec3 blend_additive(vec2 uv, vec3 c1, vec3 c2, float oppacity) {
	return c2 + c1 * oppacity;
}
vec3 blend_addsub(vec2 uv, vec3 c1, vec3 c2, float oppacity) {
	return c2 + (c1 - .5) * 2.0 * oppacity;
}
float blend_linear_light_f(float c1, float c2) {
	return (c1 + 2.0 * c2) - 1.0;
}
vec3 blend_linear_light(vec2 uv, vec3 c1, vec3 c2, float opacity) {
return opacity*vec3(blend_linear_light_f(c1.x, c2.x), blend_linear_light_f(c1.y, c2.y), blend_linear_light_f(c1.z, c2.z)) + (1.0-opacity)*c2;
}
float blend_vivid_light_f(float c1, float c2) {
	return (c1 < 0.5) ? 1.0 - (1.0 - c2) / (2.0 * c1) : c2 / (2.0 * (1.0 - c1));
}
vec3 blend_vivid_light(vec2 uv, vec3 c1, vec3 c2, float opacity) {
	return opacity*vec3(blend_vivid_light_f(c1.x, c2.x), blend_vivid_light_f(c1.y, c2.y), blend_vivid_light_f(c1.z, c2.z)) + (1.0-opacity)*c2;
}
float blend_pin_light_f( float c1, float c2) {
	return (2.0 * c1 - 1.0 > c2) ? 2.0 * c1 - 1.0 : ((c1 < 0.5 * c2) ? 2.0 * c1 : c2);
}
vec3 blend_pin_light(vec2 uv, vec3 c1, vec3 c2, float opacity) {
	return opacity*vec3(blend_pin_light_f(c1.x, c2.x), blend_pin_light_f(c1.y, c2.y), blend_pin_light_f(c1.z, c2.z)) + (1.0-opacity)*c2;
}
float blend_hard_mix_f(float c1, float c2) {
	return floor(c1 + c2);
}
vec3 blend_hard_mix(vec2 uv, vec3 c1, vec3 c2, float opacity) {
		return opacity*vec3(blend_hard_mix_f(c1.x, c2.x), blend_hard_mix_f(c1.y, c2.y), blend_hard_mix_f(c1.z, c2.z)) + (1.0-opacity)*c2;
}
float blend_exclusion_f(float c1, float c2) {
	return c1 + c2 - 2.0 * c1 * c2;
}
vec3 blend_exclusion(vec2 uv, vec3 c1, vec3 c2, float opacity) {
	return opacity*vec3(blend_exclusion_f(c1.x, c2.x), blend_exclusion_f(c1.y, c2.y), blend_exclusion_f(c1.z, c2.z)) + (1.0-opacity)*c2;
}
vec2 transform2_clamp(vec2 uv) {
	return clamp(uv, vec2(0.0), vec2(1.0));
}
vec2 transform2(vec2 uv, vec2 translate, float rotate, vec2 scale) {
 	vec2 rv;
	uv -= translate;
	uv -= vec2(0.5);
	rv.x = cos(rotate)*uv.x + sin(rotate)*uv.y;
	rv.y = -sin(rotate)*uv.x + cos(rotate)*uv.y;
	rv /= scale;
	rv += vec2(0.5);
	return rv;	
}
const float p_o8835_amount1 = 1.000000000;
const vec4 p_o8837_color = vec4(1.000000000, 1.000000000, 1.000000000, 1.000000000);
const vec4 p_o8836_color = vec4(0.238541007, 0.669354022, 0.753906012, 1.000000000);
const float p_o8864_amount1 = 1.000000000;
const float p_o8896_amount1 = 1.000000000;
const float p_o8897_gradient_0_pos = 0.000000000;
const vec4 p_o8897_gradient_0_col = vec4(1.000000000, 1.000000000, 1.000000000, 1.000000000);
const float p_o8897_gradient_1_pos = 0.109091000;
const vec4 p_o8897_gradient_1_col = vec4(0.000000000, 0.000000000, 0.000000000, 1.000000000);
vec4 o8897_gradient_gradient_fct(float x) {
  if (x < p_o8897_gradient_0_pos) {
    return p_o8897_gradient_0_col;
  } else if (x < p_o8897_gradient_1_pos) {
    return mix(p_o8897_gradient_0_col, p_o8897_gradient_1_col, ((x-p_o8897_gradient_0_pos)/(p_o8897_gradient_1_pos-p_o8897_gradient_0_pos)));
  }
  return p_o8897_gradient_1_col;
}
const float p_o8893_default_in1 = 0.000000000;
const float p_o8893_default_in2 = 3.370000000;
const float p_o8891_default_in1 = 0.000000000;
const float p_o8891_default_in2 = 0.000000000;
const float p_o8892_default_in1 = 0.000000000;
const float p_o8892_default_in2 = 0.000000000;
const float seed_o8834 = 0.240757138;
const float p_o8834_scale_x = 12.000000000;
const float p_o8834_scale_y = 12.000000000;
const float p_o8834_stretch_x = 1.000000000;
const float p_o8834_stretch_y = 1.000000000;
const float p_o8834_intensity = 1.000000000;
const float p_o8834_randomness = 1.000000000;
const float p_o8895_default_in1 = 0.000000000;
const float p_o8895_default_in2 = 0.000000000;
const float p_o8894_default_in1 = 0.000000000;
const float p_o8894_default_in2 = 5.000000000;
const float p_o8890_default_in1 = 1.000000000;
const float seed_o8910 = 0.057147089;
const float p_o8910_sx = 5.000000000;
const float p_o8910_sy = 5.000000000;
const float p_o8910_rotate = 0.000000000;
const float p_o8910_scale = 0.000000000;
vec4 o8910_input_in(vec2 uv, float _seed_variation_) {
vec4 o8834_0_xyzw = voronoi((uv), vec2(p_o8834_scale_x, p_o8834_scale_y), vec2(p_o8834_stretch_y, p_o8834_stretch_x), p_o8834_intensity, p_o8834_randomness, (seed_o8834+fract(_seed_variation_)));float o8834_1_1_f = o8834_0_xyzw.w;
return vec4(vec3(o8834_1_1_f), 1.0);
}
const float p_o8838_gradient_0_pos = 0.000000000;
const vec4 p_o8838_gradient_0_col = vec4(0.000000000, 0.000000000, 0.000000000, 1.000000000);
const float p_o8838_gradient_1_pos = 0.777160000;
const vec4 p_o8838_gradient_1_col = vec4(1.000000000, 1.000000000, 1.000000000, 1.000000000);
vec4 o8838_gradient_gradient_fct(float x) {
  if (x < p_o8838_gradient_0_pos) {
    return p_o8838_gradient_0_col;
  } else if (x < p_o8838_gradient_1_pos) {
    return mix(p_o8838_gradient_0_col, p_o8838_gradient_1_col, ((x-p_o8838_gradient_0_pos)/(p_o8838_gradient_1_pos-p_o8838_gradient_0_pos)));
  }
  return p_o8838_gradient_1_col;
}
const float p_o8879_amount1 = 0.450000000;
const float p_o8912_translate_x = 1.000000000;
const float p_o8912_translate_y = 1.000000000;
const float p_o8912_rotate = 0.000000000;
const float p_o8912_scale_x = 1.000000000;
const float p_o8912_scale_y = 1.000000000;
const float p_o8911_default_in2 = 50.000000000;
const float p_o8851_gradient_0_pos = 0.018106000;
const vec4 p_o8851_gradient_0_col = vec4(0.000000000, 0.000000000, 0.000000000, 1.000000000);
const float p_o8851_gradient_1_pos = 0.118894000;
const vec4 p_o8851_gradient_1_col = vec4(1.000000000, 1.000000000, 1.000000000, 1.000000000);
vec4 o8851_gradient_gradient_fct(float x) {
  if (x < p_o8851_gradient_0_pos) {
    return p_o8851_gradient_0_col;
  } else if (x < p_o8851_gradient_1_pos) {
    return mix(p_o8851_gradient_0_col, p_o8851_gradient_1_col, ((x-p_o8851_gradient_0_pos)/(p_o8851_gradient_1_pos-p_o8851_gradient_0_pos)));
  }
  return p_o8851_gradient_1_col;
}
const float seed_o8833 = 0.000000000;
const float p_o8833_scale_x = 30.000000000;
const float p_o8833_scale_y = 30.000000000;
const float p_o8833_stretch_x = 1.000000000;
const float p_o8833_stretch_y = 1.000000000;
const float p_o8833_intensity = 1.000000000;
const float p_o8833_randomness = 1.000000000;
const float p_o8880_color = 0.450000000;
const float p_o8865_gradient_0_pos = 0.055682000;
const vec4 p_o8865_gradient_0_col = vec4(0.000000000, 0.000000000, 0.000000000, 1.000000000);
const float p_o8865_gradient_1_pos = 0.401136000;
const vec4 p_o8865_gradient_1_col = vec4(1.000000000, 1.000000000, 1.000000000, 1.000000000);
vec4 o8865_gradient_gradient_fct(float x) {
  if (x < p_o8865_gradient_0_pos) {
    return p_o8865_gradient_0_col;
  } else if (x < p_o8865_gradient_1_pos) {
    return mix(p_o8865_gradient_0_col, p_o8865_gradient_1_col, ((x-p_o8865_gradient_0_pos)/(p_o8865_gradient_1_pos-p_o8865_gradient_0_pos)));
  }
  return p_o8865_gradient_1_col;
}
const float seed_o8878 = 0.000000000;
const float p_o8878_scale_x = 5.000000000;
const float p_o8878_scale_y = 5.000000000;
const float p_o8878_stretch_x = 1.000000000;
const float p_o8878_stretch_y = 1.000000000;
const float p_o8878_intensity = 1.000000000;
const float p_o8878_randomness = 0.850000000;
void fragment() {
	float _seed_variation_ = variation;
	vec2 uv = fract(UV);
vec4 o8837_0_1_rgba = p_o8837_color;
vec4 o8836_0_1_rgba = p_o8836_color;
vec4 o8834_0_xyzw = voronoi((uv), vec2(p_o8834_scale_x, p_o8834_scale_y), vec2(p_o8834_stretch_y, p_o8834_stretch_x), p_o8834_intensity, p_o8834_randomness, (seed_o8834+fract(_seed_variation_)));vec4 o8834_2_1_fill = round(vec4(fract((o8834_0_xyzw.xy-1.0)/vec2(p_o8834_scale_x, p_o8834_scale_y)), vec2(2.0)/vec2(p_o8834_scale_x, p_o8834_scale_y))*4096.0)/4096.0;
vec2 o8888_0_c = fract(o8834_2_1_fill.xy+0.5*o8834_2_1_fill.zw);float o8888_0_1_f = o8888_0_c.y;
float o8890_0_clamp_false = p_o8890_default_in1+(elapsed_time);
float o8890_0_clamp_true = clamp(o8890_0_clamp_false, 0.0, 1.0);
float o8890_0_2_f = o8890_0_clamp_false;
float o8894_0_clamp_false = o8890_0_2_f/p_o8894_default_in2;
float o8894_0_clamp_true = clamp(o8894_0_clamp_false, 0.0, 1.0);
float o8894_0_2_f = o8894_0_clamp_false;
float o8834_0_2_f = o8834_0_xyzw.z;
vec3 o8910_0_map = vec3(o8834_0_2_f);
float o8910_0_rnd =  float((seed_o8910+fract(_seed_variation_)))+o8910_0_map.z;
vec4 o8910_0_1_rgba = o8910_input_in(get_from_tileset(1.0, o8910_0_rnd, custom_uv_transform(o8910_0_map.xy, vec2(p_o8910_sx, p_o8910_sy), p_o8910_rotate*0.01745329251, p_o8910_scale, vec2(o8910_0_map.z, float((seed_o8910+fract(_seed_variation_)))))), false ? o8910_0_rnd : 0.0);
float o8895_0_clamp_false = o8894_0_2_f+(dot((o8910_0_1_rgba).rgb, vec3(1.0))/3.0);
float o8895_0_clamp_true = clamp(o8895_0_clamp_false, 0.0, 1.0);
float o8895_0_1_f = o8895_0_clamp_false;
float o8892_0_clamp_false = o8888_0_1_f-o8895_0_1_f;
float o8892_0_clamp_true = clamp(o8892_0_clamp_false, 0.0, 1.0);
float o8892_0_1_f = o8892_0_clamp_false;
float o8891_0_clamp_false = fract(o8892_0_1_f);
float o8891_0_clamp_true = clamp(o8891_0_clamp_false, 0.0, 1.0);
float o8891_0_1_f = o8891_0_clamp_false;
float o8893_0_clamp_false = pow(o8891_0_1_f,p_o8893_default_in2);
float o8893_0_clamp_true = clamp(o8893_0_clamp_false, 0.0, 1.0);
float o8893_0_2_f = o8893_0_clamp_false;
vec4 o8897_0_1_rgba = o8897_gradient_gradient_fct(o8893_0_2_f);
float o8834_1_3_f = o8834_0_xyzw.w;
vec4 o8838_0_1_rgba = o8838_gradient_gradient_fct(o8834_1_3_f);
vec4 o8896_0_b = o8897_0_1_rgba;
vec4 o8896_0_l;
float o8896_0_a;

o8896_0_l = vec4(1.0, ((uv)).y, 1.0, 1.0);
o8896_0_a = p_o8896_amount1*(dot((o8838_0_1_rgba).rgb, vec3(1.0))/3.0);
o8896_0_b = vec4(blend_normal((uv), o8896_0_l.rgb, o8896_0_b.rgb, o8896_0_a*o8896_0_l.a), min(1.0, o8896_0_b.a+o8896_0_a*o8896_0_l.a));

vec4 o8896_0_2_rgba = o8896_0_b;
float o8911_0_clamp_false = (elapsed_time)/p_o8911_default_in2;
float o8911_0_clamp_true = clamp(o8911_0_clamp_false, 0.0, 1.0);
float o8911_0_2_f = o8911_0_clamp_false;
vec4 o8833_0_xyzw = voronoi((fract(transform2((uv), vec2(p_o8912_translate_x*(2.0*o8911_0_2_f-1.0), p_o8912_translate_y*(2.0*1.0-1.0)), p_o8912_rotate*0.01745329251*(2.0*1.0-1.0), vec2(p_o8912_scale_x*(2.0*1.0-1.0), p_o8912_scale_y*(2.0*1.0-1.0))))), vec2(p_o8833_scale_x, p_o8833_scale_y), vec2(p_o8833_stretch_y, p_o8833_stretch_x), p_o8833_intensity, p_o8833_randomness, (seed_o8833+fract(_seed_variation_)));float o8833_1_1_f = o8833_0_xyzw.w;
vec4 o8851_0_1_rgba = o8851_gradient_gradient_fct(o8833_1_1_f);
vec4 o8912_0_1_rgba = o8851_0_1_rgba;
float o8880_0_1_f = p_o8880_color;
vec4 o8878_0_xyzw = voronoi((uv), vec2(p_o8878_scale_x, p_o8878_scale_y), vec2(p_o8878_stretch_y, p_o8878_stretch_x), p_o8878_intensity, p_o8878_randomness, (seed_o8878+fract(_seed_variation_)));float o8878_1_1_f = o8878_0_xyzw.w;
vec4 o8865_0_1_rgba = o8865_gradient_gradient_fct(o8878_1_1_f);
vec4 o8879_0_b = o8912_0_1_rgba;
vec4 o8879_0_l;
float o8879_0_a;

o8879_0_l = vec4(vec3(o8880_0_1_f), 1.0);
o8879_0_a = p_o8879_amount1*(dot((o8865_0_1_rgba).rgb, vec3(1.0))/3.0);
o8879_0_b = vec4(blend_additive((uv), o8879_0_l.rgb, o8879_0_b.rgb, o8879_0_a*o8879_0_l.a), min(1.0, o8879_0_b.a+o8879_0_a*o8879_0_l.a));

vec4 o8879_0_1_rgba = o8879_0_b;
vec4 o8864_0_b = o8896_0_2_rgba;
vec4 o8864_0_l;
float o8864_0_a;

o8864_0_l = o8879_0_1_rgba;
o8864_0_a = p_o8864_amount1*1.0;
o8864_0_b = vec4(blend_overlay((uv), o8864_0_l.rgb, o8864_0_b.rgb, o8864_0_a*o8864_0_l.a), min(1.0, o8864_0_b.a+o8864_0_a*o8864_0_l.a));

vec4 o8864_0_2_rgba = o8864_0_b;
vec4 o8835_0_b = o8837_0_1_rgba;
vec4 o8835_0_l;
float o8835_0_a;

o8835_0_l = o8836_0_1_rgba;
o8835_0_a = p_o8835_amount1*(dot((o8864_0_2_rgba).rgb, vec3(1.0))/3.0);
o8835_0_b = vec4(blend_normal((uv), o8835_0_l.rgb, o8835_0_b.rgb, o8835_0_a*o8835_0_l.a), min(1.0, o8835_0_b.a+o8835_0_a*o8835_0_l.a));

vec4 o8835_0_1_rgba = o8835_0_b;

	vec4 color_tex = o8835_0_1_rgba;
	color_tex = mix(pow((color_tex + vec4(0.055)) * (1.0 / (1.0 + 0.055)),vec4(2.4)),color_tex * (1.0 / 12.92),lessThan(color_tex,vec4(0.04045)));
	COLOR = color_tex;

}



