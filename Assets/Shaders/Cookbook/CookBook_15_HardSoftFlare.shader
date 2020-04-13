Shader "#Cookbook/CookBook_15_HardSoftFlare"
{
    Properties
    {
        _MainTint ("Diffuse Tint", Color) = (1,1,1,1)
        _MainTex ("Base (RGB)", 2D) = "white" {}
        _RoughnessTex ("Roughness texture", 2D) = "" {}
        _Roughness ("Roughness", Range(0,1)) = 0.5
        _SpecularColor ("Specular Color", Color) = (1,1,1,1)
        _SpecPower ("Specular Power", Range(0,30)) = 2
        _Fresnel ("Fresnel Value", Range(0,1.0)) = 0.05
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        #pragma surface surf MetallicSoft
        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _RoughnessTex;
        float _Roughness;
        float _Fresnel;
        float _SpecPower;
        float4 _MainTint;
        float4 _SpecularColor;

        
        struct Input
        {
            float2 uv_MainTex;
        };
        
        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 mainTex = tex2D(_MainTex, IN.uv_MainTex) * _MainTint;
            //Получим из текстуры информацию о цвете
            // float4 specMask = tex2D(_SpecularMask, IN.uv_MainTex) * _SpecularColor;
            // Зададим параметры структуры Output
            o.Albedo = mainTex.rgb;
            // o.Specular = specMask.r;
            // o.SpecularColor = specMask.rgb;
            o.Alpha = mainTex.a;
        }

        inline fixed4 LightingMetallicSoft (SurfaceOutput s, fixed3 lightDir, half3 viewDir, fixed atten)
        {
            //Вычислим диффузию и направление взгляда
            float3 halfVector = normalize(lightDir + viewDir);
            float NdotL = saturate(dot(s.Normal, normalize(lightDir)));
            float NdotH_raw = dot(s.Normal, halfVector);
            float NdotH = saturate(dot(s.Normal, halfVector));
            float NdotV = saturate(dot(s.Normal, normalize(viewDir)));
            float VdotH = saturate(dot(halfVector, normalize(viewDir)));

            //Распределение небольших неровностей
            float geoEnum = 2.0*NdotH;
            float3 G1 = (geoEnum * NdotV)/ NdotH;
            float3 G2 = (geoEnum * NdotL)/ NdotH;
            float3 G = min(1.0f, min(G1, G2));
            
            //Достаём цвет из BRDF-текстуры
            float roughness = tex2D(_RoughnessTex, float2(NdotH_raw * 0.5 + 0.5, _Roughness)).r;

            //Вычислим значение fresnel
            float fresnel = pow(1.0 - VdotH, 5.0);
            fresnel *= (1.0 - _Fresnel);
            fresnel += _Fresnel;

            //Сформируем итоговый блик
            float3 spec = float3(fresnel * G * roughness * roughness) *_SpecPower;

            float4 c;
            c.rgb = (s.Albedo * _LightColor0.rgb * NdotL)+ (spec *_SpecularColor.rgb) * (atten * 2.0);
            c.a = s.Alpha;
            return c;

        }
        ENDCG
    }
    FallBack "Diffuse"
}
