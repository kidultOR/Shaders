Shader "kORz/PBR_StandartCutout"
{
	Properties
	{
		_MainMap("Main Map", 2D) = "gray"{}
		_Cutout("Cutout", Range(0,1)) = 0.5
	}

		SubShader
	{
		Tags {
			"Queue" = "AlphaTest" // ?
			"RenderType" = "TransparentCutout"
			"IgnoreProjector" = "True"
		}
		Cull Off

		CGPROGRAM
		#pragma surface surf Standard alphatest:_Cutout

		sampler2D _MainMap;
		
		struct Input
		{
			float2 uv_MainMap;
		};

		void surf(Input IN, inout SurfaceOutputStandard o)
		{
			fixed4 mainMap = tex2D(_MainMap, IN.uv_MainMap);
			o.Albedo = mainMap.rgb;
			o.Alpha = mainMap.a;
		}

		ENDCG
	}
	Fallback "Diffuse"
}