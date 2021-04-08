// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "catlike/catlike_08_test01"
{
    Properties {
		_Tint ("Tint", Color) = (1, 1, 1, 1)
        _Rough ("Roughness", Range(0,1)) = 1.0
	}
    
    SubShader
    {
        Pass{
            Tags {"LightMode" = "ForwardBase"}

            CGPROGRAM
            
                #pragma vertex VertexProgram
                #pragma fragment FragmentProgram

                #include "UnityCG.cginc"
                #define UNITY_SPECCUBE_LOD_STEPS 3 // #include "UnityStandardConfig.cginc"

                struct VertexData
                {
                    float4 vertex : POSITION ;
                    float3 normalOS : NORMAL ;
                };

                float4 _Tint;
                float _Rough;

                struct FragmentData
                {
                    float4 pos : SV_POSITION ;
                    float4 posWS : POSITION2 ;
                    float3 normal : TEXCOORD0 ;
                    // float3 reflect : TEXCOORD1 ;
                };

                FragmentData VertexProgram (VertexData i)
                {
                    FragmentData o;
                    o.pos = UnityObjectToClipPos(i.vertex);
                    o.posWS = mul(unity_ObjectToWorld, i.vertex);
                    o.normal = UnityObjectToWorldNormal(i.normalOS);
                    return o;
                }

                float4 FragmentProgram ( FragmentData i) : SV_TARGET
                {
                    float3 viewDir = normalize(UnityWorldSpaceViewDir(i.posWS));
                    float3 reflectVector = reflect(-viewDir, i.normal);

                    // float4 envData = UNITY_SAMPLE_TEXCUBE(unity_SpecCube0, i.reflect);
                    float roughness =_Rough * (1.7 - 0.7 * _Rough);
                    float4 envData = UNITY_SAMPLE_TEXCUBE_LOD(unity_SpecCube0, reflectVector, roughness * UNITY_SPECCUBE_LOD_STEPS);
                    float3 envColor = DecodeHDR (envData, unity_SpecCube0_HDR);
                    
                    return float4(envColor,1);
                }

            ENDCG
        }
    
    }

}