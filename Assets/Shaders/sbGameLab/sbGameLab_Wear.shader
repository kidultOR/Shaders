Shader "#sbGameLab/StylizedAvatar_Wear"
{
    Properties{
        [Header(Maps)]
        _MainMap ("Main Map ( Spec, Normal G, Gloss, Normal R )", 2D) = "gray"{}
        _MaskMap ("Mask Map", 2D) = "black"{}

        [Header(Base)]
        _ColorBase("Color Base", Color) = (0.5,0.5,0.5,0.5)
        // _SpecBase("Specular", Range(0,1)) = 0.5
        // _GlossBase("Gloss", Range(0.01,1)) = 0.5
        _DetailMapBase ("Detail Map Base", 2D) = "gray"{}
        [IntRange]_TileValueBase("Tile Ditail Base", Range(1,300)) = 10
        _DetailColorBase("Detail Color Base", Color) = (1,1,1,1)
        _SpecularColorBase("Specular Color Base", Color) = (1,1,1,1)

        [Header(Color 1 (Mask R))]
        _Color_1 ("Color 1 (Mask R)", Color) = (0.5,0.5,0.5,0.5)
        _DetailMap_1("Detail Map 1", 2D) = "white"{}
        [IntRange]_TileValue_1("Tile Ditail Base", Range(1,300)) = 10
        _DetailColor1("Detail Color 1", Color) = (1,1,1,1)
        _SpecularColor1("Specular Color 1", Color) = (1,1,1,1)

        [Header(Color 2 (Mask G))]
        _Color_2 ("Color 2 (Mask G)", Color) = (0.5,0.5,0.5,0.5)
        _DetailMap_2("Detail Map 2", 2D) = "white"{}
        [IntRange]_TileValue_2("Tile Ditail Base", Range(1,300)) = 10
        _DetailColor2("Detail Color 2", Color) = (1,1,1,1)
        _SpecularColor2("Specular Color 2", Color) = (1,1,1,1)
        
        [Header(Color 3 (Mask B))]
        _Color_3 ("Color 3 (Mask B)", Color) = (0.5,0.5,0.5,0.5)
        _DetailMap_3("Detail Map 3", 2D) = "white"{}
        [IntRange]_TileValue_3("Tile Ditail Base", Range(1,300)) = 10
        _DetailColor3("Detail Color 3", Color) = (1,1,1,1)
        _SpecularColor3("Specular Color 3", Color) = (1,1,1,1)

        [Toggle] _temp("temp", float) = 0

    }

    SubShader{
        Tags{"RenderType" = "Opaque"}

        CGPROGRAM

        #pragma surface surf SimpleSpecular
        
        half4 LightingSimpleSpecular (SurfaceOutput s, half3 lightDir, half3 viewDir, half atten) {
            half3 h = normalize (lightDir + viewDir);

            half diff = max (0, dot (s.Normal, lightDir));

            float nh = max (0, dot (s.Normal, h));
            float spec = pow (nh , 300 * s.Gloss) * s.Specular;

            half4 c;
            c.rgb = (s.Albedo * _LightColor0.rgb * diff + _LightColor0.rgb * spec * fixed3(1,0,0) ) * atten;
            c.a = s.Alpha;
            return c;
        }

        sampler2D _MainMap;
        sampler2D _MaskMap;
        sampler2D _DetailMapBase;
        sampler2D _DetailMap_1;
        sampler2D _DetailMap_2;
        sampler2D _DetailMap_3;

        fixed4 _ColorBase;
        fixed4 _Color_1;
        fixed4 _Color_2;
        fixed4 _Color_3;
        int _TileValueBase;
        int _TileValue_1;
        int _TileValue_2;
        int _TileValue_3;

        half _SpecBase;
        fixed _GlossBase;

        struct Input{
            float2 uv_MainMap;
            float2 uv_DetailMapBase;
        };

        void surf (Input IN, inout SurfaceOutput o){
            fixed4 maps = tex2D(_MainMap, IN.uv_MainMap);
            fixed4 mask = tex2D(_MaskMap, IN.uv_MainMap);

            float2 uv_dBase = IN.uv_MainMap * _TileValueBase;
            fixed4 detailBase = tex2D(_DetailMapBase, uv_dBase);
            fixed3 base = _ColorBase * (1 - detailBase.a) + detailBase.a * _ColorBase * detailBase;

            float2 uv_d1 = IN.uv_MainMap * _TileValue_1;
            fixed4 detail_1 = tex2D(_DetailMap_1, uv_d1);
            fixed m1 = detail_1.a * mask.r;
            fixed3 c1 = _Color_1 * detail_1.rgb;

            float2 uv_d2 = IN.uv_MainMap * _TileValue_2;
            fixed4 detail_2 = tex2D(_DetailMap_2, uv_d2);
            fixed m2 = detail_2.a * mask.g;
            fixed3 c2 = _Color_2 * detail_2.rgb;

            float2 uv_d3 = IN.uv_MainMap * _TileValue_3;
            fixed4 detail_3 = tex2D(_DetailMap_3, uv_d3);
            fixed m3 = detail_3.a * mask.b;
            fixed3 c3 = _Color_3 * detail_3.rgb;

            o.Albedo = base * (1-m1) * (1-m2) * (1-m3) 
                        + c1 * m1
                        + c2 * m2 
                        + c3 * m3;
            o.Normal = UnpackNormal(fixed4(maps.a, maps.g, 1, 1));
            o.Specular = maps.b;
            o.Gloss = maps.r;
        }
        ENDCG
    }
    Fallback "Diffuse"  
}