Shader "Custom/testlighting"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _Specular ("Specular", Range(0,1)) = 0.5
        _Gloss ("Gloss", Range(0.001,1)) = 0.5
        _SpecularColor ("Specular Color", Color) = (1,1,1,1)

        _Normal ("Normal", 2D) = "bump"{}
        _NormalValue("Normal Value", Range(0,1)) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM

        #pragma surface surf SimpleSpecular
        
        half4 LightingSimpleSpecular (SurfaceOutput s, half3 lightDir, half3 viewDir, half atten) {
            half3 h = normalize (lightDir + viewDir);

            half diff = max (0, dot (s.Normal, lightDir));

            float nh = max (0, dot (s.Normal, h));
            float spec = pow (nh , 300 * s.Gloss) * s.Specular;

            half4 c;
            // c.rgb = (s.Albedo * _LightColor0.rgb * diff + _LightColor0.rgb * spec) * atten;
            c.rgb = (s.Albedo * _LightColor0.rgb * diff + _LightColor0.rgb * spec ) * atten;
            c.a = s.Alpha;
            return c;
        }

        struct Input
        {
            float2 uv_Normal;
        };

        fixed4 _Color;
        half _Specular;
        fixed _Gloss;
        sampler2D _Normal;
        half _NormalValue;

        void surf (Input IN, inout SurfaceOutput o)
        {
            o.Albedo = _Color;
            o.Specular = _Specular;
            o.Gloss = _Gloss;
            o.Normal = UnpackNormal(tex2D( _Normal, IN.uv_Normal));
        }
        ENDCG
    }
    FallBack "Diffuse"
}
