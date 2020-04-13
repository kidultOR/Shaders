Shader "temp/UnityShader_v04_VertexMod"{
    Properties{
        _MainTex ("Main Texture", 2D) = "gray"{}
        _NormalMap ("Normal Map", 2D) = "bump"{}
        _Amount ("Amount", Range(0, 0.01)) = 0
    }
    SubShader{
        Tags {"RenderType" = "Opaque"}
        
        CGPROGRAM
        #pragma surface surf Lambert vertex:vert
        
        sampler2D _MainTex;
        sampler2D _NormalMap;
        float _Amount;
        
        struct Input {
            float2 uv_MainTex;
        };
        
        void vert (inout appdata_full v) {
          v.vertex.xyz += v.normal * _Amount;
        }
        
        void surf (Input IN, inout SurfaceOutput o){
            o.Normal = UnpackNormal(tex2D(_NormalMap, IN.uv_MainTex));
            o.Albedo = tex2D(_MainTex, IN.uv_MainTex);
        }
        ENDCG
    }
    Fallback "Diffuse"
}