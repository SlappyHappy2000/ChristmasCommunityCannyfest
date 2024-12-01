/*
	CRT shader for Godot Engine by Yui Kinomoto @arlez80
*/
shader_type canvas_item;

// 画面
uniform sampler2D screen_texture : hint_screen_texture;

// ブラウン管のガラスの曲がり具合（フラットなやつは0.0でいいかな）
uniform float crt_curve : hint_range( 0.0, 1.0 ) = 0.02;
// 走査線の濃さ
uniform float crt_scan_line_color : hint_range( -1.0, 1.0 ) = 0.0;
// 光量
uniform float aperture_grille_rate : hint_range( 0.0, 1.0 ) = 0.4;
// RFスイッチ的ブラー
uniform float rf_switch_esque_blur : hint_range( 0.0, 1.0 ) = 1.0;
// 白色ノイズ
uniform float white_noise_rate : hint_range( 0.0, 1.0 ) = 0.0;

float random( vec2 pos )
{
	return fract(sin(dot(pos, vec2(12.9898,78.233))) * 43758.5453);
}

void fragment( )
{
	vec3 grille_rate_vec = vec3(aperture_grille_rate, aperture_grille_rate, aperture_grille_rate);
	// ガラスの曲がり具合
	vec2 crt_curve_shift = ( vec2( 1.0, 1.0 ) - sin( UV.yx * PI ) ) * crt_curve;
	vec2 crt_curve_scale = vec2( 1.0, 1.0 ) + crt_curve_shift * 2.0;
	vec2 texture_fixed_uv = UV * crt_curve_scale - crt_curve_shift;
	vec2 fixed_uv = SCREEN_UV * crt_curve_scale - crt_curve_shift;
	// 範囲外を消す
	float enable_color = float( 0.0 <= texture_fixed_uv.x && texture_fixed_uv.x <= 1.0 && 0.0 <= texture_fixed_uv.y && texture_fixed_uv.y <= 1.0 );

	// ガラスの曲がり具合から元色を取得 + RFスイッチ的ブラー
	COLOR.rgb = (
		(
			texture( screen_texture, fixed_uv ).rgb
		*	( 1.0 - rf_switch_esque_blur * 0.5 )
		)
	+	(
			(
				texture( screen_texture, fixed_uv + vec2( -SCREEN_PIXEL_SIZE.x * 3.1, 0.0 ) ).rgb
			+	texture( screen_texture, fixed_uv + vec2( SCREEN_PIXEL_SIZE.x * 3.1, 0.0 ) ).rgb
			)
			*	( rf_switch_esque_blur * 0.25 )	// （RFノイズ）0.5 * （テクスチャから読んだ2箇所を半分にしたい）0.5
		)
	) * enable_color;
	COLOR.a = 1.0;

	// ------------------------------------------------
	// 以下はアパーチャグリル上の1ピクセルごとの処理
	vec2 aperture_grille_pixel = vec2( floor( ( fixed_uv.x / SCREEN_PIXEL_SIZE.x ) / 3.0 ) * 3.0, fixed_uv.y );

	// 白色ノイズ
	float white_noise = random( aperture_grille_pixel + vec2( sin( TIME * 0.543254 ), cos( TIME * 0.254323563 ) ) );
	COLOR.rgb = mix(
		COLOR.rgb
	,	vec3( white_noise, white_noise, white_noise )
	,	white_noise_rate * enable_color
	);

// アパーチャグリル再現
    float aperture_grille_point = mod( ( ( SCREEN_UV.x * crt_curve_scale.x ) - crt_curve_shift.x ) / SCREEN_PIXEL_SIZE.x, 3.0 );
    float aperture_grille_r_rate = clamp( 1.0 - aperture_grille_point, 0.0, 1.0 ) + clamp( aperture_grille_point - 2.0, 0.0, 1.0 );
    float aperture_grille_g_rate = clamp( 1.0 - abs( 1.0 - aperture_grille_point ), 0.0, 1.0 );
    float aperture_grille_b_rate = 1.0 - aperture_grille_r_rate - aperture_grille_g_rate;
    vec3 ap_norm = vec3(
        aperture_grille_r_rate,
        aperture_grille_g_rate,
        aperture_grille_b_rate
    );
    ap_norm = normalize(clamp(ap_norm, grille_rate_vec, vec3(1.0, 1.0, 1.0)));
    COLOR = COLOR * vec4(ap_norm, 1.0);

	// 走査線
	COLOR = mix(
		COLOR
	,	vec4( 0.0, 0.0, 0.0, 1.0 )
	,	float( int( fixed_uv.y / SCREEN_PIXEL_SIZE.y ) % 2 == 0 ) * crt_scan_line_color
	);
}
