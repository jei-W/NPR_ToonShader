Shader "Custom/ToonShader_rimline_Surf"
{
    Properties
    {
		_MainTex ("Albedo", 2D) = "white" {}
		_BumpMap ("Normal", 2D) = "bump" {}
		_ShadowLevel ("Shadow Level", Range(1, 5)) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Toon

		sampler2D _MainTex;
		sampler2D _BumpMap;
		half _ShadowLevel;

        struct Input
        {
            float2 uv_MainTex;
			float2 uv_BumpMap;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
			fixed4 c = tex2D(_MainTex, IN.uv_MainTex);

			o.Albedo = c.rgb;
			o.Alpha = c.a;
			o.Normal = UnpackNormal( tex2D(_BumpMap, IN.uv_BumpMap) );
        }

		fixed4 LightingToon (SurfaceOutput s, float3 lightDir, float3 viewDir, float atten)
		{
			// Rim for OutLine
			float rim = saturate( dot(s.Normal, viewDir) );
			rim = rim < 0.3 ? -1 : 1;

			// Toon Shading used Lambert
			float ndotl = saturate( dot(s.Normal, lightDir) );
			ndotl = ceil(ndotl * _ShadowLevel) / _ShadowLevel;

			fixed4 result;
			result.rgb = s.Albedo * ndotl * rim;
			result.a = s.Alpha;

			return result;
		}
        ENDCG
    }
    FallBack "Diffuse"
}
