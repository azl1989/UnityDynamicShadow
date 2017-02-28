# UnityDynamicShadow
Unity Shadow Map Demo

![image](https://github.com/azl1989/UnityDynamicShadow/blob/master/effect.png)

注意：
	a) 因为是平行光，所以使用 Orthographic 模式渲染。
	b) RenderTexture 格式：
		若运行平台不支持 RenderTextureFormat.Depth，则使用RenderTextureFormat.ARGB 代替，同时 Shader 开启 DYNAMIC_SHADOW_USE_ARGB_DEPTH_TEXTURE 关键字。
	c) 阴影锯齿，Shader 开启 DYNAMIC_SHADOW_USE_SOFT 会进行简单地边缘采样。
