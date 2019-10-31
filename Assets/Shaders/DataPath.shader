// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Shadertoy/DataPath" {
	Properties{
		iMouse("Mouse Pos", Vector) = (100, 100, 0, 0)
		iChannel0("iChannel0", 2D) = "white" {}
		iChannelResolution0("iChannelResolution0", Vector) = (100, 100, 0, 0)
	}

		CGINCLUDE
#include "UnityCG.cginc"   
#pragma target 3.0      

#define vec2 float2
#define vec3 float3
#define vec4 float4
#define mat2 float2x2
#define iTime _Time.y
#define mod fmod
#define mix lerp
#define atan atan2
#define fract frac 
#define texture2D tex2D
			// 屏幕的尺寸
#define iResolution _ScreenParams
// 屏幕中的坐标，以pixel为单位
#define gl_FragCoord ((_iParam.scrPos.xy/_iParam.scrPos.w)*_ScreenParams.xy) 

#define PI2 6.28318530718
#define pi 3.14159265358979
#define halfpi (pi * 0.5)
#define oneoverpi (1.0 / pi)

fixed4 iMouse;
		sampler2D iChannel0;
		fixed4 iChannelResolution0;

		struct v2f {
			float4 pos : SV_POSITION;
			float4 scrPos : TEXCOORD0;
		};

		v2f vert(appdata_base v) {
			v2f o;
			o.pos = UnityObjectToClipPos(v.vertex);
			o.scrPos = ComputeScreenPos(o.pos);
			return o;
		}

		vec4 main(vec2 fragCoord);

		fixed4 frag(v2f _iParam) : COLOR0{
			vec2 fragCoord = gl_FragCoord;
			return main(gl_FragCoord);
		}

			float random(in float x) {
			return fract(sin(x)*1e4);
		}

		float random(in vec2 st) {
			return fract(sin(dot(st.xy, vec2(12.9898, 78.233)))* 43758.5453123);
		}

		float pattern(vec2 st, vec2 v, float t) {
			vec2 p = floor(st + v);
			return step(t, random(100. + p * .000001) + random(p.x)*0.5);
		}

			vec4 main(vec2 fragCoord) {

				vec2 st = fragCoord.xy / iResolution.xy;
				st.x *= iResolution.x / iResolution.y;

				vec2 grid = vec2(100.0, 50.0);
				st *= grid;

				vec2 ipos = floor(st);  // integer
				vec2 fpos = fract(st);  // fraction

				vec2 vel = iTime*2.0*max(grid.x, grid.y); // time
				vel = vel * vec2(-1.0, 0.0) * random(1.0 + ipos.y); // direction

				// Assign a random value base on the integer coord
				vec2 offset = vec2(0.1, 0.0);

				vec3 color = vec3(0.0,0.0,0.0);
				color.r = pattern(st + offset, vel, 0.5 );
				color.g = pattern(st, vel, 0.5 );
				color.b = pattern(st - offset, vel, 0.5);

				// Margins
				color *= step(0.2, fpos.y);

			vec4 fragColor = vec4(color, 1.0);

			return fragColor;
		}

		ENDCG

			SubShader{
				Pass {
					CGPROGRAM

					#pragma vertex vert    
					#pragma fragment frag    
					#pragma fragmentoption ARB_precision_hint_fastest     

					ENDCG
				}
		}
			FallBack Off
}
