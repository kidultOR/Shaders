Shader "#sbGameLab/Skin_v2_Spec"
{
    Properties{
        [Header(Base)]
        _Color("Color", Color) = (1,1,1,1)
        _ColorMap ("Color Map", 2D) = "gray" {}
        _MainMap ("Main Map (R=Metallic, G=Normal_G, B=Smoothness, A=Normal_R)", 2D) = "gray" {}
        _SpecColor("Specular Color", Color) = (1,1,1,1)
        _Specular ("Specular", Range(0,1)) = 0.0
        _Gloss ("Gloss", Range(0.01,1)) = 0.5 

        [Header(Face)]
        _FaceMap ("Face Map", 2D) = "gray"{}
        _FaceColor0("Face. Color 0", Color) = (1,1,1,1)
        _FaceColor1("Face. Color 1", Color) = (1,1,1,1)
        _FaceColor2("Face. Color 2", Color) = (1,1,1,1)
        _FaceColor3("Face. Color 3", Color) = (1,1,1,1)
        
        [Header(Lips)]
        _LipsMap ("Lips Map", 2D) = "black"{}
        _LipsColor0("Face. Color 0", Color) = (1,1,1,1)
        _LipsColor1("Face. Color 1", Color) = (1,1,1,1)
        _LipsColor2("Face. Color 2", Color) = (1,1,1,1)
        _LipsColor3("Face. Color 3", Color) = (1,1,1,1)
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
        fixed3 _FaceColor0;
        fixed3 _FaceColor1;
        fixed3 _FaceColor2;
        fixed3 _FaceColor3;
        fixed3 _LipsColor0;
        fixed3 _LipsColor1;
        fixed3 _LipsColor2;
        fixed3 _LipsColor3;
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
            fixed3 fc = _FaceColor0 *(1-fmap.r) + _FaceColor1*fmap.r;
            fc =  fc *(1-fmap.g) + _FaceColor2*fmap.g;
            fc = fc*(1-fmap.b) + _FaceColor3*fmap.b;

            fixed4 lmap = tex2D(_LipsMap, IN.uv3_LipsMap);
            fixed3 lc = _LipsColor0*(1-lmap.r) + _LipsColor1*lmap.r;
            lc = lc*(1-lmap.g) + _LipsColor2*lmap.g;
            lc = lc*(1-lmap.b) + _LipsColor3*lmap.b;

            c = c * (1-fmap.a) + fc * fmap.a;
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