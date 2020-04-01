Shader "#sbGameLab/Skin"{
    Properties{
        _Color ("Color", Color) = (1,1,1,1)
        _Color2("Color 2", Color) = (1,1,1,1)
        _SpecColor("Specular Color", Color) = (1,1,1,1)
        _Power("Power", Range(0,50)) = 10
        _SSSMap ("SSSMap", 2D) = "black"{}
    }
    SubShader{
        Tags{"RenderType" = "Opaque"}
        CGPROGRAM
        // #pragma surface surf SimpleSpecular
        #pragma surface surf Lambert

        float _Power;
        fixed4 _Color;
        fixed4 _Color2;
        // fixed4 _SpecColor;
        sampler2D _SSSMap;

        struct Input {
            float2 uv_SSSMap;
        };

        void surf(Input IN, inout SurfaceOutput o){
            fixed4 sssMap = tex2D(_SSSMap, IN.uv_SSSMap);
            // o.Albedo = sssMap;
            o.Albedo = _Color;
            o.Emission = pow(sssMap, _Power) * _Color;
        }

        half4 LightingSimpleSpecular (SurfaceOutput s, half3 lightDir, half3 viewDir, half atten) {
            // half3 h = normalize (lightDir + viewDir);
            // float nh = max (dot (s.Normal, h),0);
            // half diff = max (0, dot (s.Normal, lightDir));
            half fDiff = max (0, dot (s.Normal, lightDir));
            half bDiff = max (0, dot (s.Normal, -lightDir));
            half3 diff = pow((fDiff + bDiff), _Power) * _Color2;
            // half diff = max (0, dot (s.Normal, -lightDir));
            // float spec = pow (nh , 300 * s.Gloss) * s.Specular;
 
            half4 c;
            // c.rgb = (s.Albedo * _LightColor0.rgb * diff + _LightColor0.rgb * spec) * atten;
            c.rgb = diff;
            c.a = s.Alpha;
            return c;
        }
        ENDCG

    }
    Fallback "Diffuse"
}