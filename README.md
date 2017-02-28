# UnityDynamicShadow
Unity Shadow Map Demo

###注意：<br>
a) 平行光：相机使用 Orthographic 模式渲染。<br>
b) 深度纹理格式：<br>
        RenderTextureFormat.Depth 优先选择<br>
        RenderTextureFormat.ARGB Shader 开启 DYNAMIC_SHADOW_USE_ARGB_DEPTH_TEXTURE <br>
c) 阴影锯齿： Shader 开启 DYNAMIC_SHADOW_USE_SOFT 会进行简单地边缘采样。<br>

<br>
###效果：<br>
![image](https://github.com/azl1989/UnityDynamicShadow/blob/master/effect.png)
