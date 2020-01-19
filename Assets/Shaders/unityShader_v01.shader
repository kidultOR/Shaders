Shader "temp/UnityShader_v01"{
    Properties{
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Main Texture", 2D) = "gray"{}
        _NormalMap ("Normal Map", 2D) = "bump"{}
        _RimColor ("Rim Color", Color) = (1,1,1,1)
        _RimPow ("Rim Power", Range(0.5,10)) = 3

        _DetailMap ("Ditail Map", 2D) = "white"{} 
        _DetailPow ("Detail Power", Range(0,10)) = 1
    }
    SubShader{
        Tags {"RenderType" = "Opaque"}
        
        CGPROGRAM
        #pragma surface surf Lambert
        
        fixed4 _Color;
        sampler2D _MainTex;
        sampler2D _NormalMap;
        fixed4 _RimColor;
        float _RimPow;
        sampler2D _DetailMap;
        float _DetailPow;

        struct Input {
            float2 uv_MainTex;
            float2 uv_DetailMap;
            float3 viewDir;
        };
        
        void surf (Input IN, inout SurfaceOutput o){
            fixed3 detail = tex2D(_DetailMap, IN.uv_DetailMap);
            o.Albedo = tex2D(_MainTex, IN.uv_MainTex) * detail;
            o.Normal = UnpackNormal(tex2D(_NormalMap, IN.uv_MainTex));
            half rim = 1- saturate(dot(normalize(IN.viewDir), o.Normal));
            o.Emission = _RimColor * pow(rim, _RimPow);
        }
        ENDCG
    }
    Fallback "Diffuse"
}