Shader "Custom/BlinnPhong"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _MainTint("Diffuse Tint",Color) = (1,1,1,1)
        _SColor("Sepcular Color",Color) = (1,0,0,1)
        _SPower("Power",Range(0,30)) = 10.0
       
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf BlinnPhong

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;
        float4 _MainTint;
        float4 _SColor;
        float _SPower;

        struct Input
        {
            float2 uv_MainTex;
        };
       

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutput o)
        {
            // Albedo comes from a texture tinted by color
            half4 c = tex2D (_MainTex, IN.uv_MainTex)*_MainTint;
            o.Albedo = c.rgb;
            o.Alpha = c.a;
          
        }

        half4 LightingBlinnPhong(SurfaceOutput s , fixed3 lightDir , half atten , float3 viewDir)
        {
            float dotLN = dot(s.Normal,lightDir);
            float3 R = normalize(2.0 * s.Normal * dotLN - lightDir);
            float3 V = viewDir;

            float RV = dot(R,V);

            fixed4 c;
            c.rgb = _LightColor0.rgb * (s.Albedo * atten * dotLN + _SColor.rgb * pow(max(0,RV),_SPower));
            return c;
            
        }
        ENDCG
    }
    FallBack "Diffuse"
}
