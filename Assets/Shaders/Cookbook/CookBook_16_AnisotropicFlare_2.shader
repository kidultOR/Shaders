Shader "#Cookbook/CookBook_16_AnisotropicFlare_2"
{
    Properties
    {
        _MainTint ("Diffuse Tint", Color) = (1,1,1,1)
        _MainTex ("Bаsе (RGB)", 2D) = "white"{}
        _SpecularColor ("Specular Color", Color) = (1,1,1,1)
        _Specular ("Specular Amount", Range(0,1)) = 0.5
        _SpecPower ("Specular Power", Range(0,1)) = 0.5
        _AnisoDirMap ("Anisotropic Direction", 2D) = "gray"{}
        _AnisoOffset ("Anisotropic Offset", Range(-1,1)) = -0.2
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        #pragma surface surf Anisotropic
        // #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _AnisoDirMap;
        fixed4 _MainTint;
        fixed4 _SpecularColor;
        half _Specular;
        half _SpecPower;
        half _AnisoOffset;


        struct Input
        {
            float2 uv_MainTex;
            float2 uv_AnisoDirMap;
        };

        struct AnisotropicOutput {
            fixed3 Albedo;
            fixed3 Normal;
            fixed3 Emission;
            fixed3 AnisoDirection;
            half Specular;
            fixed Gloss;
            fixed Alpha;
        };  

        void surf (Input IN, inout AnisotropicOutput o)
        {
            fixed4 color = tex2D(_MainTex, IN.uv_MainTex) * _MainTint;
            float3 anisoTex = UnpackNormal(tex2D(_AnisoDirMap, IN.uv_AnisoDirMap));

            o.AnisoDirection = anisoTex;
            o.Specular = _Specular;
            o.Gloss = _SpecPower;
            o.Albedo = color;
            o.Alpha = color.a;
        }

        fixed4 LightingAnisotropic (AnisotropicOutput s,fixed3 lightDir, half3 viewDir, fixed atten)
        {
            //Полувектор
            fixed3 halfVector = normalize(lightDir + viewDir);
            // дифузный компонент
            float diff = saturate(dot(s.Normal, lightDir));
            // Складываем нормали поверхности и карты нормали для бликов
            float3 _normal = normalize(s.Normal + s.AnisoDirection);
            // скалярное произведение нормали с рассчитанным на предыдущем этапе значением halfVector 
            // Интенсивность отражения блика
            fixed intens = dot( _normal, halfVector);
            // fixed intens = dot(s.Normal, halfVector);
            // Добавляем смещение блику
            intens = intens + _AnisoOffset;
            // Получение темного блика по сенредине и эфекта кольца
            float aniso = saturate(sin(radians(intens) * 180));
            // Mасштабируем эффект от применения переменной aniso, возводя её в степень s.Gloss, 
            // а затем мы глобально уменьшаем его силу, умножая на s.Specular.
            float spec = saturate(pow(aniso, s.Gloss * 128) * s.Specular);

            
            float4 c;
            c.rgb = ((s.Albedo * _LightColor0.rbg * diff) + (_LightColor0.rgb * _SpecularColor.rgb * spec)) * atten;
            c.a = s.Alpha;
            return c;
        }

        ENDCG
    }
    FallBack "Diffuse"
}
