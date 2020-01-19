Shader "kORz/Shader_01" {
	
	Properties{
		_myColor("Albedo", Color) = (0.5,0.5,0.5,0.5)
		_mask("Mask", 2D) = "white"{}
		_tex1("Texture 1 R", 2D) = "white"{}
		_tex2("Texture 2 G", 2D) = "white"{}
		_tex3("Texture 3 B", 2D) = "white"{}
		_emMask("Emission Mask", 2D) = "white"{}
		_emValue("Emission Value", Range(0,1)) = 1
	}

	SubShader
	{
		CGPROGRAM

		#pragma surface surf Lambert

		fixed4 _myColor;
		sampler2D _mask;
		sampler2D _tex1;
		sampler2D _tex2;
		sampler2D _tex3;
		sampler2D _emMask;
		fixed _emValue;
		
		struct Input 
		{
			float2 uv_mask;
			float2 uv_tex1;
			float2 uv_tex2;
			float2 uv_tex3;
		};
		
		void surf (Input IN, inout SurfaceOutput o)
		{
			fixed3 mask = tex2D(_mask, IN.uv_mask);
			fixed3 tex1 = tex2D(_tex1, IN.uv_tex1);
			fixed3 tex2 = tex2D(_tex2, IN.uv_tex2);
			fixed3 tex3 = tex2D(_tex3, IN.uv_tex3);
			fixed3 emMask = tex2D(_emMask, IN.uv_mask);

			o.Albedo = (tex1 * mask.r) + (tex2 * mask.g) + (tex3 * mask.b);

			half apMask = 1- emMask.b;
			apMask = 1 - smoothstep( _emValue * 1.5 - 0.5 , _emValue * 1.5 , apMask );
			o.Emission = apMask * emMask.r * _myColor;
			//o.Emission = apMask;
		}

		ENDCG
	}
	
	Fallback "Diffuse"
}