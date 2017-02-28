Shader "DynamicShadow/ShadowReceiver"
{
	Properties
	{
		_Color ("Main Color", Color) = (1,1,1,1)
		_ShadowColor ("Shadow Color", Color) = (0,0,0,1)
	}
	SubShader
	{
		Tags { "IGNOREPROJECTOR"="true" "RenderType"="Opaque" }
		LOD 100
		Cull Back
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			#pragma multi_compile DYNAMIC_SHADOW_USE_ARGB_DEPTH_TEXTURE
			#pragma multi_compile DYNAMIC_SHADOW_USE_SOFT

			struct appdata
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float4 uv : TEXCOORD0;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float3 normal : TEXCOORD0;
				float4 shadowCoord : TEXCOORD1;
				float3 lightDir : TEXCOORD2;
			};

			float4 _Color;
			float4 _ShadowColor;
			float _DynamicShadowSize;
			float4x4 _DynamicShadowMatrix;
			float4 _DynamicShadowParam;
			sampler2D _DynamicShadowTexture;

			v2f vert (appdata v)
			{
				v2f o;
				float4 worldPosition = mul(UNITY_MATRIX_M, v.vertex);
				o.vertex = mul(UNITY_MATRIX_VP, worldPosition);
				o.normal = UnityObjectToWorldNormal(v.normal);
				o.shadowCoord = mul(_DynamicShadowMatrix, worldPosition);
				o.shadowCoord.xyz = o.shadowCoord.xyz / o.shadowCoord.w * 0.5 + 0.5;
				o.lightDir = normalize(-_DynamicShadowParam.xyz);
				return o;
			}

			#ifdef DYNAMIC_SHADOW_USE_ARGB_DEPTH_TEXTURE
				#define _DecodeFloatRGBA DecodeFloatRGBA
			#else
				#define _DecodeFloatRGBA(z) z
			#endif
			
			fixed4 frag (v2f i) : SV_Target
			{
				float nl = max(0, dot(i.normal, i.lightDir));
				float v = 1;
			#ifdef DYNAMIC_SHADOW_USE_SOFT
				float size = _DynamicShadowSize / 2;
				v -= step(_DecodeFloatRGBA(tex2D(_DynamicShadowTexture, i.shadowCoord.xy + float2(-0.94201624, -0.39906216) / size)), i.shadowCoord.z /*- bias*/) * 0.2;
				v -= step(_DecodeFloatRGBA(tex2D(_DynamicShadowTexture, i.shadowCoord.xy + float2( 0.94201624, -0.76890725) / size)).r, i.shadowCoord.z /*- bias*/) * 0.2;
				v -= step(_DecodeFloatRGBA(tex2D(_DynamicShadowTexture, i.shadowCoord.xy + float2(-0.09418410, -0.92938870) / size)).r, i.shadowCoord.z /*- bias*/) * 0.2;
				v -= step(_DecodeFloatRGBA(tex2D(_DynamicShadowTexture, i.shadowCoord.xy + float2( 0.34495938,  0.29387760) / size)).r, i.shadowCoord.z /*- bias*/) * 0.2;
			#else
				v -= step(_DecodeFloatRGBA(tex2D(_DynamicShadowTexture, i.shadowCoord.xy)), i.shadowCoord.z /*- bias*/);
			#endif
				float4 c = lerp(lerp(_Color * nl, _ShadowColor, 1 - v), _ShadowColor, step(v, 0.5));
				c += _Color * 0.25;
				return c;
			}
			ENDCG
		}
	}
}
