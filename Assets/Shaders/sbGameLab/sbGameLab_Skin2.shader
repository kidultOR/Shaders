﻿Shader "#sbGameLab/Skin2"{
    Properties{
        _Color ("Color", Color) = (1,1,1,1)
        [Space(20)]
        _Spec ("Spec", Range(0,10)) = 0.5
        _Gloss ("Gloss", Range(0,10)) = 1
        _SpecColor("Specular Color", Color) = (1,1,1,1)
        [Space(20)]
        _Power("Power", Range(0,50)) = 10
        _SSSMap ("SSSMap", 2D) = "black"{}
        _SSSColor ("SSS Color", Color) = (1,1,1,1)
        _SSSValue("SSS Value", Range(0,1)) = 1
    }
    SubShader{
        Tags{"RenderType" = "Opaque"}
        CGPROGRAM
        #pragma surface surf SimpleSpecular

        float _Power;
        fixed4 _Color;
        fixed4 _SSSColor;
        float _Gloss;
        float _Spec;
        float _SSSValue;
        sampler2D _SSSMap;

        struct Input {
            float2 uv_SSSMap;
        };

        void surf(Input IN, inout SurfaceOutput o){
            fixed4 sssMap = tex2D(_SSSMap, IN.uv_SSSMap);
            o.Albedo = _Color;
            o.Gloss = _Gloss;
            o.Specular = _Spec;
            o.Emission = pow(sssMap, _Power) * _SSSColor * _SSSValue;
        }

        half4 LightingSimpleSpecular (SurfaceOutput s, half3 lightDir, half3 viewDir, half atten) {
            
            half3 h = normalize (lightDir + viewDir);
            float nh = max (dot (s.Normal, h),0);
            float spec = pow (nh , 300 * s.Gloss) * s.Specular ;
            
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