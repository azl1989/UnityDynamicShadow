# UnityDynamicShadow
Unity Shadow Map Demo

##注意：<br>
####相机：<br>
		因为是平行光，所以使用 Orthographic 模式渲染。
####深度纹理：<br>
		RenderTextureFormat.Depth 优先选择
		RenderTextureFormat.ARGB Shader 开启 DYNAMIC_SHADOW_USE_ARGB_DEPTH_TEXTURE 
####阴影：<br>
		Shader 开启 DYNAMIC_SHADOW_USE_SOFT 会进行简单地边缘采样去。

##效果：<br>
![image](https://github.com/azl1989/UnityDynamicShadow/blob/master/effect.png)
