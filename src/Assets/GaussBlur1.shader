Shader "Unlit/GaussBlur1"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_Radius("Radius", Range(0.00, 10.)) = 1.0
	}
	SubShader
	{
		Tags { "RenderType" = "Opaque" }
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
				float2 scale = float2(_MainTex_TexelSize.x, 0) * _Radius;

				// sample the texture
				fixed4 col = tex2D(_MainTex, i.globalTexcoord);
				float weight = 1.0;
				float w;
				const float S2 = 1.0 / 50.0;
				w = exp(-0.5 * 1.5 * 1.5 * S2);// 0.88249690258
				col += w * tex2D(_MainTex, i.globalTexcoord + 1.5 * scale);
				col += w * tex2D(_MainTex, i.globalTexcoord - 1.5 * scale);
				weight += 2.0 * w;
				w = exp(-0.5 * 3.5 * 3.5 * S2);// 0.32465246735
				col += w * tex2D(_MainTex, i.globalTexcoord + 3.5 * scale);
				col += w * tex2D(_MainTex, i.globalTexcoord - 3.5 * scale);
				weight += 2.0 * w;
				w = exp(-0.5 * 5.5 * 5.5 * S2);// 0.04393693362
				col += w * tex2D(_MainTex, i.globalTexcoord + 5.5 * scale);
				col += w * tex2D(_MainTex, i.globalTexcoord - 5.5 * scale);
				weight += 2.0 * w;
				w = exp(-0.5 * 7.5 * 7.5 * S2);// 0.04393693362
				col += w * tex2D(_MainTex, i.globalTexcoord + 7.5 * scale);
				col += w * tex2D(_MainTex, i.globalTexcoord - 7.5 * scale);
				weight += 2.0 * w;
				w = exp(-0.5 * 9.5 * 9.5 * S2);// 0.04393693362
				col += w * tex2D(_MainTex, i.globalTexcoord + 9.5 * scale);
				col += w * tex2D(_MainTex, i.globalTexcoord - 9.5 * scale);
				weight += 2.0 * w;

				col /= weight;

				return col;
			}
			ENDCG
		}
	}
}