Shader "#sbGameLab/WearItem_VCMask_Alpha"
{
    Properties{
        [Header(Base)]
        _Base_Color("Base. Color", Color) = (0.5,0.5,0.5,0.5)
        _Base_Rim_Color("Base. Rim. Color", Color) = (0.5,0.5,0.5,0.5)
        _Base_Rim_Value("Base. Rim. Value", Range(0.01,10)) = 1
        _Base_Specular_Color("Base. Specular. Color", Color) = (1,1,1,1)
        _Base_Specular("Base. Specular", Range(0,1)) = 0.5
        _Base_Gloss("Base. Gloss", Range(0.01,1)) = 0.5
        _Base_Alpha("Base. Alpha", Range(0, 1)) = 1

        [Space(30)]
        [Header(Mask R)]
        _MaskR_Color ("Mask R. Color", Color) = (0.5,0.5,0.5,0.5)
        _MaskR_Rim_Color("Mask R. Rim. Color", Color) = (0.5,0.5,0.5,0.5)
        _MaskR_Rim_Value("Mask R. Rim. Value", Range(0.01,10)) = 1
        _MaskR_Specular_Color("Mask R. Specular. Color", Color) = (1,1,1,1)
        _MaskR_Specular("Mask R. Specular", Range(0,1)) = 0.5
        _MaskR_Gloss("Mask R. Gloss", Range(0.01,1)) = 0.5
        _MaskR_Alpha("Mask R. Alpha", Range(0, 1)) = 1

        [Space(30)]
        [Header(Mask G)]
        _MaskG_Color ("Mask G. Color", Color) = (0.5,0.5,0.5,0.5)
        _MaskG_Rim_Color("Mask G. Rim. Color", Color) = (0.5,0.5,0.5,0.5)
        _MaskG_Rim_Value("Mask G. Rim. Value", Range(0.01,10)) = 1
        _MaskG_Specular_Color("Mask G. Specular. Color", Color) = (1,1,1,1)
        _MaskG_Specular("Mask G. Specular", Range(0,1)) = 0.5
        _MaskG_Gloss("Mask G. Gloss", Range(0.01,1)) = 0.5
        _MaskG_Alpha("Mask G. Alpha", Range(0, 1)) = 1
        
        [Space(30)]
        [Header(Mask B)]
        _MaskB_Color ("Mask B. Color", Color) = (0.5,0.5,0.5,0.5)
        _MaskB_Rim_Color("Mask B. Rim. Color", Color) = (0.5,0.5,0.5,0.5)
        _MaskB_Rim_Value("Mask B. Rim. Value", Range(0.01,10)) = 1
        _MaskB_Specular_Color("Mask B. Specular. Color", Color) = (1,1,1,1)
        _MaskB_Specular("Mask B. Specular", Range(0,1)) = 0.5
        _MaskB_Gloss("Mask B. Gloss", Range(0.01,1)) = 0.5
        _MaskB_Alpha("Mask B. Alpha", Range(0, 1)) = 1

    }

    SubShader{
        Tags{"Queue" = "Transparent"
			"RenderType" = "Transparent"
            "IgnoreProjector" = "True"}
        // Cull Off 

        CGPROGRAM

        #pragma surface surf SimpleSpecular alpha vertex:vert 
        #pragma target 3.0

        fixed4 _Base_Color;
        fixed4 _MaskR_Color;
        fixed4 _MaskG_Color;
        fixed4 _MaskB_Color;
        
        fixed4 _Base_Rim_Color;
        fixed4 _MaskR_Rim_Color;
        fixed4 _MaskG_Rim_Color;
        fixed4 _MaskB_Rim_Color;

        half _Base_Rim_Value;
        half _MaskR_Rim_Value;
        half _MaskG_Rim_Value;
        half _MaskB_Rim_Value;

        half _Base_Specular;
        half _MaskR_Specular;
        half _MaskG_Specular;
        half _MaskB_Specular;

        fixed4 _Base_Specular_Color;
        fixed4 _MaskR_Specular_Color;
        fixed4 _MaskG_Specular_Color;
        fixed4 _MaskB_Specular_Color;

        half _Base_Gloss;
        half _MaskR_Gloss;
        half _MaskG_Gloss;
        half _MaskB_Gloss;

        half _Base_Alpha;
        half _MaskG_Alpha;
        half _MaskB_Alpha;
        half _MaskR_Alpha;

        struct Input{
            float4 vertColor;
            float3 viewDir;
        };

        struct SurfaceOutputMask
        {
            fixed3 Albedo;  
            fixed3 Normal;  
            fixed3 Emission;
            half Specular;  
            fixed Gloss;    
            fixed Alpha;
            fixed3 Mask;
        };
        
        void vert(inout appdata_full v, out Input o)
        {
            UNITY_INITIALIZE_OUTPUT(Input, o);
            o.vertColor = v.color;
        }

        void surf (Input IN, inout SurfaceOutputMask o){
            float rim = 1.0 - saturate(dot(o.Normal, normalize(IN.viewDir)));
            fixed3 mask = fixed3(IN.vertColor.r, IN.vertColor.g, IN.vertColor.b);
            fixed maskBase = 1 - mask.r - mask.g - mask.b;

            // Albedo
            float rimBase = pow(rim, _Base_Rim_Value);
            fixed3 base = _Base_Color * (1-rimBase) + _Base_Rim_Color * rimBase;

            float rimMaskR = pow(rim, _MaskR_Rim_Value);
            fixed3 c1 = _MaskR_Color * (1-rimMaskR) + _MaskR_Rim_Color * rimMaskR;

            float rimMaskG = pow(rim, _MaskG_Rim_Value);
            fixed3 c2 = _MaskG_Color * (1-rimMaskG) + _MaskG_Rim_Color * rimMaskG;

            float rimMaskB = pow(rim, _MaskB_Rim_Value);
            fixed3 c3 = _MaskB_Color * (1-rimMaskB) + _MaskB_Rim_Color * rimMaskB;

            o.Albedo = base * maskBase + c1 * mask.r + c2 * mask.g + c3 * mask.b;
            o.Alpha = _Base_Alpha * maskBase + _MaskR_Alpha * mask.r + _MaskG_Alpha * mask.g + _MaskB_Alpha * mask.b;
            // Specular
            o.Specular = _Base_Specular * maskBase 
                        + _MaskR_Specular * IN.vertColor.r 
                        + _MaskG_Specular * IN.vertColor.g 
                        + _MaskB_Specular * IN.vertColor.b;
            //Gloss
            o.Gloss = _Base_Gloss*maskBase + _MaskR_Gloss*IN.vertColor.r + _MaskG_Gloss*IN.vertColor.g + _MaskB_Gloss*IN.vertColor.b;
            o.Mask = mask;
        }

        half4 LightingSimpleSpecular (SurfaceOutputMask s, half3 lightDir, half3 viewDir, half atten) {
            half3 h = normalize (lightDir + viewDir);

            half diff = max (0, dot (s.Normal, lightDir));

            float nh = max (0, dot (s.Normal, h));
            float spec = pow (nh , 300 * s.Gloss) * s.Specular;
            fixed maskBase = 1 - s.Mask.r - s.Mask.g - s.Mask.b;
            fixed3 specularColor = _Base_Specular_Color * maskBase
                                    + _MaskR_Specular_Color * s.Mask.r
                                    + _MaskG_Specular_Color * s.Mask.g
                                    + _MaskB_Specular_Color * s.Mask.b;
 
            half4 c;
            c.rgb = (s.Albedo * _LightColor0.rgb * diff + _LightColor0.rgb * spec * specularColor) * atten;
            c.a = s.Alpha;
            return c;
        }
        ENDCG
    }
    Fallback "Diffuse"  
}