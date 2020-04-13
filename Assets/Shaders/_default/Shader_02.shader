Shader "kORz/Shader_02"
{
	Properties
	{
		_Albedo("Albedo", 2D) = "gray"{}
		_Normal("Normal", 2D) = "bump"{}
		_Specular("Specular", Range(0,1)) = 0.5
	}

		SubShader
	{
		CGPROGRAM
		#pragma surface surf Lambert

		sampler2D _Albedo;
		sampler2D _Normal;
		half _Specular;

		struct Input 
		{
			float2 uv_Albedo;
		};
		
		void surf(Input IN, inout SurfaceOutput o) 
		{
			fixed4 map2 = tex2D(_Normal, IN.uv_Albedo);

			o.Albedo = tex2D(_Albedo, IN.uv_Albedo);
			//o.Normal = UnpackNormal(fixed4(map2.r, map2.g, 1,1));
			o.Normal = UnpackNormal(map2);
			
		}

		ENDCG
	}
	FallBack "Diffuse"

}