Shader "#Cookbook/Cookbook_6_SpriteSlist_2"
{
    Properties
    {
        _Map ("map", 2D) = "gray"{}
        _CellAmount("Cell amount", float) = 0
        _Speed ("Speed", Range(0.01, 32)) = 12
        _TimeValue("Time Amount", float) = 0
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
        float _TimeValue;


        void surf (Input IN, inout SurfaceOutput o)
        {
            //Сохраним UV в переменной
            float2 spriteUV = IN.uv_Map;
            // Вычислим, сколько занимает одна клетка 
            float cellUVPercentage = 1/_CellAmount;
            
            //ВЫПОЛНЯЮТСЯ ЗА СЧЕТ СКРИПТА (эти вычисления перенести на CPU иделать их не для каждого пикселя, а всего лишь один раз)
            //Вычислим номер кадра для сдвига UV
            // float frame = fmod(_Time.y * _Speed, _CellAmount); // Получаем остаток от деление
            // frame = floor(frame); // Отбрасываем дробную часть ( мы получим номер текущего кадра в диапазоне от 0 до _CellAmount - 1)

            //Изменим UV в соответствии с текущим кадром
            float xValue = (spriteUV.x + _TimeValue) * cellUVPercentage; 
            spriteUV = float2(xValue, spriteUV.y);


            fixed4 map = tex2D( _Map, spriteUV);
            o.Albedo = map.rgb;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
