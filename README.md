# UnityDynamicShadow
Unity Shadow Map Demo

###注意：<br>
a) 因为是平行光，所以使用 Orthographic 模式渲染。<br>
b) RenderTexture 格式：<br>
		RenderTextureFormat.Depth 优先选择<br>
		RenderTextureFormat.ARGB 不支持 Depth 时选择，同时 Shader 需要开启 DYNAMIC_SHADOW_USE_ARGB_DEPTH_TEXTURE 关键字。<br>
c) 阴影锯齿，Shader 开启 DYNAMIC_SHADOW_USE_SOFT 会进行简单地边缘采样。<br>

<br>
###效果：<br>
![image](https://github.com/azl1989/UnityDynamicShadow/blob/master/effect.png)
