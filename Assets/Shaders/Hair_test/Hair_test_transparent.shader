Shader "Hair/Hair_test_transparent"
{
    Properties
    {
        _AlbedoMap ("Albedo (RGB)", 2D) = "gray" {}
        _NormalMap ("Normal", 2D) = "bump" {}
        _SpecValue("Specular Value", Range(0,1)) = 1
        _SpecColor("Specular Color", color) = (1,1,1,1)
        _GlossValue ("Glossines Value", Range(0.01,1)) = 1
    }
    SubShader
    {
        Tags{
            "Queue" = "Transparent"
            "RenderType" = "Transparent"
            "IgnoreProjector"= "True"
        }
        LOD 200
        
        Cull off
        

        CGPROGRAM

        // #pragma surface surf BlinnPhong alphatest:_Cutoff addshadow
        #pragma surface surf HairSpecular alpha:fade

        #pragma target 3.0

        sampler2D _AlbedoMap;
        sampler2D _NormalMap;
        float _SpecValue;
        float _GlossValue;

        struct Input
        {
            float2 uv_AlbedoMap;
            float2 uv_NormalMap;
        };


        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D (_AlbedoMap, IN.uv_AlbedoMap);
            o.Albedo = c.rgb;
            o.Alpha = c.a;

            o.Specular = _SpecValue;
            o.Gloss = _GlossValue;

            o.Normal = UnpackNormal(tex2D(_NormalMap, IN.uv_NormalMap));
        }

        half4 LightingHairSpecular (SurfaceOutput s, half3 lightDir, half3 viewDir, half atten) {
            float3 halfVector = normalize(lightDir + viewDir);
            float nh = max(0, dot(s.Normal, halfVector));
            float spec = pow(nh, _GlossValue * 20) * _SpecValue;

            // float diff = max(0, dot(s.Normal, lightDir));
            // half diff = abs( dot (s.Normal, lightDir));
            half diff = dot (s.Normal, lightDir) * 0.5 + 0.5;
            
            float4 c;
            c.rgb = (s.Albedo * _LightColor0.rgb * diff) + (_LightColor0.rgb *_SpecColor.rgb * spec) * (atten * 2);
            // c.rgb = diff;
            c.a = s.Alpha;
            return c;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
