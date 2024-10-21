Shader "#Cookbook/CookBook_19_frenel_reverse"
{
    Properties
    {
        _Fresnel ("Fresnel", Range(-1, 1)) = 0
        _Power ("Power", Range(0, 30)) = 0
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        #pragma surface surf Lambert
        #pragma target 3.0

        float _Fresnel;
        float _Power;


        struct Input
        {
            float3 viewDir;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            float rim = saturate(dot(o.Normal, normalize(IN.viewDir)));
            float rimPos = _Fresnel * rim;
            float rimNeg = abs(_Fresnel) * (1-rim);
            float maskPos = max(_Fresnel,0);
            float maskNeg = abs(min(_Fresnel,0));
            rim = maskPos * rimPos + maskNeg * rimNeg;
            rim = pow(rim, _Power);
            
            o.Albedo = rim;
        }

        ENDCG
    }
    FallBack "Diffuse"
}
