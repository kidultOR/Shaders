Shader "kORz/PackedPractice"
{
	Properties{
		_myColor ("Example color", Color) = (1,1,1,1)
	}

	SubShader{
		CGPROGRAM
			#pragma surface surf Lambert

			struct Input {
				float2 uvMainText;
			};

			fixed4 _myColor;

			void surf(Input IN, inout SurfaceOutput o) {
				o.Albedo = _myColor.rgb;
			}
		ENDCG
	}
		FallBack "Diffuse"
}