Shader "kORz/PBR_Standart"
{
	Properties
	{
		_Albedo("Albedo", Color) = (0.5,0.5,0.5,1)
		_Metallic("Metallic", Range(0,1)) = 0.5
		_Smoothness("Smoothness", Range(0,1)) = 0.5
		//_AlbedoMap("Albedo Map", 2D) = "gray"{}
	}

		SubShader
	{
		CGPROGRAM
		#pragma surface surf Standard

		fixed4 _Albedo;
		half _Metallic;
		half _Smoothness;

		//sampler2D _AlbedoMap;
		
		struct Input
		{
			float2 uv_AlbedoMap;
		};

		void surf(Input IN, inout SurfaceOutputStandard o)
		{
			//o.Albedo = tex2D(_AlbedoMap, IN.uv_AlbedoMap);
			o.Albedo = _Albedo;
			o.Metallic = _Metallic;
			o.Smoothness = _Smoothness;
		}

		ENDCG
	}
	Fallback "Diffuse"
}