Shader "catlike/catlike_04_My First Lighting Shader_Phong " {
	Properties {
		_Tint ("Tint", Color) = (1, 1, 1, 1)
		_MainTex ("Texture", 2D) = "white" {}
		_Smoothness ("Smoothness", Range(0, 1)) = 0.5
	}
	
	SubShader{

		Pass {
			Tags {
				"LightMode" = "ForwardBase"
			}

			CGPROGRAM

			#pragma vertex MyVertexProgram
			#pragma fragment MyFragmentProgram

			#include "UnityCG.cginc"
			#include "UnityStandardBRDF.cginc"

			float4 _Tint;
			sampler2D _MainTex;
			float4 _MainTex_ST;
			float _Smoothness;

			struct VertexData{
				float4 position : POSITION;
				float3 normal : NORMAL;
				float2 uv : TEXCOORD0;
			};

			struct Interpolators {
				float4 position : SV_POSITION;
				float3 normal : NORMAL;
				float2 uv : TEXCOORD0;
				float4 worldPos : POSITION1;
			};

			Interpolators MyVertexProgram(VertexData v) 
			{
				Interpolators i;
				i.position = UnityObjectToClipPos(v.position);
				i.normal = UnityObjectToWorldNormal(v.normal);
				i.uv = TRANSFORM_TEX(v.uv, _MainTex);
				i.worldPos = mul(unity_ObjectToWorld, v.position);
				return i;
			}

			float4 MyFragmentProgram(Interpolators i) : SV_TARGET
			{
				i.normal = normalize(i.normal);
				float3 lightDir = _WorldSpaceLightPos0.xyz;
				float3 lightColor = _LightColor0.rgb;
				float3 viewDir = normalize(_WorldSpaceCameraPos - i.worldPos);
				float3 albedo = tex2D(_MainTex, i.uv).rgb * _Tint.rgb;
				float3 diffuse = albedo * lightColor * DotClamped(lightDir, i.normal);
				float3 reflectionDir = reflect(-lightDir, i.normal);
				return pow(DotClamped(viewDir, reflectionDir), _Smoothness*100);
			}

			ENDCG
		}
	}
}