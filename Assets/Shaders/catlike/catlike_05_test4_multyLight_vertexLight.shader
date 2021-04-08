Shader "catlike/catlike_05_test4_multyLight_vertexLight"
{
    Properties {
		_Tint ("Tint", Color) = (1, 1, 1, 1)
		_Smoothness ("Smoothness", Range(0.01, 1)) = 0.5
		_Specular ("Specular", Range(0, 1)) = 0.5
		_SpecularColor ("Specular Color / Specular Value", Color) = (1,1,1,1)
	}
    
    SubShader
    {
        Pass{
            Tags {"LightMode" = "ForwardBase"}

            CGPROGRAM
            
            #include "UnityCG.cginc"
            #include "UnityLightingCommon.cginc"

            #pragma vertex VertexProgram
            #pragma fragment FragmentProgram

            #pragma multi_compile _ VERTEXLIGHT_ON
            // #pragma shader_feature VERTEXLIGHT_ON

            float4 _Tint;
            float _Smoothness;
            float _Specular;
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
                #ifdef VERTEXLIGHT_ON
                    float3 vertexLightColor : COLOR;
                #endif
            };

            void ComputeVertexLightColor (inout FragmentData i) 
            {
                #ifdef VERTEXLIGHT_ON
                    // i.vertexLightColor = unity_LightColor[1];
                    i.vertexLightColor = Shade4PointLights(
                                                unity_4LightPosX0, unity_4LightPosY0, unity_4LightPosZ0,
                                                unity_LightColor[0].rgb, unity_LightColor[1].rgb,unity_LightColor[2].rgb, unity_LightColor[3].rgb,
                                                unity_4LightAtten0, i.posWS, i.normalWS
                                		);
                #endif
            }

            FragmentData VertexProgram (VertexData i)
            {
                FragmentData o;
                o.posCH = UnityObjectToClipPos(i.posOS);
                o.posWS = mul(unity_ObjectToWorld, i.posOS);
                o.normalWS = UnityObjectToWorldNormal(i.normalOS);
                o.viewDir = UNITY_MATRIX_IT_MV[2].xyz;
                ComputeVertexLightColor(o);
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

                #ifdef VERTEXLIGHT_ON
                    diffuse += float4(i.vertexLightColor,1);
                #endif
                return diffuse + spec;
            }

            ENDCG
        }
    }
}