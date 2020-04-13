Shader "#Cookbook/CookBook_12_Phong"
{
    Properties
    {
        _MainTex ("Ваsе (RGB)", 2D) = "white" {}
        _MainTint ("Diffuse Tint", Color) = (1,1,1,1)
        _SpecularColor ("Specular Color", Color) = (1,1,1,1)
        _SpecPower ("Specular Power", Range(0,30)) = 1
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        #pragma surface surf Phong

        sampler2D _MainTex;
        float4 _MainTint;
        float4 _SpecularColor;
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

        inline fixed4 LightingPhong (SurfaceOutput s, fixed3 lightDir, half3 viewDir, fixed atten)
        {
            //Вычислим диффузный и отражённый вектор
            float diff = dot(s.Normal, lightDir);
            // вектор отражения, для этого мы умножаем вектор нормали на 2*diff и вычитаем из него направление
            // света. Таким образом, получается эффект наклона нормали к свету – и даже если нормаль была направлена от источника света, 
            // она будет вынуждена к нему повернуться.
            float3 reflectionVector = normalize(2.0 * s.Normal * diff - lightDir);
            float spec = pow(max(0, dot(reflectionVector, viewDir)), _SpecPower);
            float3 finalSpec = _SpecularColor.rgb * spec;
            fixed4 c;
            c.rgb = (s.Albedo * _LightColor0.rgb * diff) + (_LightColor0.rgb * finalSpec);
            c.a = 1.0;
            return c;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
