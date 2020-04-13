Shader "#Cookbook/Cookbook_8_Normals"
{
    Properties
    {
        _MainTint ("Diffuse Tint", Color) = (1,1,1,1)
        _NormalTex ("Normal Map", 2D) = "bump" {}
        _NormalIntensity ("Normal Map Intensity", Range(0,5)) = 1

    }

    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        #pragma surface surf Lambert

        float4 _MainTint;
        sampler2D _NormalTex;
        float _NormalIntensity;

        struct Input
        {
            float2 uv_NormalTex;
        };
        
        void surf (Input IN, inout SurfaceOutput o)
        {
            //Получаем направления нормалей из текстуры карты нормалей
            //с помощью функции UnpackNormal().
            float3 normalMap = UnpackNormal(tex2D(_NormalTex,IN.uv_NormalTex)) * float3(_NormalIntensity,_NormalIntensity,1);

            o.Normal = normalMap.rgb;
            o.Albedo = _MainTint;

        }
        ENDCG
    }
    FallBack "Diffuse"
}
