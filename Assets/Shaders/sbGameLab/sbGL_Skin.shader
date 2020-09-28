Shader "#sbGameLab/Skin_Simple"
{
    Properties
    {
        [Header(Base)]
        _Color("Color", Color) = (1,1,1,1)
        _ColorMap ("Color Map", 2D) = "gray" {}
        _MainMap ("Main Map (R=Metallic, G=Normal_G, B=Smoothness, A=Normal_R)", 2D) = "gray" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0

        [Header(Face)]
        _FaceMap ("Face Map", 2D) = "gray"{}
        _FaceColor("Face. Color", Color) = (1,1,1,1)
        
        [Header(Lips)]
        _LipsMap ("Lips Map", 2D) = "gray"{}
        _LipsColor("Face. Color", Color) = (1,1,1,1)

    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _ColorMap;
        sampler2D _MainMap;
        sampler2D _FaceMap;
        sampler2D _LipsMap;

        fixed3 _Color;
        fixed3 _FaceColor;
        fixed3 _LipsColor;
        half _Glossiness;
        half _Metallic;

        struct Input
        {
            float2 uv_MainMap;
            float2 uv2_FaceMap;
            float2 uv3_LipsMap;
        };


        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            // Albedo comes from a texture tinted by color
            fixed3 c = tex2D (_ColorMap, IN.uv_MainMap) * _Color;
            fixed4 fmap = tex2D(_FaceMap, IN.uv2_FaceMap);
            fixed4 lmap = tex2D(_LipsMap, IN.uv3_LipsMap);
            c = c * (1-fmap.a) + _FaceColor * fmap.a;
            o.Albedo = c.rgb;

            fixed4 main  = tex2D (_MainMap, IN.uv_MainMap);
            // Normal
            o.Normal = UnpackNormal(fixed4(main.a, main.g, 1, 1));
            // Metallic and smoothness come from slider variables
            o.Metallic = main.r * _Metallic;
            o.Smoothness = main.b * _Glossiness;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
