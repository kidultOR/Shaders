Shader "#Cookbook/CookBook_18_ReflectionNormal"
{
    Properties
    {
        _MainTint ("Diffuse Tint", Color) = (1,1,1,1)
        _MainTex ("Base (RGB)", 2D) = "white" {}
        // + normal map
        _NormalMap ("Normal Map", 2D) = "bump" {}
        _ReflAmount ("Reflection Amount", Range(0, 1)) = 1
        _Cubemap ("Cubemap", CUBE) = ""{}
        _ReflMask ("Reflection Mask", 2D) = ""{}
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        #pragma surface surf Lambert
        sampler2D _MainTex;
        sampler2D _ReflMask;
        // +
        sampler2D _NormalMap;
        samplerCUBE _Cubemap;
        float4 _MainTint;
        float _ReflAmount;


        struct Input
        {
            float2 uv_MainTex;
            // +
            float2 uv_NormalMap;
            float3 worldRefl;
            //  С помощью макроса INTERNAL_DATA мы можем получить доступ к нормалям поверхности после их модификации картой нормалей.
            INTERNAL_DATA
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            half4 c = tex2D(_MainTex, IN.uv_MainTex);
            // + распаковка нормалей 
            float3 normals = UnpackNormal(tex2D(_NormalMap,IN.uv_NormalMap)).rgb;
            float3 reflection = texCUBE(_Cubemap,IN.worldRefl).rgb;
            float4 reflMask = tex2D(_ReflMask, IN.uv_MainTex);

            o.Normal = normals;
            o.Emission = texCUBE(_Cubemap, WorldReflectionVector (IN, o.Normal)).rgb * _ReflAmount * reflMask.r;
            o.Albedo = c.rgb * _MainTint;
            o.Alpha = c.a;
        }

        ENDCG
    }
    FallBack "Diffuse"
}
