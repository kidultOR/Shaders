Shader "catlike/catlike_05_test01__BlinPhong"
{
    Properties {
		_Tint ("Tint", Color) = (1, 1, 1, 1)
		// _MainTex ("Texture", 2D) = "white" {}
		_Smoothness ("Smoothness", Range(0.01, 1)) = 0.5
		_SpecularColor ("Specular Color / Specular Value", Color) = (1,1,1,1)
		// [Gamma] _Metallic ("Metallic", Range(0, 1)) = 0
	}
    
    SubShader
    {
        Pass{
            Tags {"LightMode" = "ForwardBase"}

            CGPROGRAM
            
            #pragma vertex VertexProgram
            #pragma fragment FragmentProgram

            #include "UnityCG.cginc"
            #include "UnityLightingCommon.cginc"

            struct VertexData
            {
                float4 posOS : POSITION ;
                float3 normalOS : NORMAL ;
            };

            float4 _Tint;
            float _Smoothness;
            // float _Specular;
            float4 _SpecularColor;

            struct FragmentData
            {
                float4 posCH : SV_POSITION ;
                float3 posWS : POSITION1 ;
                float3 normalWS : NORMAL ;
            };

            FragmentData VertexProgram (VertexData i)
            {
                FragmentData o;
                o.posCH = UnityObjectToClipPos(i.posOS);
                o.posWS = UnityObjectToWorldDir(i.posOS);
                o.normalWS = UnityObjectToWorldNormal(i.normalOS);
                return o;
            }

            float4 FragmentProgram ( FragmentData i) : SV_TARGET
            {
                float3 normal = normalize(i.normalWS);
                float3 viewDir = UNITY_MATRIX_IT_MV[2].xyz;
                float4 diffuse = saturate(dot(normal, _WorldSpaceLightPos0))*_Tint;
                diffuse = diffuse * (1-_SpecularColor.a * 0.5 + 0.25) ;
                float3 lightDir = _WorldSpaceLightPos0.xyz;
                // Blinn-Phong
                float3 halfVector = normalize(viewDir + lightDir);
                float specValue = saturate(dot(halfVector, normal));
                float4 spec = pow(specValue,_Smoothness * 100) * _LightColor0 * _SpecularColor.a *_SpecularColor;


                return diffuse + spec;
            }

            ENDCG
        }
    }

}