Shader "Unlit/comic"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Color("Color",Color)=(1,1,1,0)
        _AmbientColor("AmbientColor",Color)=(1,0,0,0)
        _Glossiness("Glossiness",float) = 32
        _SpecularColor("SpecularColor",Color)=(0,0,0,0)
        [HDR]
        _RimColor("Rim Color", Color) = (1,1,1,1)
        _RimAmount("Rim Amount", Range(0, 1)) = 0.716
        // Control how smoothly the rim blends when approaching unlit
        // parts of the surface.
        _RimThreshold("Rim Threshold", Range(0, 1)) = 0.1
    }
    SubShader
    {
        Tags {
            "LightMode"="ForwardBase"
            "PassFlags"="OnlyDirectional"
        }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fwdbase

            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #include "AutoLight.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float4 uv : TEXCOORD0;
                float3 normal:NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 pos : SV_POSITION;
                float3 worldNormal:NORMAL;
                float3 viewDir:TEXCOORD1;

                SHADOW_COORDS(2)
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                o.viewDir=WorldSpaceViewDir(v.vertex);

                TRANSFER_SHADOW(o);
                return o;
            }

            float4 _Color;
            float4 _AmbientColor;
            float _Glossiness;
            float4 _SpecularColor;
            float4 _RimColor;
            float _RimAmount;
            float _RimThreshold;

            fixed4 frag (v2f i) : SV_Target
            {
                float3 normal = normalize(i.worldNormal);
                float3 viewDir = normalize(i.viewDir);

                float LdotN = dot(normal,_WorldSpaceLightPos0);

                float shadow = SHADOW_ATTENUATION(i);
                float LightIntensity = smoothstep(0.0,0.01,LdotN);
                float4 light = LightIntensity * _LightColor0;

                float3 H = normalize(viewDir+_WorldSpaceLightPos0);
                float NdotH = dot(normal,H);
                float specualIntensity = pow(NdotH * LightIntensity,_Glossiness*_Glossiness);
                float specualSmooth = smoothstep(0.005,0.01,specualIntensity);
                float4 specualLight = specualSmooth * _SpecularColor;

                float rimDot = 1 - dot(viewDir,normal);
                float rimIntensity = rimDot * pow(LdotN,_RimThreshold);
                rimIntensity = smoothstep(_RimAmount-0.01,_RimAmount+0.01,rimIntensity);
                float4 rim = rimIntensity * _RimColor;


                fixed4 sample = tex2D(_MainTex, i.uv);
                float4 col = (light + specualLight + _AmbientColor + rim) * _Color *sample;
                return col;
            }
            ENDCG
        }

        UsePass "Legacy Shaders/VertexLit/SHADOWCASTER"
    }
}
