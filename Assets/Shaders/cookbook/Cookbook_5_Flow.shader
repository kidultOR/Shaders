Shader "#Cookbook/Cookbook_5_Flow"
{
    Properties
    {
        _Map ("map", 2D) = "gray"{}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        #pragma surface surf Lambert

        struct Input
        {
            float2 uv_Map;
        };

        sampler2D _Map; 
        fixed4 _Color;

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed2 scrolledUV = IN.uv_Map + fixed2(_Time.x, 0);

            half4 map = tex2D(_Map, scrolledUV);

            o.Albedo = map.rgb;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
