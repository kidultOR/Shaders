Shader "#Cookbook/CookBook_10_Photoshop_1"
{
    Properties
    {
        _MainTex ("Main Tex", 2D) = "gray" {}
        //Входные значения уровней
        _inBlack ("Input Black", Range(0, 255)) = 0
        _inGamma ("Input Gamma", Range(0, 2)) = 1.61
        _inWhite ("Input White", Range(0, 255)) = 255
        //Выходные значения уровней
        _outWhite ("Output White", Range(0,255)) = 255
        _outBlack ("Output Black", Range(0,255)) = 0
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        #pragma surface surf Lambert

        sampler2D _MainTex;
        float _inBlack;
        float _inGamma;
        float _inWhite;
        float _outWhite;
        float _outBlack;

        struct Input
        {
            float2 uv_MainTex;
        };
        
        
        float GetPixelLevel(float pixelColor)
        {
            float pixelResult;
            //Преобразуем диапазон от 0 до 1 к диапазону от 0 до 255
            pixelResult = pixelColor * 255.0;
            //Вычтем значение чёрного в параметре _inBlack
            pixelResult = max(0, pixelResult - _inBlack);
            //Увеличим значение белого для каждого пикселя с помощью _inWhite
            pixelResult = pixelResult / (_inWhite -_inBlack);
            //возведём в степень входной гаммы.
            pixelResult = saturate(pow(pixelResult, _inGamma));
            //Изменим итоговую чёрную точку и белую точку и приведём диапазон от 0 до 255 к диапазону от 0 до 1.
            pixelResult = (pixelResult * (_outWhite - _outBlack) + _outBlack)/255.0;
            return pixelResult;
        }

        void surf (Input IN, inout SurfaceOutput o)
        {
            float4 mainTex = tex2D(_MainTex, IN.uv_MainTex);
            float mainTexR = GetPixelLevel(mainTex.r);
            float mainTexG = GetPixelLevel(mainTex.g);
            float mainTexB = GetPixelLevel(mainTex.b);
            o.Albedo = float4(mainTexR,mainTexG,mainTexB,1);
                    
        }
        

        ENDCG
    }
    FallBack "Diffuse"
}
