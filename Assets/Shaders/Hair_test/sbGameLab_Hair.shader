Shader "Hair/sbGameLab_Hair"{
    
    Properties{
        _MainMap("Main Texture", 2D) = "Gray"{}
        _Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
        _HairToneDark ("Hair Tone Dark", Color) = (1,1,1,1)
        _HairToneLight ("Hair Tone Light", Color) = (1,1,1,1)

        [Space(20)]
        _SpecValue("Specular Value", Range(0,1)) = 1
        _SpecColor("Specular Color", color) = (1,1,1,1)
        // _SpecMultMMapB("Multiply Main Blue Channal", Range(0,1)) = 0.5
        [Space(20)]
        _GlossValue ("Glossines Value", Range(0.01,1)) = 1
    }


    SubShader{
        Tags{
            "Queue" = "AlphaTest"
            "RenderType" = "TransparentCutout"
            "IgnoreProjector"= "True"
        }
        
        Cull off

        CGPROGRAM
        #pragma surface surf SimpleSpecular alphatest:_Cutoff addshadow

        sampler2D _MainMap;
        fixed4 _HairToneDark;
        fixed4 _HairToneLight;
        half _SpecValue;
        // half _SpecMultMMapB;
        half _GlossValue;

        struct Input {
            float2 uv_MainMap;
        };

        void surf(Input IN, inout SurfaceOutput o){
            fixed4 mMap = tex2D(_MainMap, IN.uv_MainMap);
            o.Normal = UnpackNormal(fixed4(mMap.a, mMap.g, 1, 1));
            o.Albedo = _HairToneDark * (1-mMap.b) + _HairToneLight * mMap.b;
            // o.Specular = _SpecValue - _SpecValue * (1-mMap.b) * _SpecMultMMapB;
            o.Specular = _SpecValue * mMap.b;
            o.Gloss = _GlossValue;
            o.Alpha = mMap.r;
        }


        half4 LightingSimpleSpecular (SurfaceOutput s, half3 lightDir, half3 viewDir, half atten) {
            
            half3 h = normalize (lightDir + viewDir);
            float nh = max (dot (s.Normal, h),0);
            float spec = pow (nh , 50 * s.Gloss) * s.Specular ;
            
            half diff = abs( dot (s.Normal, lightDir));
            // half diff = max (0, dot (s.Normal, lightDir));
 
            half4 c;
            c.rgb = (s.Albedo * _LightColor0.rgb * diff + _LightColor0.rgb * spec * _SpecColor) * atten;
            c.a = s.Alpha;
            return c;
        }
        ENDCG

    }
    Fallback "Diffuse"
}