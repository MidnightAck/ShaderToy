// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Shadertoy/PhongIllumination" {
	Properties{
		para("Circle",Vector) = (10,10,3,0)
		k_a("k_a",color) = (0.4,0.5,0.6,1.0)
		k_s("k_s",color) = (0.7,0.8,0.9,1.0)
		k_d("k_d",color) = (0.7,0.2,0.4,1.0)
		aLight("aLight",color) = (0.7,0.2,0.4,1.0)
		//iMouse("Mouse Pos", Vector) = (100, 100, 0, 0)
		//iChannel0("iChannel0", 2D) = "white" {}
		//iChannelResolution0("iChannelResolution0", Vector) = (100, 100, 0, 0)
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
#define MAX_STEP 100
#define MAX_DIST 100.0
#define EPSLION 0.001
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

			//////////////////////////////////////
		float4 para;
		float4 k_a, k_d, k_s,aLight;
			float map(vec3 pos)
		{
			float d = length(pos) - para.z;

			return d;
		}

			float castRay(vec3 ro, vec3 rd)
		{
			float t = 0.0;
			for (int i = 0; i < MAX_STEP; ++i) {
				vec3 pos = ro + t * rd;
				float h = map(pos);
				if (h < EPSLION)	return t;
				t += h;
				if (t > MAX_DIST)	break;
			}
			return MAX_DIST;
		}

			vec3 calcNormal(vec3 pos)
			{
				vec2 e = vec2(0.001, 0.0);
				return normalize(vec3(map(pos + e.xyy) - map(pos - e.xyy),
					map(pos + e.yxy) - map(pos - e.yxy), map(pos + e.yyx) - map(pos - e.yyx)));
			}

			vec3 PhongLight(vec3 I, vec3 Lpos, vec3 pos,vec3 ro)
			{
				vec3 N = calcNormal(pos);
				vec3 L = normalize(Lpos - pos);
				vec3 R = normalize(reflect(-L, N));
				vec3 V = normalize(ro-pos);

				float LN = dot(L, N);
				float RV = dot(R, V);

				if (LN < EPSLION)	return vec3(0.0, 0.0, 0.0);
				if (RV < EPSLION)	return k_d * I*LN;
				return I * (k_d*LN + k_s * pow(RV, 10.0));

			}

			vec3 PhongIllu(vec3 pos, vec3 ro)
			{
				vec3 col = vec3(0.0, 0.0, 0.0);
				col += k_a*aLight;

				vec3 lightI1 = vec3(0.2, 0.4, 0.4);
				vec3 lightPos1 = vec3(4.0*sin(iTime), 4.0, 4.0*cos(iTime));
				col += PhongLight(lightI1, lightPos1, pos,ro);


				vec3 lightI2 = vec3(0.6, 0.7, 0.8);
				vec3 lightPos2 = vec3(2.0*sin(0.37*iTime), 2.0*cos(0.37*iTime),2.0);
				col += PhongLight(lightI2, lightPos2, pos, ro);
				return col;

			}
			
			vec4 main(vec2 fragCoord) 
		{
			vec2 p = fragCoord / iResolution.xy * 2.0 - 1.0;
			p.x *= iResolution.x / iResolution.y;
			vec3 ro = vec3(0.0, 0.0, 5.0);
			vec3 rd = normalize(vec3(p, -1.0));
			vec3 col = vec3(0.0, 0.0, 0.0);

			float t = castRay(ro, rd);
			if (t >MAX_DIST - EPSLION) {
				col = vec3(0.0, 0.0, 0.0);
			}
			else {
				vec3 pos = ro + t * rd;
				vec3 nor = calcNormal(pos);


				col = PhongIllu(pos,ro);
			}
			return vec4(col, 1);
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
