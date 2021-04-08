// Transparancy

Shader "catlike/catlike_11_" {
	Properties {
		_Tint ("Tint", Color) = (1, 1, 1, 1)
		_MainTex ("Albedo", 2D) = "white" {}
		[NoScaleOffset] _NormalMap ("Normal", 2D) = "bump" {}
		_BumpScale ("Bump Scale", Float) = 1
		[NoScaleOffset] _MetallicMap ("Metallic Map", 2D) = "white" {}
		[Gamma] _Metallic ("Metallic", Range(0, 1)) = 0
		_Smoothness ("Smoothness", Range(0, 1)) = 0.5
		_DetailTex ("Detail Albedo", 2D) = "gray" {}
		[NoScaleOffset] _DetailNormalMap ("Detail Normals", 2D) = "bump" {}
		_DetailBumpScale ("Detail Bump Scale", Float) = 1
		[NoScaleOffset] _EmissionMap ("Emission Map", 2D) = "black" {}
		_Emission ("Emission", Color) = (0,0,0)
		[NoScaleOffset] _OcclusionMap ("Occlusion Map", 2D) = "black" {}
		_OcclusionStrength("Occlusion Strength", Range(0, 1)) = 1
		[NoScaleOffset] _DetailMask ("Detail Mask", 2D) = "white" {}
		_AlphaCutoff ("Alpha Cutoff", Range(0, 1)) = 0.5
	}

	CGINCLUDE
		#define BINORMAL_PER_FRAGMENT
	ENDCG
	
	SubShader{

		Pass {
			Tags {"LightMode" = "ForwardBase"}

			CGPROGRAM

			#pragma target 3.0

			#pragma shader_feature _RENDERING_CUTOUT
			#pragma shader_feature _METALLIC_MAP
			#pragma shader_feature _ _SMOOTHNESS_ALBEDO _SMOOTHNESS_METALLIC
			#pragma shader_feature _NORMAL_MAP
			#pragma shader_feature _EMISSION_MAP
			#pragma shader_feature _OCCLUSION_MAP
			#pragma shader_feature _DETAIL_MASK
			#pragma shader_feature _DETAIL_ALBEDO_MAP
			#pragma shader_feature _DETAIL_NORMAL_MAP

			#pragma multi_compile _ SHADOWS_SCREEN
			#pragma multi_compile _ VERTEXLIGHT_ON

			#pragma vertex MyVertexProgram
			#pragma fragment MyFragmentProgram

			#define FORWARD_BASE_PASS

			#include "My Lighting 11.cginc"

			ENDCG
		}

		Pass {
			Tags {"LightMode" = "ForwardAdd"}

			Blend one one
			ZWrite Off

			CGPROGRAM

			#pragma target 3.0

			#pragma shader_feature _RENDERING_CUTOUT
			#pragma shader_feature _METALLIC_MAP
			#pragma shader_feature _ _SMOOTHNESS_ALBEDO _SMOOTHNESS_METALLIC
			#pragma shader_feature _NORMAL_MAP
			#pragma shader_feature _DETAIL_ALBEDO_MAP
			#pragma shader_feature _DETAIL_NORMAL_MAP

			#pragma multi_compile_fwdadd_fullshadows

			#pragma vertex MyVertexProgram
			#pragma fragment MyFragmentProgram

			#include "My Lighting 11.cginc"
			
			ENDCG
		}

		Pass {
			Tags {"LightMode" = "ShadowCaster"}

			CGPROGRAM

			#pragma target 3.0

			#pragma multi_compile_shadowcaster

			#pragma vertex MyShadowVertexProgram
			#pragma fragment MyShadowFragmentProgram

			#include "My Shadows.cginc"

			ENDCG
		}
	}
	CustomEditor "MyLightingShaderGUI_11_"
}