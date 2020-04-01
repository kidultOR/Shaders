Shader "#sbGameLab/Masked_2"
{
    Properties{
        [Header(Maps)]
        _MainMap ("Main Map ( Metalic, Normal G, Smoothness, Normal R )", 2D) = "gray"{}
        _MaskMap ("Mask Map (Color 1, Color 2, Color 3)", 2D) = "black"{}

        [Space(30)]
        [Header(Base)]
        _ColorBase("Color Base", Color) = (0.5,0.5,0.5,0.5)
        _DetailMapBase ("Detail Map Base", 2D) = "black"{}
        [IntRange]_TileValueBase("Tile Ditail Base", Range(1,300)) = 10
        _DetailColorBase("Detail Color Base", Color) = (1,1,1,1)
        _Specular_Base("Specular", Range(0,1)) = 0.5
        _Gloss_Base("Gloss", Range(0.01,1)) = 0.5

        [Space(30)]
        [Header(Color 1 (Mask R))]
        _Color_1 ("Color 1 (Mask R)", Color) = (0.5,0.5,0.5,0.5)
        _DetailMap_1("Detail Map 1", 2D) = "black"{}
        [IntRange]_TileValue_1("Tile Ditail", Range(1,300)) = 10
        _DetailColor1("Detail Color", Color) = (1,1,1,1)
        _Specular_R("Specular R", Range(0,1)) = 0.5
        _Gloss_R("Gloss R", Range(0.01,1)) = 0.5

        [Space(30)]
        [Header(Color 2 (Mask G))]
        _Color_2 ("Color 2 (Mask G)", Color) = (0.5,0.5,0.5,0.5)
        _DetailMap_2("Detail Map 2", 2D) = "black"{}
        [IntRange]_TileValue_2("Tile Ditail Base", Range(1,300)) = 10
        _DetailColor2("Detail Color 2", Color) = (1,1,1,1)
        _Specular_G("Specular G", Range(0,1)) = 0.5
        _Gloss_G("Gloss G", Range(0.01,1)) = 0.5
        
        [Space(30)]
        [Header(Color 3 (Mask B))]
        _Color_3 ("Color 3 (Mask B)", Color) = (0.5,0.5,0.5,0.5)
        _DetailMap_3("Detail Map 3", 2D) = "black"{}
        [IntRange]_TileValue_3("Tile Ditail Base", Range(1,300)) = 10
        _DetailColor3("Detail Color 3", Color) = (1,1,1,1)
        _Specular_B("Specular B", Range(0,1)) = 0.5
        _Gloss_B("Gloss B", Range(0.01,1)) = 0.5

    }

    SubShader{
        Tags{"RenderType" = "Opaque"}

        CGPROGRAM

        #pragma surface surf SimpleSpecular

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
        
        fixed4 _DetailColorBase;
        fixed4 _DetailColor1;
        fixed4 _DetailColor2;
        fixed4 _DetailColor3;

        int _TileValueBase;
        int _TileValue_1;
        int _TileValue_2;
        int _TileValue_3;

        half _Specular_Base;
        half _Specular_R;
        half _Specular_G;
        half _Specular_B;

        half _Gloss_Base;
        half _Gloss_R;
        half _Gloss_G;
        half _Gloss_B;

        struct Input{
            float2 uv_MainMap;
            float2 uv_DetailMapBase;
        };

        void surf (Input IN, inout SurfaceOutput o){
            fixed4 maps = tex2D(_MainMap, IN.uv_MainMap);
            fixed4 mask = tex2D(_MaskMap, IN.uv_MainMap);
            fixed maskBase = 1 - mask.r - mask.g - mask.b;

            // Albedo
            float2 uv_dBase = IN.uv_MainMap * _TileValueBase;
            fixed4 detailBase = tex2D(_DetailMapBase, uv_dBase);
            fixed3 base = _ColorBase * (1 - detailBase.a) + detailBase.a * _DetailColorBase * detailBase;

            float2 uv_d1 = IN.uv_MainMap * _TileValue_1;
            fixed4 detail_1 = tex2D(_DetailMap_1, uv_d1);
            fixed3 c1 = _Color_1 * (1-detail_1.a) + _DetailColor1 * detail_1.rgb * detail_1.a;

            float2 uv_d2 = IN.uv_MainMap * _TileValue_2;
            fixed4 detail_2 = tex2D(_DetailMap_2, uv_d2);
            fixed3 c2 = _Color_2 * (1-detail_2.a) + _DetailColor2 * detail_2.rgb * detail_2.a;

            float2 uv_d3 = IN.uv_MainMap * _TileValue_3;
            fixed4 detail_3 = tex2D(_DetailMap_3, uv_d3);
            fixed3 c3 = _Color_3 * (1-detail_3.a) + _DetailColor3 * detail_3.rgb * detail_3.a;

            // o.Albedo = base * (1-mask.r) * (1-mask.g) * (1-mask.b) 
            o.Albedo = base * maskBase + c1 * mask.r + c2 * mask.g + c3 * mask.b;
            //Normal
            o.Normal = UnpackNormal(fixed4(maps.a, maps.g, 1, 1));
            // Specular
            o.Specular = _Specular_Base*maskBase + _Specular_R*mask.r + _Specular_G*mask.g + _Specular_B*mask.b;
            //Gloss
            o.Gloss = _Gloss_Base*maskBase + _Gloss_R*mask.r + _Gloss_G*mask.g + _Gloss_B*mask.b;
        }

        half4 LightingSimpleSpecular (SurfaceOutput s, half3 lightDir, half3 viewDir, half atten) {
            half3 h = normalize (lightDir + viewDir);

            half diff = max (0, dot (s.Normal, lightDir));

            float nh = max (0, dot (s.Normal, h));
            float spec = pow (nh , 300 * s.Gloss) * s.Specular;
 
            half4 c;
            c.rgb = (s.Albedo * _LightColor0.rgb * diff + _LightColor0.rgb * spec) * atten;
            c.a = s.Alpha;
            return c;
        }
        ENDCG
    }
    Fallback "Diffuse"  
}