Shader "#Cookbook/CookBook_14_SpecularTexture"
{
        Properties
        {
            //Объявим свойства, чтобы можно было использовать
            //данные из редактора с панели инспектора.
            _MainTex ("Base (RGB)", 2D) = "white" {}
            _MainTint ("Diffuse Tint", Color) = (1,1,1,1)

            _SpecularMask ("Specular Texture", 2D) = "white" {}
            _SpecularColor ("Specular Tint", Color) = (1,1,1,1)
            _SpecPower ("Specular Power", Range(0.1, 120)) = 3
        }

    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        #pragma surface surf CustomPhong

        sampler2D _MainTex;
        sampler2D _SpecularMask;
        float4 _MainTint;
        float4 _SpecularColor;
        float _SpecPower;

        // Создадим нашу выходную структуру.
        struct SurfaceCustomOutput
        {
            fixed3 Albedo;
            fixed3 Normal;
            fixed3 Emission;
            fixed3 SpecularColor;
            half Specular;
            fixed Gloss;
            fixed Alpha;
        };

        struct Input
        {
            float2 uv_MainTex;
        };
        
        void surf (Input IN, inout SurfaceCustomOutput o)
        {
            fixed4 mainTex = tex2D(_MainTex, IN.uv_MainTex) * _MainTint;
            //Получим из текстуры информацию о цвете
            float4 specMask = tex2D(_SpecularMask, IN.uv_MainTex) * _SpecularColor;
            // Зададим параметры структуры Output
            o.Albedo = mainTex.rgb;
            o.Specular = specMask.r;
            o.SpecularColor = specMask.rgb;
            o.Alpha = mainTex.a;
        }

        inline fixed4 LightingCustomPhong (SurfaceCustomOutput s, fixed3 lightDir, half3 viewDir, fixed atten)
        {
            //Вычислим диффузный и отражённый векторы
            float diff = dot(s.Normal, lightDir);
            float3 reflectionVector = normalize(2.0 * s.Normal * diff - lightDir);
            //Вычислим Phong блик
            float spec = pow(max(0, dot(reflectionVector, viewDir)), _SpecPower) * s.Specular;
            float3 finalSpec = s.SpecularColor * spec * _SpecularColor.rgb;
            //Посчитаем итоговый цвет
            fixed4 c;
            c.rgb = (s.Albedo * _LightColor0.rgb * diff) + (_LightColor0.rgb * finalSpec);
            c.a = s.Alpha;
            return c;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
