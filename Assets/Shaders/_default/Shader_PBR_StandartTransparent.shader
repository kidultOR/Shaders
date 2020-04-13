Shader "kORz/PBR_StandartTransparent"
{
	Properties
	{
		_MainMap("Main Map", 2D) = "gray"{}
	}

		SubShader
	{
		Tags {
			"Queue" = "Transparent"
			"RenderType" = "Transparent"
			"IgnoreProjector" = "True"
		}
		Cull Off

		CGPROGRAM
		#pragma surface surf Standard alpha

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