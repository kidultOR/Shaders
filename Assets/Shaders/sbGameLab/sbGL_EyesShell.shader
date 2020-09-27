Shader "#sbGameLab/EyesShell"
{
    Properties
    {
        _MainMap("Main Map", 2D) = "gray" {}
        _Opasity("Opasity", Range(0,1)) = 1

        _SpecColor ("Specular Color", Color) = (1,1,1,1)
        _SpecValue ("Specular Value", Range(0,10)) = 0.5
        _GlossValue ("Gloss Value", Range(0,10)) = 0.5

        _ScleraColor1 ("Sclera Color 1", Color) = (1,1,1,1)
        _ScleraColor2 ("Sclera Color 2", Color) = (1,1,1,1)

        _IrisColor1 ("Iris Color 1", Color) = (1,1,1,1)
        _IrisColor2 ("Iris Color 2", Color) = (1,1,1,1)
        _IrisColor3 ("Iris Color 3", Color) = (1,1,1,1)

        _PupilColor ("Pupil Color", Color) = (1,1,1,1)
    }
    SubShader
    {
        // Tags { "RenderType"="Opaque" }
        Tags{
            "Queue" = "Transparent"
            "RenderType" = "Transparent"
            "IgnoreProjector"= "True"
        }
        LOD 200

        CGPROGRAM
        #pragma surface surf BlinnPhong alpha:fade
        #pragma target 3.0

        struct Input
        {
            float2 uv_MainMap;
        };

        fixed3 _ScleraColor1;
        fixed3 _ScleraColor2;
        fixed3 _IrisColor1;
        fixed3 _IrisColor2;
        fixed3 _IrisColor3;
        fixed3 _PupilColor;

        float _Opasity;
        float _SpecValue;
        float _GlossValue;
        
        sampler2D _MainMap;

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 main = tex2D (_MainMap, IN.uv_MainMap);

            fixed3 sclera = (_ScleraColor1 * main.a + _ScleraColor2 * (1-main.a)) * (1-main.r);
            fixed3 iris = _IrisColor1 * main.a + _IrisColor2 * (1-main.a);
            iris = (_IrisColor3 * main.g + iris * (1-main.g)) * main.r;
            fixed3 pupil = _PupilColor * main.b;

            fixed3 c = (sclera + iris)*(1-main.b) + pupil; 
            o.Albedo = c.rgb;
            o.Specular = _SpecValue;
            o.Gloss = _GlossValue;
            o.Alpha = _Opasity;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
