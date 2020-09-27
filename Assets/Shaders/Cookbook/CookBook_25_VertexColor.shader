Shader "#Cookbook/CookBook_25_VertexColor"
{
    Properties
    {
        _MainTint ("Global Tint", Color) = (1,1,1,1)
        _Power ("Power", Range(0,100)) = 1
        _Offset ("Offset", Range(-1,1)) = 0
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        #pragma surface surf Lambert vertex:vert

        float4 _MainTint;
        float _Power;
        float _Offset;

        struct Input
        {
            float2 uv_MainTex;
            float4 vertColor;
        };

        void vert(inout appdata_full v, out Input o)
        {
            UNITY_INITIALIZE_OUTPUT(Input, o);
            o.vertColor = v.color;
        }

        void surf(Input IN, inout SurfaceOutput o)
        {
            fixed c = (IN.vertColor.r + _Offset) * _Power;
            o.Albedo = c * _MainTint.rgb;
        }

        ENDCG
    }
    FallBack "Diffuse"
}
