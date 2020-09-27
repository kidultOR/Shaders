Shader "Hair/Hair_v3" {
    Properties {
        _MainMap ("Main Map:  Alpha (R),  Normal G (G),  AO (B),  Normal R (A)", 2D) = "gray" {}
        _Cutoff ("Base Alpha cutoff", Range (0,.9)) = .5

        _Color_Root_1 ("Color Root 1", Color) = (.5, .5, .5, .5)
        _Color_Root_2 ("Color Root 2", Color) = (.5, .5, .5, .5)
        _Color_Tip_1 ("Color Tip 1", Color) = (.5, .5, .5, .5)
        _Color_Tip_2 ("Color Tip 2", Color) = (.5, .5, .5, .5)
        _Power_G ("Gradient", Range(0,100)) = 1
        _Offset_G ("Offset Gradient", Range(-1,1)) = 0

        _SpecColor("Specular Color", color) = (1,1,1,1)
        _SpecValue("Specular Value", Range(0,1)) = 1
        _GlossValue ("Glossines Value", Range(0.01,1)) = 1
        _AnisoOffset ("Anisotropic Offset", Range(-1,1)) = 0

    }
    SubShader {
        Cull Off
        AlphaTest Greater [_Cutoff]

        CGPROGRAM
        #pragma surface surf SimpleSpecular alphatest:_Cutoff vertex:vert
        #pragma target 3.0

        struct Input {
            float2 uv_MainMap;
            float3 viewDir;
            float4 vertColor;
        };

        sampler2D _MainMap;
        fixed4 _Color_Root_1;
        fixed4 _Color_Root_2;
        fixed4 _Color_Tip_1;
        fixed4 _Color_Tip_2;
        float _Power_G;
        float _Offset_G;
        half _SpecValue;
        half _GlossValue;
        half _AnisoOffset;

        void vert(inout appdata_full v, out Input o)
        {
            UNITY_INITIALIZE_OUTPUT(Input, o);
            o.vertColor = v.color;
        }

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 main = tex2D(_MainMap, IN.uv_MainMap);
            fixed g = saturate((IN.vertColor.r + _Offset_G) * _Power_G);
            // Color
            fixed3 cR = lerp(_Color_Root_1, _Color_Root_2, main.b);
            fixed3 cT = lerp(_Color_Tip_1, _Color_Tip_2, main.b);
            o.Albedo = lerp(cT, cR, g);
            o.Alpha = main.r;
            // Normal
            o.Normal = UnpackNormal(fixed4(main.a, main.g, 1, 1));
            // Specular
            o.Specular = _SpecValue;
            o.Gloss = _GlossValue;
        }

        half4 LightingSimpleSpecular (SurfaceOutput s, half3 lightDir, half3 viewDir, half atten) {
            
            half3 h = normalize (lightDir + viewDir);
            float nh = max (dot (s.Normal, h),0);
            
            // Specular
            float spec = nh + _AnisoOffset;
            spec = saturate(sin(radians(spec) * 180));
            spec = saturate(pow (spec , 50 * s.Gloss) * s.Specular);
            // float spec = pow (nh , 50 * s.Gloss) * s.Specular ;
            
            // Diffuse
            half diff = dot (s.Normal, lightDir) * 0.5 + 0.5;

            // OUT
            half4 c;
            c.rgb = (s.Albedo * _LightColor0.rgb * diff + _LightColor0.rgb * spec * _SpecColor);
            // c.rgb = (s.Albedo * _LightColor0.rgb * diff + _LightColor0.rgb * spec * _SpecColor) * atten;
            c.a = s.Alpha;
            return c;
        }
        ENDCG


        AlphaTest LEqual [_Cutoff]

        CGPROGRAM
        #pragma surface surf SimpleSpecular alpha:fade vertex:vert
        #pragma target 3.0

        struct Input {
            float2 uv_MainMap;
            float3 viewDir;
            float4 vertColor;
        };

        sampler2D _MainMap;
        fixed4 _Color_Root_1;
        fixed4 _Color_Root_2;
        fixed4 _Color_Tip_1;
        fixed4 _Color_Tip_2;
        float _Power_G;
        float _Offset_G;
        half _SpecValue;
        half _GlossValue;
        half _AnisoOffset;

        void vert(inout appdata_full v, out Input o)
        {
            UNITY_INITIALIZE_OUTPUT(Input, o);
            o.vertColor = v.color;
        }

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 main = tex2D(_MainMap, IN.uv_MainMap);
            fixed g = saturate((IN.vertColor.r + _Offset_G) * _Power_G);
            // Color
            fixed3 cR = lerp(_Color_Root_1, _Color_Root_2, main.b);
            fixed3 cT = lerp(_Color_Tip_1, _Color_Tip_2, main.b);
            o.Albedo = lerp(cT, cR, g);
            o.Alpha = main.r;
            // Normal
            o.Normal = UnpackNormal(fixed4(main.a, main.g, 1, 1));
            // Specular
            o.Specular = _SpecValue;
            o.Gloss = _GlossValue;
        }

        half4 LightingSimpleSpecular (SurfaceOutput s, half3 lightDir, half3 viewDir, half atten) {
            
            half3 h = normalize (lightDir + viewDir);
            float nh = max (dot (s.Normal, h),0);
            
            // Specular
            float spec = nh + _AnisoOffset;
            spec = saturate(sin(radians(spec) * 180));
            spec = saturate(pow (spec , 50 * s.Gloss) * s.Specular);
            // float spec = pow (nh , 50 * s.Gloss) * s.Specular ;
            
            // Diffuse
            half diff = dot (s.Normal, lightDir) * 0.5 + 0.5;

            // OUT
            half4 c;
            c.rgb = (s.Albedo * _LightColor0.rgb * diff + _LightColor0.rgb * spec * _SpecColor);
            // c.rgb = (s.Albedo * _LightColor0.rgb * diff + _LightColor0.rgb * spec * _SpecColor) * atten;
            c.a = s.Alpha;
            return c;
        }
        ENDCG
    }
}