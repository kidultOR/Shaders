Shader "#Cookbook/Cookbook_7_Blending"
{
    Properties
    {
        _MainTint ("Diffuse Tint", Color) = (1,1,1,1)
        //Добавьте эти свойства, чтобы мы могли задавать текстуры
        _ColorA ("Terrain Color A", Color) = (1,1,1,1)
        _ColorB ("Terrain Color B", Color) = (1,1,1,1)
        _RTexture ("Red Channel Texture", 2D) = "" {}
        _GTexture ("Green Channel Texture", 2D) = "" {}
        _BTexture ("Blue Channel Texture", 2D) = "" {}
        _ATexture ("Alpha Channel Texture", 2D) = "" {}
        _BlendTex ("Blend Texture", 2D) = "" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        #pragma surface surf Lambert
        
        float4 _MainTint;
        float4 _ColorA;
        float4 _ColorB;
        sampler2D _RTexture;
        sampler2D _GTexture;
        sampler2D _BTexture;
        sampler2D _ATexture;
        sampler2D _BlendTex;

        struct Input
        {
            float2 uv_RTexture;
            float2 uv_GTexture;
            float2 uv_BTexture;
            float2 uv_ATexture;
            float2 uv_BlendTex;
        };
        
        void surf (Input IN, inout SurfaceOutput o)
        {
            //Получаем данные из блендинг-текстуры.
            //Здесь мы используем float4, потому что данные хранятся
            //в R,G,B и A или X,Y,Z и W каналах.
            float4 blendData = tex2D(_BlendTex, IN.uv_BlendTex);

            //Получаем цвета из текстур, которые мы хотим блендить
            float4 rTexData = tex2D(_RTexture, IN.uv_RTexture);
            float4 gTexData = tex2D(_GTexture, IN.uv_GTexture);
            float4 bTexData = tex2D(_BTexture, IN.uv_BTexture);
            float4 aTexData = tex2D(_ATexture, IN.uv_ATexture);

            //Теперь нужно объединить все цвета в один
            float4 finalColor;
            finalColor = lerp(rTexData, gTexData, blendData.g);
            finalColor = lerp(finalColor, bTexData, blendData.b);
            // finalColor = lerp(finalColor, aTexData, blendData.a);
            finalColor.a = 1;

            //Добавим наши цвета ландшафта
            float4 terrainLayers = lerp(_ColorA, _ColorB, blendData.r);
            finalColor *= terrainLayers;
            finalColor = saturate(finalColor);

            o.Albedo = finalColor.rgb * _MainTint.rgb;
            o.Alpha = finalColor.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
