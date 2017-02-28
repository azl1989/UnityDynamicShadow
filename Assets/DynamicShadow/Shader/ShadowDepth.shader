Shader "DynamicShadow/ShadowDepth"
{
	Properties
	{

	}
	SubShader
	{
		Tags { "IGNOREPROJECTOR"="true" "RenderType"="Opaque" }
		LOD 100
		Cull Front
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			#pragma multi_compile __ DYNAMIC_SHADOW_USE_ARGB_DEPTH_TEXTURE

			struct appdata
			{
				float4 vertex : POSITION;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
			#ifdef DYNAMIC_SHADOW_USE_ARGB_DEPTH_TEXTURE
				float z : TEXCOORD0;
			#endif
			};
			
			v2f vert (appdata v)
			{
				v2f o;
				float4 viewPosition = mul(UNITY_MATRIX_MV, v.vertex);
				o.vertex = mul(UNITY_MATRIX_P, viewPosition);
			#ifdef DYNAMIC_SHADOW_USE_ARGB_DEPTH_TEXTURE
				o.z = -viewPosition.z * _ProjectionParams.w;
			#endif
				return o;
			}
			
			float4 frag (v2f i) : SV_Target
			{
			#ifdef DYNAMIC_SHADOW_USE_ARGB_DEPTH_TEXTURE
				return EncodeFloatRGBA(i.z);
			#else
				return float4(0, 0, 0, 0);
			#endif
			}
			ENDCG
		}
	}
}
