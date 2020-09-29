Shader "#sbGameLab/Skin_v3"
{
    Properties{
        [Header(Base)]
        _Color("Color", Color) = (1,1,1,1)
        _ColorMap ("Color Map", 2D) = "gray" {}
        _MainMap ("Main Map (R=Metallic, G=Normal_G, B=Smoothness, A=Normal_R)", 2D) = "gray" {}
        _SpecColor("Specular Color", Color) = (1,1,1,1)
        _Specular ("Specular", Range(0,1)) = 0.0
        _Gloss ("Gloss", Range(0.01,1)) = 0.5 

        [Header(Body)]
        _BodyMap ("Body Map", 2D) = "black"{}
        _BodyColor("Body. Color", Color) = (1,1,1,1)
        _BodySpecColor("Body. Specular Color", Color) = (1,1,1,1)
        _BodyGloss("Body. Gloss", Range(0.01, 1))= 0.5

        [Header(Face)]
        _FaceMap ("Face Map", 2D) = "black"{}
        _FaceColor("Face. Color", Color) = (1,1,1,1)
        _FaceSpecColor("Face. Specular Color", Color) = (1,1,1,1)
        _FaceGloss("Face. Gloss", Range(0.01, 1))= 0.5

        [Header(Eyes)]
        _EyesMap ("Eyes Map", 2D) = "black"{}
        _EyesColor("Eyes. Color ", Color) = (1,1,1,1)
        _EyesSpecColor("Eyes. Specular Color", Color) = (1,1,1,1)
        _EyesGloss("Eyes. Gloss", Range(0.01, 1))= 0.5
        
        [Header(Lips)]
        _LipsMap ("Lips Map", 2D) = "black"{}
        _LipsColor("Face. Color", Color) = (1,1,1,1)
        _LipsSpecColor("Lips. Specular Color", Color) = (1,1,1,1)
        _LipsGloss("Lips. Gloss", Range(0.01, 1))= 0.5
    }

    SubShader{
        Tags{"RenderType" = "Opaque"}

        CGPROGRAM

        #pragma surface surf SimpleSpecular
        #pragma target 3.0

        sampler2D _ColorMap;
        sampler2D _MainMap;
        sampler2D _BodyMap;
        sampler2D _FaceMap;
        sampler2D _EyesMap;
        sampler2D _LipsMap;

        fixed4 _Color;
        fixed4 _BodyColor;
        fixed4 _FaceColor;
        fixed4 _EyesColor;
        fixed4 _LipsColor;

        half _Gloss;
        half _Specular;
        half _BodyGloss;
        half _FaceGloss;
        half _EyesGloss;
        half _LipsGloss;

        

        struct Input{
            float2 uv_MainMap;
            float2 uv2_FaceMap;
            float2 uv3_EyesMap;
            float2 uv4_LipsMap;
            // float4 vertColor;
            float3 viewDir;
            
        };

        struct SurfaceOutputStr
        {
            fixed3 Albedo;
            fixed3 Normal;
            fixed3 Emission;
            fixed3 Specular;
            fixed Gloss;
            fixed3 specColor;
            fixed Alpha;
        };

        void surf (Input IN, inout SurfaceOutputStr o){
            fixed3 c = tex2D (_ColorMap, IN.uv_MainMap) * _Color;

            fixed4 bmap = tex2D(_BodyMap, IN.uv_MainMap);
            fixed3 bc = _BodyColor * bmap;

            fixed4 fmap = tex2D(_FaceMap, IN.uv2_FaceMap);
            fixed3 fc = _FaceColor * fmap;

            fixed4 emap = tex2D(_EyesMap, IN.uv3_EyesMap);
            fixed3 ec = _EyesColor * emap;

            fixed4 lmap = tex2D(_LipsMap, IN.uv4_LipsMap);
            fixed3 lc = _LipsColor * lmap;

            c = c * (1-bmap.a) + bc * bmap.a;
            c = c * (1-fmap.a) + fc * fmap.a;
            c = c * (1-emap.a) + ec * emap.a;
            c = c * (1-lmap.a) + lc * lmap.a;
            o.Albedo = c.rgb;

            //  Normal
            fixed4 main  = tex2D (_MainMap, IN.uv_MainMap);
            o.Normal = UnpackNormal(fixed4(main.a, main.g, 1, 1));
            //  Specular
            o.Specular = _Specular;
            //  Gloss
            o.Gloss = _Gloss;
        }

        half4 LightingSimpleSpecular (SurfaceOutputStr s, half3 lightDir, half3 viewDir, half atten) {
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