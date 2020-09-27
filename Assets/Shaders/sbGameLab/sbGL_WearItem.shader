Shader "#sbGameLab/WearItem"
{
    Properties{
        _MainMap("Main Map", 2D) = "grey"{}
    
        [Header(Base. Color)]
        _Base_Color("Base. Color", Color) = (0.5,0.5,0.5,0.5)
        _Base_Rim_Color("Base. Rim. Color", Color) = (0.5,0.5,0.5,0.5)
        _Base_Rim_Value("Base. Rim. Value", Range(0.01,10)) = 1
        [Header(Base. Detail)]
        _BaseDetailMap("Base. Detail Map", 2D) = "black"{}
        _BaseDetailTile("Base. Detail Tile", Range(0,100)) = 1
        _Base_DetailColor("Base. Detail Color", Color) = (0.5,0.5,0.5,0.5)
        [Header(Base. Specular)]
        _Base_Specular_Color("Base. Specular. Color", Color) = (1,1,1,1)
        _Base_Specular("Base. Specular", Range(0,1)) = 0.5
        _Base_Gloss("Base. Gloss", Range(0.01,1)) = 0.5

    }

    SubShader{
        Tags{"RenderType" = "Opaque"}

        CGPROGRAM

        #pragma surface surf SimpleSpecular
        #pragma target 3.0

        sampler2D _MainMap;
        sampler2D _BaseDetailMap;
        fixed3 _Base_Color;
        fixed3 _Base_Rim_Color;
        fixed3 _Base_DetailColor;
        float _BaseDetailTile;
        half _Base_Rim_Value;
        half _Base_Specular;
        fixed3 _Base_Specular_Color;
        half _Base_Gloss;

        struct Input{
            float2 uv_MainMap;
            float2 uv2_BaseDetailMap;
            float4 vertColor;
            float3 viewDir;
        };

        void surf (Input IN, inout SurfaceOutput o){
            fixed4 maps = tex2D( _MainMap, IN.uv_MainMap);
            float2 dUV = _BaseDetailTile * IN.uv2_BaseDetailMap;
            fixed4 dMap = tex2D( _BaseDetailMap, dUV);
            float rim = 1.0 - saturate(dot(o.Normal, normalize(IN.viewDir)));

            //  Base
            float rimBase = pow(rim, _Base_Rim_Value);
            fixed3 base = _Base_Color * (1-dMap.a) + dMap * dMap.a * _Base_DetailColor;

            //  Albedo
            o.Albedo =  base * (1-rimBase) + _Base_Rim_Color * rimBase;
            //  Normal
            o.Normal = UnpackNormal(fixed4(maps.a, maps.g, 1, 1));
            //  Specular
            o.Specular = _Base_Specular;
            //  Gloss
            o.Gloss = _Base_Gloss;
        }

        half4 LightingSimpleSpecular (SurfaceOutput s, half3 lightDir, half3 viewDir, half atten) {
            half3 h = normalize (lightDir + viewDir);

            half diff = max (0, dot (s.Normal, lightDir));

            float nh = max (0, dot (s.Normal, h));
            float spec = pow (nh , 300 * s.Gloss) * s.Specular;
            fixed3 specularColor = _Base_Specular_Color;
 
            half4 c;
            c.rgb = (s.Albedo * _LightColor0.rgb * diff + _LightColor0.rgb * spec * specularColor) * atten;
            c.a = s.Alpha;
            return c;
        }
        ENDCG
    }
    Fallback "Diffuse"  
}