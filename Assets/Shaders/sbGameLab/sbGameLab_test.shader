Shader "#sbGameLab/TEST"{
    Properties{
        _Value_1 ("Value 1", Range(0,1)) = 0
        _Value_2 ("Value 2", Range(0,1)) = 0
    }
    SubShader{
        Tags{"RenderType" = "Opaque"}
        CGPROGRAM
        // #pragma surface surf SimpleSpecular
        #pragma surface surf Lambert
        
        float _Value_1;
        float _Value_2;

        struct Input {
            float2 uv;
        };

        void surf(Input IN, inout SurfaceOutput o){
            o.Albedo = fixed3(_Value_1,_Value_1,_Value_1);
        }

        ENDCG

    }
    Fallback "Diffuse"
}