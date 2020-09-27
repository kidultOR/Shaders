Shader "Custom/SimpleVertexExtrusionWithTime"
{
    Properties
    {
    _Color ("Color", Color) = (1,1,1,1)
    _Amplitude ("Extrusion Amplitude", float) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM

        #pragma surface surf Standard fullforwardshadows vertex:vert

        #pragma target 3.0

        struct Input
        {
            float4 color : COLOR;
        };

        fixed4 _Color;
        float _Amplitude;

        void vert (inout appdata_full v)
        {
            v.vertex.xyz += v.normal * _Amplitude * (1-_SinTime.a);
        }
        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 c = _Color;
            o.Albedo = c.rgb;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
