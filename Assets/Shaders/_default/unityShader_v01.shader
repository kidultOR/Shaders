Shader "temp/UnityShader_v01"{
    Properties{
        _MainTex ("Main Texture", 2D) = "gray"{}
        _NormalMap ("Normal Map", 2D) = "bump"{}

        _RimColor ("Rim Color", Color) = (1,1,1,1)
        _RimPow ("Rim Power", Range(0.5,10)) = 3

        _DetailMap("Detail Map", 2D) = "white" {}
    }
    SubShader{
        Tags {"RenderType" = "Opaque"}
        
        CGPROGRAM
        #pragma surface surf Lambert
        
        sampler2D _MainTex;
        sampler2D _NormalMap;
        fixed4 _RimColor;
        float _RimPow;
        sampler2D _DetailMap;

        struct Input {
            float2 uv_MainTex;
            float3 viewDir;
            float2 uv_DetailMap;
            float4 screenPos;
        };
        
        void surf (Input IN, inout SurfaceOutput o){
            o.Normal = UnpackNormal(tex2D(_NormalMap, IN.uv_MainTex));

            // half rim = 1 - saturate(dot(normalize(IN.viewDir), o.Normal));
            // o.Emission = _RimColor * pow(rim, _RimPow);
            
            float2 uvScreen = IN.screenPos.xy / IN.screenPos.w * 10;
            fixed4 detailMap = tex2D(_DetailMap, uvScreen);
            o.Albedo = tex2D(_MainTex, IN.uv_MainTex) * detailMap;
        }
        ENDCG
    }
    Fallback "Diffuse"
}