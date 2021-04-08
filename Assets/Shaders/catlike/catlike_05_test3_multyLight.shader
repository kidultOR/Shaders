Shader "catlike/catlike_05_test3_multyLight"
{
    Properties {
		_Tint ("Tint", Color) = (1, 1, 1, 1)
		_Smoothness ("Smoothness", Range(0.01, 1)) = 0.5
		_Specular ("Specular", Range(0, 1)) = 0.5
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
            float _Specular;
            float4 _SpecularColor;

            struct FragmentData
            {
                float4 posCH : SV_POSITION ;
                float4 posWS : POSITION1 ;
                float3 normalWS : NORMAL ;
                float3 viewDir : NORMAL2 ;
            };

            FragmentData VertexProgram (VertexData i)
            {
                FragmentData o;
                o.posCH = UnityObjectToClipPos(i.posOS);
                o.posWS = mul(unity_ObjectToWorld, i.posOS);
                o.normalWS = UnityObjectToWorldNormal(i.normalOS);
                o.viewDir = UNITY_MATRIX_IT_MV[2].xyz;
                return o;
            }

            float4 FragmentProgram ( FragmentData i) : SV_TARGET
            {
                float3 normal = normalize(i.normalWS);
                float4 albedo = _Tint;
                float4 specularTint = _Specular * _SpecularColor;
                float3 lightDir = _WorldSpaceLightPos0.xyz;
                float4 diffuse = saturate(dot(normal, lightDir)) * albedo;
                diffuse *= _LightColor0;

                // Blinn-Phong
                float3 halfVector = normalize(i.viewDir + lightDir);
                float specValue = saturate(dot(halfVector, normal));

                float4 spec = pow(specValue,_Smoothness * 300) * _LightColor0 * specularTint;

                return diffuse + spec;
            }

            ENDCG
        }
        
        Pass
        {
            Tags {"LightMode" = "ForwardAdd"}

            Blend one one
			ZWrite Off

            CGPROGRAM
            
            #pragma vertex VertexProgram
            #pragma fragment FragmentProgram


            #pragma multi_compile_fwdadd

            #include "UnityCG.cginc"
            #include "UnityLightingCommon.cginc"
            #include "AutoLight.cginc"

            float4 _Tint;
            float _Smoothness;
            float _Specular;
            float _Metallic;
            float4 _SpecularColor;
            
            struct VertexData
            {
                float4 posOS : POSITION ;
                float3 normalOS : NORMAL ;
            };

            struct FragmentData
            {
                float4 posCH : SV_POSITION ;
                float4 posWS : POSITION1 ;
                float3 normalWS : NORMAL ;
                float3 viewDir : NORMAL2 ;
            };

            FragmentData VertexProgram (VertexData i)
            {
                FragmentData o;
                o.posCH = UnityObjectToClipPos(i.posOS);
                o.posWS = mul(unity_ObjectToWorld, i.posOS);
                o.normalWS = UnityObjectToWorldNormal(i.normalOS);
                o.viewDir = normalize(_WorldSpaceCameraPos - o.posWS.xyz);
                return o;
            }

            float4 FragmentProgram ( FragmentData i) : SV_TARGET
            {
                float3 normal = normalize(i.normalWS);
                float4 albedo = _Tint;
                float4 specularTint = _Specular * _SpecularColor;
                float4 lightDir = _WorldSpaceLightPos0 - i.posWS;
                float4 diffuse = saturate(dot(normal, normalize(lightDir))) * albedo;
                diffuse *= _LightColor0;

                UNITY_LIGHT_ATTENUATION(attenuation, 0, i.posWS.xyz);

                float3 halfVector = normalize(normalize(i.viewDir) + normalize(lightDir));
                float specValue = saturate(dot(halfVector, normal));

                float4 spec = pow(specValue,_Smoothness * 300) * _LightColor0 * specularTint;

                return (diffuse + spec)*attenuation;
            }

            ENDCG

        }
        
    }

}
// (1.529, -2.791, 0.42, 1)
// (-0.98, -1.582, 3.062, 1)