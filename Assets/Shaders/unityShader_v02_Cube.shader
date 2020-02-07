Shader "temp/UnityShader_v02_Cube"{
    Properties{
        _MainTex ("Main Texture", 2D) = "gray"{}
        _NormalMap ("Normal Map", 2D) = "bump"{}

        _cubeMap ("Cube Map", Cube) = ""{}
    }
    SubShader{
        Tags {"RenderType" = "Opaque"}
        
        CGPROGRAM
        #pragma surface surf Lambert
        
        sampler2D _MainTex;
        sampler2D _NormalMap;
        samplerCUBE _cubeMap;

        struct Input {
            float2 uv_MainTex;
            float3 viewDir;
            float3 worldRefl; INTERNAL_DATA
        };
        
        void surf (Input IN, inout SurfaceOutput o){
            o.Normal = UnpackNormal(tex2D(_NormalMap, IN.uv_MainTex));
            
            o.Albedo = tex2D(_MainTex, IN.uv_MainTex);
            // o.Emission = texCUBE( _cubeMap, IN.worldRefl);
            o.Emission = texCUBE(_cubeMap, WorldReflectionVector (IN, o.Normal)).rgb;
        }
        ENDCG
    }
    Fallback "Diffuse"
}