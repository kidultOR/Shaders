Shader "CoooBook/cookBook_halfLambert"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
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

        void surf (Input IN, inout SurfaceOutput o)
        {
            o.Albedo = _Color;
        }

        half4 LightingHalfLambert (SurfaceOutput s, fixed3 lightDir, fixed atten)
        {
            float diff = dot(s.Normal, lightDir);
            // преобразует диапазон значений скалярного произведения нормали к поверхности и направления света из [–1, 1] в [0, 1].
            float hLambert = diff * 0.5 + 0.5;
            
            float4 c;
            c.rgb = hLambert * atten * _LightColor0.rgb * s.Albedo;
            c.a = s.Alpha;
            return c;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
