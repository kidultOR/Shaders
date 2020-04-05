Shader "#sbGameLab/Cloth_Masked_v2"
{
    Properties{
        [Header(Maps)]
        _MainMap ("Main Map (Gradient, Normal G, ___ , Normal R )", 2D) = "gray"{}
        _MaskMap ("Mask Map (Mask R, Mask G, Mask B)", 2D) = "black"{}

        [Space(30)]
        [Header(Base)]
        _Base_Color_1("Base. Color 1", Color) = (0.5,0.5,0.5,0.5)
        _Base_Color_2("Base. Color 2", Color) = (0.5,0.5,0.5,0.5)
        _Base_DetailMap ("Base. Detail Map", 2D) = "black"{}
        [IntRange]_Base_Tile("Base. Tile Ditail", Range(1,300)) = 10
        _Base_Color_Detail("Base. Color for Detail Map", Color) = (1,1,1,1)
        _Base_Specular("Base. Specular", Range(0,1)) = 0.5
        _Base_Gloss("Base. Gloss", Range(0.01,1)) = 0.5

        [Space(30)]
        [Header(Mask R)]
        _MaskR_Color_1 ("Mask R. Color 1", Color) = (0.5,0.5,0.5,0.5)
        _MaskR_Color_2 ("Mask R. Color 2", Color) = (0.5,0.5,0.5,0.5)
        _MaskR_DetailMap("Mask R. Detail Map", 2D) = "black"{}
        [IntRange]_MaskR_Tile("Mask R. Tile Ditail", Range(1,300)) = 10
        _MaskR_Color_Detail("Mask R. Color for Detail Map", Color) = (1,1,1,1)
        _MaskR_Specular("Mask R. Specular R", Range(0,1)) = 0.5
        _MaskR_Gloss("Mask R. Gloss R", Range(0.01,1)) = 0.5

        [Space(30)]
        [Header(Mask G)]
        _MaskG_Color_1 ("Mask G. Color 1", Color) = (0.5,0.5,0.5,0.5)
        _MaskG_Color_2 ("Mask G. Color 2", Color) = (0.5,0.5,0.5,0.5)
        _MaskG_DetailMap("Mask G. Detail Map", 2D) = "black"{}
        [IntRange]_MaskG_Tile("Mask G. Tile Ditail", Range(1,300)) = 10
        _MaskG_Color_Detail("Mask G. Detail Color", Color) = (1,1,1,1)
        _MaskG_Specular("Mask G. Specular", Range(0,1)) = 0.5
        _MaskG_Gloss("Mask G. Gloss", Range(0.01,1)) = 0.5
        
        [Space(30)]
        [Header(Mask B)]
        _MaskB_Color_1 ("Mask B. Color 1", Color) = (0.5,0.5,0.5,0.5)
        _MaskB_Color_2 ("Mask B. Color 2", Color) = (0.5,0.5,0.5,0.5)
        _MaskB_DetailMap("Mask B. Detail Map", 2D) = "black"{}
        [IntRange]_MaskB_Tile("Mask B. Tile Ditail", Range(1,300)) = 10
        _MaskB_Color_Detail("Mask B. Detail Color", Color) = (1,1,1,1)
        _MaskB_Specular("Mask B. Specular", Range(0,1)) = 0.5
        _MaskB_Gloss("Mask B. Gloss", Range(0.01,1)) = 0.5

    }

    SubShader{
        Tags{"RenderType" = "Opaque"}

        CGPROGRAM

        #pragma surface surf SimpleSpecular

        sampler2D _MainMap;
        sampler2D _MaskMap;
        
        sampler2D _Base_DetailMap;
        sampler2D _MaskR_DetailMap;
        sampler2D _MaskG_DetailMap;
        sampler2D _MaskB_DetailMap;

        fixed4 _Base_Color_1;
        fixed4 _Base_Color_2;
        fixed4 _MaskR_Color_1;
        fixed4 _MaskR_Color_2;
        fixed4 _MaskG_Color_1;
        fixed4 _MaskG_Color_2;
        fixed4 _MaskB_Color_1;
        fixed4 _MaskB_Color_2;
        
        fixed4 _Base_Color_Detail;
        fixed4 _MaskR_Color_Detail;
        fixed4 _MaskG_Color_Detail;
        fixed4 _MaskB_Color_Detail;

        int _Base_Tile;
        int _MaskR_Tile;
        int _MaskG_Tile;
        int _MaskB_Tile;

        half _Base_Specular;
        half _MaskR_Specular;
        half _MaskG_Specular;
        half _MaskB_Specular;

        half _Base_Gloss;
        half _MaskR_Gloss;
        half _MaskG_Gloss;
        half _MaskB_Gloss;

        struct Input{
            float2 uv_MainMap;
            float2 uv_Base_DetailMap;
        };

        void surf (Input IN, inout SurfaceOutput o){
            float2 uv_main = IN.uv_MainMap;
            fixed4 maps = tex2D(_MainMap, uv_main);
            fixed4 mask = tex2D(_MaskMap, uv_main);
            fixed maskBase = 1 - mask.r - mask.g - mask.b;


            // Albedo
            float2 uv_dBase = uv_main * _Base_Tile;
            fixed4 detailBase = tex2D(_Base_DetailMap, uv_dBase);
            fixed3 baseColor = (1-maps.r)*_Base_Color_1 + maps.r*_Base_Color_2;
            fixed3 base = baseColor * (1 - detailBase.a) + detailBase.a * _Base_Color_Detail * detailBase;

            float2 uv_d1 = uv_main * _MaskR_Tile;
            fixed4 detail_1 = tex2D(_MaskR_DetailMap, uv_d1);
            fixed3 maskRColor = (1-maps.r)*_MaskR_Color_1 + maps.r*_MaskR_Color_2;
            fixed3 c1 = maskRColor * (1-detail_1.a) + _MaskR_Color_Detail * detail_1.rgb * detail_1.a;

            float2 uv_d2 = uv_main * _MaskG_Tile;
            fixed4 detail_2 = tex2D(_MaskG_DetailMap, uv_d2);
            fixed3 maskGColor = (1-maps.r)*_MaskG_Color_1 + maps.r*_MaskG_Color_2;
            fixed3 c2 = maskGColor * (1-detail_2.a) + _MaskG_Color_Detail * detail_2.rgb * detail_2.a;

            float2 uv_d3 = uv_main * _MaskB_Tile;
            fixed4 detail_3 = tex2D(_MaskB_DetailMap, uv_d3);
            fixed3 maskBColor = (1-maps.r)*_MaskB_Color_1 + maps.r*_MaskB_Color_2;
            fixed3 c3 = maskBColor * (1-detail_3.a) + _MaskB_Color_Detail * detail_3.rgb * detail_3.a;

            // o.Albedo = base * (1-mask.r) * (1-mask.g) * (1-mask.b) 
            o.Albedo = base * maskBase + c1 * mask.r + c2 * mask.g + c3 * mask.b;
            //Normal
            o.Normal = UnpackNormal(fixed4(maps.a, maps.g, 1, 1));
            // Specular
            o.Specular = _Base_Specular*maskBase + _MaskR_Specular*mask.r + _MaskG_Specular*mask.g + _MaskB_Specular*mask.b;
            //Gloss
            o.Gloss = _Base_Gloss*maskBase + _MaskR_Gloss*mask.r + _MaskG_Gloss*mask.g + _MaskB_Gloss*mask.b;
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