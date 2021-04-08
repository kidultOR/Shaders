	Shader "catlike/catlike_06_bump" {
	Properties {
		_Tint ("Tint", Color) = (1, 1, 1, 1)
		_MainTex ("Texture", 2D) = "white" {}
		[NoScaleOffset] _HeightMap ("Heights", 2D) = "gray" {}
		_Smoothness ("Smoothness", Range(0, 1)) = 0.5
		[Gamma] _Metallic ("Metallic", Range(0, 1)) = 0
	}
	
	SubShader{

		Pass {
			Tags {"LightMode" = "ForwardBase"}

			CGPROGRAM

			#pragma target 3.0

			#pragma multi_compile _ VERTEXLIGHT_ON

			#pragma vertex MyVertexProgram
			#pragma fragment MyFragmentProgram

			#define FORWARD_BASE_PASS

			#include "My Lighting 06 bump.cginc"

			ENDCG
		}

		Pass {
			Tags {"LightMode" = "ForwardAdd"}

			Blend one one
			ZWrite Off

			CGPROGRAM

			#pragma target 3.0

			#pragma multi_compile_fwdadd

			#pragma vertex MyVertexProgram
			#pragma fragment MyFragmentProgram

			#include "My Lighting 06 bump.cginc"
			
			ENDCG
		}
	}
}