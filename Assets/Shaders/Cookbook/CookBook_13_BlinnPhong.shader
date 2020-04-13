Shader "#Cookbook/CookBook_13_BlinnPhong"
{
    Properties
    {
        _MainTex ("Ваsе (RGB)", 2D) = "white" {}
        _MainTint ("Diffuse Tint", Color) = (1,1,1,1)
        _SpecularColor ("Specular Color", Color) = (1,1,1,1)
        _Spec ("Specular", Range(0,1)) = 0.5
        _SpecPower ("Specular Power", Range(0,30)) = 1
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        #pragma surface surf CustomBlinnPhong

        sampler2D _MainTex;
        float4 _MainTint;
        float4 _SpecularColor;
        float _Spec;
        float _SpecPower;

        struct Input
        {
            float2 uv_MainTex;
        };
        
        void surf (Input IN, inout SurfaceOutput o)
        {
            half4 c = tex2D(_MainTex, IN.uv_MainTex) * _MainTint;
            o.Specular = _SpecPower;
            o.Gloss = 1.0;
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }

        inline fixed4 LightingCustomBlinnPhong (SurfaceOutput s,fixed3 lightDir, half3 viewDir, fixed atten)
        {
            float3 halfVector = normalize(lightDir + viewDir);
            float diff = max(0, dot(s.Normal, lightDir));
            float nh = max(0, dot(s.Normal, halfVector));
            float spec = pow(nh, _SpecPower) * _SpecularColor * _Spec;
            float4 c;
            c.rgb = (s.Albedo * _LightColor0.rgb * diff) + (_LightColor0.rgb *_SpecularColor.rgb * spec) * (atten * 2);
            c.a = s.Alpha;
            return c;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
