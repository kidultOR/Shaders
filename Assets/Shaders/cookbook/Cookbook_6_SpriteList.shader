Shader "#Cookbook/Cookbook_6_SpriteSlist"
{
    Properties
    {
        _Map ("map", 2D) = "gray"{}
        _CellAmount("Cell amount", float) = 0
        _Speed ("Speed", Range(0.01, 32)) = 12
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        #pragma surface surf Lambert

        struct Input
        {
            float2 uv_Map;
        };

        sampler2D _Map; 
        float _CellAmount;
        float _Speed;

        void surf (Input IN, inout SurfaceOutput o)
        {
            //Сохраним UV в переменной
            float2 spriteUV = IN.uv_Map;
            // Вычислим, сколько занимает одна клетка 
            float cellUVPercentage = 1/_CellAmount;
            //Вычислим номер кадра для сдвига UV
            float frame = fmod(_Time.y * _Speed, _CellAmount); 
            frame = floor(frame);
            //Изменим UV в соответствии с текущим кадром
            float xValue = (spriteUV.x + frame) * cellUVPercentage; 
            spriteUV = float2(xValue, spriteUV.y);


            fixed4 map = tex2D( _Map, spriteUV);
            o.Albedo = map.rgb;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
