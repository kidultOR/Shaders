Shader "Hair/test_rim"
{
    Properties
    {
        _MainTint("Diffuse Tint", Color) = (1,1,1,1)
        _RimPower ("Fresnel Falloff", Range(0.1, 3)) = 2
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        #pragma surface surf BlinnPhong
        #pragma target 3.0

        float4 _MainTint;
        float _RimPower;


        struct Input
        {
            float2 uv_MainTex;
            float3 viewDir;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            float rim = 1.0 - saturate(dot(o.Normal, normalize(IN.viewDir)));
            rim = pow(rim, _RimPower);
            
            o.Albedo = _MainTint;
            o.Emission =  rim;
        }

        ENDCG
    }
    FallBack "Diffuse"
}
