// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "catlike/catlike_07_test01"
{
    Properties {
		_Tint ("Tint", Color) = (1, 1, 1, 1)
	}
    
    SubShader
    {
        Pass{
            Tags {"LightMode" = "ForwardBase"}

            CGPROGRAM
            
                #pragma vertex VertexProgram
                #pragma fragment FragmentProgram

                #pragma multi_compile_fwdbase

                #include "UnityCG.cginc"
                #include "AutoLight.cginc"
                #include "Lighting.cginc"
                #include "UnityLightingCommon.cginc"

                struct VertexData
                {
                    float4 vertex : POSITION ;
                    float3 normalOS : NORMAL ;
                };

                float4 _Tint;

                struct FragmentData
                {
                    float4 pos : SV_POSITION ;
                    float3 posWS : POSITION1 ;
                    float3 normalWS : NORMAL ;
                    SHADOW_COORDS(5)
                };

                FragmentData VertexProgram (VertexData i)
                {
                    FragmentData o;
                    o.pos = UnityObjectToClipPos(i.vertex);
                    o.posWS = UnityObjectToWorldDir(i.vertex);
                    o.normalWS = UnityObjectToWorldNormal(i.normalOS);
                    TRANSFER_SHADOW(o);
                    return o;
                }

                float4 FragmentProgram ( FragmentData i) : SV_TARGET
                {
                    float3 normal = normalize(i.normalWS);
                    float4 diffuse = saturate(dot(normal, _WorldSpaceLightPos0))*_Tint;
                    UNITY_LIGHT_ATTENUATION(attenuation, i, i.posWS);
                    return diffuse * attenuation;
                }

            ENDCG
        }

        Pass {
			Tags {"LightMode" = "ShadowCaster"}

            CGPROGRAM

			#include "UnityCG.cginc"

            #pragma vertex MyShadowVertexProgram
			#pragma fragment MyShadowFragmentProgram

            struct VertexData
            {
                float4 position: POSITION;
            };

            float4 MyShadowVertexProgram (VertexData v) : SV_POSITION
            {
                float4 position = UnityObjectToClipPos(v.position); 
                return UnityApplyLinearShadowBias(position);
            }

            half4 MyShadowFragmentProgram () : SV_TARGET {
                return 0;
            }
            ENDCG  
		}
    }

}