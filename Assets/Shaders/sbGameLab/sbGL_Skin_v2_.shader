Shader "#sbGameLab/Skin_v2_Spec"
{
    Properties{
        [Header(Base)]
        _Color("Color", Color) = (1,1,1,1)
        _ColorMap ("Color Map", 2D) = "gray" {}
        _MainMap ("Main Map (R=Metallic, G=Normal_G, B=Smoothness, A=Normal_R)", 2D) = "gray" {}
        _SpecColor("Specular Color", Color) = (1,1,1,1)
        _Specular ("Specular", Range(0,1)) = 0.0
        _Gloss ("Smoothness", Range(0,1)) = 0.5 

        [Header(Face)]
        _FaceMap ("Face Map", 2D) = "gray"{}
        _FaceColor("Face. Color", Color) = (1,1,1,1)
        
        [Header(Lips)]
        _LipsMap ("Lips Map", 2D) = "black"{}
        _LipsColor("Face. Color", Color) = (1,1,1,1)
    }

    SubShader{
        Tags{"RenderType" = "Opaque"}

        CGPROGRAM

        #pragma surface surf SimpleSpecular
        #pragma target 3.0

        sampler2D _ColorMap;
        sampler2D _MainMap;
        sampler2D _FaceMap;
        sampler2D _LipsMap;

        fixed3 _Color;
        fixed3 _FaceColor;
        fixed3 _LipsColor;
        half _Gloss;
        half _Specular;

        struct Input{
            float2 uv_MainMap;
            float2 uv2_FaceMap;
            float2 uv3_LipsMap;
            // float4 vertColor;
            float3 viewDir;
        };

        void surf (Input IN, inout SurfaceOutput o){
            fixed3 c = tex2D (_ColorMap, IN.uv_MainMap) * _Color;
            fixed4 fmap = tex2D(_FaceMap, IN.uv2_FaceMap);
            fixed4 lmap = tex2D(_LipsMap, IN.uv3_LipsMap);
            c = c * (1-fmap.a) + _FaceColor * fmap.a;
            c = c * (1-lmap.a) + _LipsColor * lmap.a;
            o.Albedo = c.rgb;

            //  Normal
            fixed4 main  = tex2D (_MainMap, IN.uv_MainMap);
            o.Normal = UnpackNormal(fixed4(main.a, main.g, 1, 1));
            //  Specular
            o.Specular = _Specular;
            //  Gloss
            o.Gloss = _Gloss;
        }

        half4 LightingSimpleSpecular (SurfaceOutput s, half3 lightDir, half3 viewDir, half atten) {
            half3 h = normalize (lightDir + viewDir);

            half diff = max (0, dot (s.Normal, lightDir));

            float nh = max (0, dot (s.Normal, h));
            float spec = pow (nh , 300 * s.Gloss) * s.Specular;
            fixed3 specularColor = _SpecColor;
 
            half4 c;
            c.rgb = (s.Albedo * _LightColor0.rgb * diff + _LightColor0.rgb * spec * specularColor) * atten;
            c.a = s.Alpha;
            return c;
        }
        ENDCG
    }
    Fallback "Diffuse"  
}