Shader "CoooBook/cookBook_LightingBRDF"
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
        sampler2D _RampMap;

        void surf (Input IN, inout SurfaceOutput o)
        {
            o.Albedo = _Color;
        }

        half4 LightingHalfLambert (SurfaceOutput s, fixed3 lightDir, half3 viewDir, fixed atten) // добавляем направление взгляда viewDir
        {
            float diff = dot(s.Normal, lightDir);
            // скалярное произведение направления взгляда и нормали к поверхности
            float rim = dot(s.Normal, viewDir);
            float hLambert = diff * 0.5 + 0.5;
            float3 ramp = tex2D(_RampMap, float2(hLambert,rim));
            
            float4 c;
            c.rgb = ramp * _LightColor0.rgb * s.Albedo;
            // c.rgb = rim;
            c.a = s.Alpha;
            return c;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
