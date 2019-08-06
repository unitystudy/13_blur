Shader "Unlit/BLurShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_Radius("Radius", Range(0.00, 100.)) = 5.0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM

			#include "UnityCustomRenderTexture.cginc"
			#pragma vertex CustomRenderTextureVertexShader
			#pragma fragment frag


            sampler2D _MainTex;
			float4 _MainTex_TexelSize;
			float _Radius;

			fixed4 frag(v2f_customrendertexture i) : SV_Target
			{
				const float2 halton[8] = {
					float2(1.0 / 2.0 - 0.5, 1.0 / 3.0 - 0.5),
					float2(1.0 / 4.0 - 0.5, 2.0 / 3.0 - 0.5),
					float2(3.0 / 4.0 - 0.5, 1.0 / 9.0 - 0.5),
					float2(1.0 / 8.0 - 0.5, 4.0 / 9.0 - 0.5),
					float2(5.0 / 8.0 - 0.5, 7.0 / 9.0 - 0.5),
					float2(3.0 / 8.0 - 0.5, 2.0 / 9.0 - 0.5),
					float2(7.0 / 8.0 - 0.5, 5.0 / 9.0 - 0.5),
					float2(1.0 /16.0 - 0.5, 8.0 / 9.0 - 0.5),
				};

				float2 scale = _MainTex_TexelSize.xy * _Radius;

                // sample the texture
				fixed4 col = fixed4(0, 0, 0, 1);
				col += tex2D(_MainTex, i.globalTexcoord + halton[0] * scale);
				col += tex2D(_MainTex, i.globalTexcoord + halton[1] * scale);
				col += tex2D(_MainTex, i.globalTexcoord + halton[2] * scale);
				col += tex2D(_MainTex, i.globalTexcoord + halton[3] * scale);
				col += tex2D(_MainTex, i.globalTexcoord + halton[4] * scale);
				col += tex2D(_MainTex, i.globalTexcoord + halton[5] * scale);
				col += tex2D(_MainTex, i.globalTexcoord + halton[6] * scale);
				col += tex2D(_MainTex, i.globalTexcoord + halton[7] * scale);
				col /= 8.0;

				return col;
            }
            ENDCG
        }
    }
}