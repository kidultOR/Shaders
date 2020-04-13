Shader "Custom/testlighting"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MetSmMap ("Metalic / Smoothness ", 2D) = "gray"{}
        _NormalMap ("Normal", 2D) = "bump"{}

        // _RimPower ("Rim Power", Range(0,10)) = 1
        _Metalic("Metalic", Range(0,1)) = 1 
        _Smooth("Smoothness", Range(0,1)) = 1 
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
            float spec = pow (nh , s.Gloss) * s.Specular;

            half4 c;
            c.rgb = (s.Albedo * _LightColor0.rgb * diff + _LightColor0.rgb * spec ) * atten;
            c.a = s.Alpha;
            return c;
        }

        struct Input
        {
            float2 uv_NormalMap;
            half3 viewDir;
        };

        fixed4 _Color;
        sampler2D _MetSmMap;
        sampler2D _NormalMap;

        float _RimPower;
        half _Metalic;
        half _Smooth;

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 MSmap = tex2D( _MetSmMap, IN.uv_NormalMap);
            fixed rim = pow (dot(IN.viewDir, o.Normal), _RimPower );
            o.Albedo = _Color;
            o.Specular = _Smooth;
            o.Gloss = _Smooth * 500;
            o.Normal = UnpackNormal(tex2D( _NormalMap, IN.uv_NormalMap));
        }
        ENDCG
    }
    FallBack "Diffuse"
}
