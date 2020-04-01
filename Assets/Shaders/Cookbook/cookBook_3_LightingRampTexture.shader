Shader "CoooBook/cookBook_LightingRampTexture"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        // Добавляем рамп карту 
        _RampMap ("Ramp", 2D) = "white"{}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM

        #pragma surface surf HalfLambert

        struct Input
        {
            float2 uv;
        };

        fixed4 _Color;
        // добавляем ссылку на параметр
        sampler2D _RampMap;

        void surf (Input IN, inout SurfaceOutput o)
        {
            o.Albedo = _Color;
        }

        half4 LightingHalfLambert (SurfaceOutput s, fixed3 lightDir, fixed atten)
        {
            float diff = dot(s.Normal, lightDir);
            float hLambert = diff * 0.5 + 0.5;
            float3 ramp = tex2D(_RampMap, float2(hLambert,hLambert));
            
            float4 c;
            c.rgb = ramp * _LightColor0.rgb * s.Albedo;
            c.a = s.Alpha;
            return c;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
