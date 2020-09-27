Shader "#sbGameLab/Eye"
{
    Properties
    {
        _MainMap("Main Map", 2D) = "gray" {}
        _NormalMap("Normal Map", 2D) = "bump"{}

        _ScleraColor1 ("Sclera Color 1", Color) = (1,1,1,1)
        _ScleraColor2 ("Sclera Color 2", Color) = (1,1,1,1)

        _IrisColor1 ("Iris Color 1", Color) = (1,1,1,1)
        _IrisColor2 ("Iris Color 2", Color) = (1,1,1,1)
        _IrisColor3 ("Iris Color 3", Color) = (1,1,1,1)

        _PupilColor ("Pupil Color", Color) = (1,1,1,1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Lambert
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
        
        sampler2D _MainMap;
        sampler2D _NormalMap;

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 main = tex2D (_MainMap, IN.uv_MainMap);
            fixed4 norm = tex2D (_NormalMap, IN.uv_MainMap);

            fixed3 sclera = (_ScleraColor1 * main.a + _ScleraColor2 * (1-main.a)) * (1-main.r);
            fixed3 iris = _IrisColor1 * main.a + _IrisColor2 * (1-main.a);
            iris = (_IrisColor3 * main.g + iris * (1-main.g)) * main.r;
            fixed3 pupil = _PupilColor * main.b;



            fixed3 c = (sclera + iris)*(1-main.b) + pupil; 
            o.Albedo = c.rgb;
            o.Specular = 0;
            o.Normal = UnpackNormal(norm);
        }
        ENDCG
    }
    FallBack "Diffuse"
}
