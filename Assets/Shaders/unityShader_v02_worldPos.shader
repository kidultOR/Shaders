Shader "temp/UnityShader_v02_worldPos"{
    Properties{
        _MainTex ("Main Texture", 2D) = "gray"{}
        _NormalMap ("Normal Map", 2D) = "bump"{}
        _DetailMap ("Detail Map", 2D) = "white"{}

    }
    SubShader{
        Tags {"RenderType" = "Opaque"}
        
        CGPROGRAM
        #pragma surface surf Lambert
        
        sampler2D _MainTex;
        sampler2D _NormalMap;
        sampler2D _DetailMap;

        struct Input {
            float2 uv_MainTex;
            float3 worldPos;
        };
        
        void surf (Input IN, inout SurfaceOutput o){
            o.Normal = UnpackNormal(tex2D(_NormalMap, IN.uv_MainTex));
            // o.Albedo = tex2D(_MainTex, IN.uv_MainTex);
            fixed4 detailMap = tex2D(_DetailMap, IN.worldPos.zx * 10);
            o.Albedo = tex2D(_MainTex, IN.uv_MainTex) * detailMap;;

        }
        ENDCG
    }
    Fallback "Diffuse"
}