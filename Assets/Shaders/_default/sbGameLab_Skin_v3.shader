Shader "#sbGameLab/Skin_3"{
    
    Properties{
        _SkinTone ("Skin Tone", Color) = (1,1,1,1)
        [Space(20)]
        _SpecValue("Specular Value", Range(0,1)) = 1
        _SpecColor("Specular Color", color) = (1,1,1,1)
        [Space(20)]
        _GlossValue ("Glossines Value", Range(0.01,1)) = 1
    }


    SubShader{
        Tags{"RenderType" = "Opaque"}

        CGPROGRAM
        #pragma surface surf SimpleSpecular

        fixed4 _SkinTone;
        // fixed4 _SpecColor;
        half _SpecValue;
        half _GlossValue;

        struct Input {
            float2 uv;
        };

        void surf(Input IN, inout SurfaceOutput o){
            o.Albedo = _SkinTone;
            o.Specular = _SpecValue;
            o.Gloss = _GlossValue;
        }


        half4 LightingSimpleSpecular (SurfaceOutput s, half3 lightDir, half3 viewDir, half atten) {
            
            half3 h = normalize (lightDir + viewDir);
            float nh = max (dot (s.Normal, h),0);
            float spec = pow (nh , 50 * s.Gloss) * s.Specular ;
            
            half diff = max (0, dot (s.Normal, lightDir));
 
            half4 c;
            c.rgb = (s.Albedo * _LightColor0.rgb * diff + _LightColor0.rgb * spec * _SpecColor) * atten;
            c.a = s.Alpha;
            return c;
        }
        ENDCG

    }
    Fallback "Diffuse"
}