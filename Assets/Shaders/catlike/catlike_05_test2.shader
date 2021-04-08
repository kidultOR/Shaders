Shader "catlike/catlike_05_test01__Metalic"
{
    Properties {
		_Tint ("Tint", Color) = (1, 1, 1, 1)
		// _MainTex ("Texture", 2D) = "white" {}
		_Smoothness ("Smoothness", Range(0.01, 1)) = 0.5
		_Specular ("Specular", Range(0, 1)) = 0.5
		_SpecularColor ("Specular Color / Specular Value", Color) = (1,1,1,1)
		// [Gamma] _Metallic ("Metallic", Range(0, 1)) = 0
		_Metallic ("Metallic", Range(0, 1)) = 0
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
            float _Metallic;
            float4 _SpecularColor;

            struct FragmentData
            {
                float4 posCH : SV_POSITION ;
                float3 posWS : POSITION1 ;
                float3 normalWS : NORMAL ;
                float3 viewDir : NORMAL2 ;
            };

            FragmentData VertexProgram (VertexData i)
            {
                FragmentData o;
                o.posCH = UnityObjectToClipPos(i.posOS);
                o.posWS = UnityObjectToWorldDir(i.posOS);
                o.normalWS = UnityObjectToWorldNormal(i.normalOS);
                o.viewDir = UNITY_MATRIX_IT_MV[2].xyz;
                return o;
            }

            float4 FragmentProgram ( FragmentData i) : SV_TARGET
            {
                float3 normal = normalize(i.normalWS);
                float4 albedo = _Tint;
                float4 specularTint = _Metallic*albedo + (1-_Metallic)*_Specular*_SpecularColor;
                albedo = (1-_Metallic)*albedo;
                albedo = (1-_Specular*0.5+0.25)* albedo;
                float4 diffuse = saturate(dot(normal, _WorldSpaceLightPos0)) * albedo;
                float3 lightDir = _WorldSpaceLightPos0.xyz;
                // Blinn-Phong
                float3 halfVector = normalize(i.viewDir + lightDir);
                float specValue = saturate(dot(halfVector, normal));

                float4 spec = pow(specValue,_Smoothness * 300) * _LightColor0 * specularTint;

                return diffuse + spec;
            }

            ENDCG
        }
    }

}