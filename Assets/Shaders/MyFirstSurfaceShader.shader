Shader "kORz/MyFirstSurfaceShader"
{
	Properties{
		_myColor ("Example color", Color) = (1,1,1,1)
		_myEmission ("Emission", Color) = (1,1,1,1)
	}

	SubShader{
		CGPROGRAM
			#pragma surface surf Lambert

			struct Input {
				float2 uvMainText;
			};

			fixed4 _myColor;
			fixed4 _myEmission;

			void surf(Input IN, inout SurfaceOutput o) {
				o.Albedo = _myColor.rgb;
				o.Emission = _myEmission.rgb;
			}
		ENDCG
	}
		FallBack "Diffuse"
}