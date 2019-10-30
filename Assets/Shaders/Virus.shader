// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Shadertoy/Virus" {
	Properties{
		_Parameters("Circle Parameters", Vector) = (0.5, 0.5, 10, 1) // Center: (x, y), Radius: z
		_CircleColor("Circle Color", Color) = (1, 1, 1, 1)
		_BackgroundColor("Background Color", Color) = (1, 1, 1, 1)
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

float4 _Parameters;
	float4 _CircleColor;
	float4 _BackgroundColor;

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

	
#define DIST_SURFACE .001f
#define DIST_MAX 1000.f
#define MAX_STEPS 100

		float remap(float a, float b, float t)//ramap t from a-b to 0-1
	{
		return (t - a) / (b - a);
	}

	float dsSphere(vec3 p, vec3 c, float r)
	{
		return length(p - c) - r;
	}

	float dsWholeMap(vec3 p)
	{
		float displacement = sin(5.0 * p.x + iTime * 5.f) * sin(5.0 * p.y + iTime * 5.f) * sin(5.0 * p.z + iTime * 5.f) * .15f;
		float dSphere = dsSphere(p, vec3(0.0,0.0,0.0), 2.f);

		return dSphere + displacement;
	}

	vec3 GetNormal(vec3 p)
	{
		vec2 swizzle = vec2(.001f, 0);
		float gradient_x = dsWholeMap(p + swizzle.xyy) - dsWholeMap(p - swizzle.xyy);
		float gradient_y = dsWholeMap(p + swizzle.yxy) - dsWholeMap(p - swizzle.yxy);
		float gradient_z = dsWholeMap(p + swizzle.yyx) - dsWholeMap(p - swizzle.yyx);

		return normalize(vec3(gradient_x, gradient_y, gradient_z));
	}

	float GetLightDifuse(vec3 p, vec3 lightP)
	{
		vec3 normal = GetNormal(p);
		vec3 dirToL = normalize(lightP - p);
		float f = remap(-1.f, 1.f, dot(normal, dirToL));
		return f;
	}

	vec3 RayMarching(vec3 ro, vec3 rd)
	{
		float totalDist = 0.f;
		for (int i = 0; i < MAX_STEPS; i++)
		{
			vec3 currentPos = ro + rd * totalDist;
			vec3 center = vec3(0,0,0);
			float dS = dsWholeMap(currentPos);
			if (dS < DIST_SURFACE)
			{
				vec3 lightPos = vec3(4.f * sin(iTime), 4.f, 4.f * cos(iTime));
				float difuse = GetLightDifuse(currentPos, lightPos);
				//vec3 col = vec3(1.f,0,0);
				vec3 col = 0.5 + 0.5*cos(iTime + currentPos.xyx + vec3(0, 2, 4));
				return  difuse * col;
			}
			if (dS > DIST_MAX)
				break;

			totalDist += dS;
		}

		return vec3(0.0,0.0,0.0);
	}


	vec4 main(vec2 fragCoord) {
		vec2 uv = fragCoord / iResolution.xy *2.0-1.0 ;// make it -1 - 1
		uv.x *= iResolution.x / iResolution.y;

		//primitive camera
		vec3 ro = vec3(0, 0.f, 5.f);
		vec3 rd = normalize(vec3(uv.x, uv.y, -1.f));

		vec3 col_sphere = RayMarching(ro, rd);

		vec4 fragColor = vec4(col_sphere, 1.f);
	
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
