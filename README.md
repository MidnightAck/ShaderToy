# MyShaderLAB

一个用来记录各种shader学习过程的repo，其中包括shadertoy、一些书籍、youtube视频里的各种各样的shader，在unity中进行复现。

#### Table of Contents

- [Graphic](#Graphic)
- [Random](#ShaderToy)
- [NPR](#NPR)
- [About](#About)

## Graphic
在shader之前应该首先学习图形学，这一部分记录了自己整理的图形学中的概念与学习心得。
- [渲染管线](https://crowfeablog.com/2019/11/27/%E6%B8%B2%E6%9F%93%E7%AE%A1%E7%BA%BF/)
- [自己动手写Ray Tracer](https://crowfeablog.com/2019/07/31/%E8%87%AA%E5%B7%B1%E5%8A%A8%E6%89%8B%E5%86%99Ray%20Tracer/)
- [Ray Tracing简介](https://crowfeablog.com/2019/07/26/Ray%20Tracing%E7%AE%80%E4%BB%8B/)
- [Raster Image简介](https://crowfeablog.com/2019/07/18/Raster%20Image%E7%AE%80%E4%BB%8B/)

## Basic
这一部分是shader中的一些基本方法，包括造型函数、颜色、一些基本光照的实现等。

### Circle
![img](https://media.giphy.com/media/SXxufjP5dWzcn8Pv8F/giphy.gif)

这一部分是关于圆的造型函数，关于圆的生成、反锯齿、blend等内容。
博客链接[造型函数丨圆](https://crowfeablog.com/2019/11/19/%E9%80%A0%E5%9E%8B%E5%87%BD%E6%95%B0%E4%B8%A8%E5%9C%86/)

### 调色盘
因此可以用以下的方程产生调色盘
博客链接[调色盘](https://crowfeablog.com/2019/10/31/%E8%B0%83%E8%89%B2%E7%9B%98/)

### 光照模型
光照模型这里实现的是Blinn-Phong模型，使用了两种方法实现。一种是完全GLSL的方法，从0开始写各种向量获取方法，[点这里](https://github.com/CrowFea/ShaderToy/blob/master/Assets/Shaders/PhongIllumination.shader)；另外一种是使用unity中的封装好的方法进行编写，[点这里](https://github.com/CrowFea/ShaderToy/blob/master/Assets/Shaders/BlinnPhong.shader).

## Random
Random在shader的设计中有着非常重要的作用，同时其呈现的效果也十分的有趣。随机的效果可以模拟一些大自然中的景象，如水面的起伏、风吹过的树叶，也可以进行一些想象中的仿真，比如说虚拟科幻中的量子波纹之类的。

这部分的shader来源于网站[shadertoy](https://www.shadertoy.com/new)和Youtube,其中一些代码的复现，具体的实现流程请看我的博客[CrowFea丨Blog](https://crowfeablog.com/)。关于Random函数的设计在我的另一篇博客中有提及[ShaderToy丨Random函数](https://crowfeablog.com/2019/11/10/ShaderToy%E4%B8%A8Random%E5%87%BD%E6%95%B0/)。

### Virus
![img](https://media.giphy.com/media/cLSYRNd51uXatonc4a/giphy.gif)

原链接[ShaderToy](https://github.com/CrowFea/ShaderToy)
博客链接[ShaderToy丨着色与时间-Virus的实现](https://crowfeablog.com/2019/11/15/ShaderToy%E4%B8%A8%E9%9A%8F%E6%9C%BA-Virus%E7%9A%84%E5%AE%9E%E7%8E%B0/)

### DataPath
![img](https://media.giphy.com/media/jmx3p9w9hMfC9zvXG2/giphy.gif)

博客链接[ShaderToy丨随机-DataPath的实现](https://crowfeablog.com/2019/11/13/ShaderToy%E4%B8%A8%E9%9A%8F%E6%9C%BA-DataPath%E7%9A%84%E5%AE%9E%E7%8E%B0/)

### Chromatic Metaballs
![img](https://s2.ax1x.com/2019/11/09/MeMDXQ.md.gif)

原链接[ShaderToy](https://media.giphy.com/media/U2AMnzt4gCzdCVDr79/giphy.gif)
博客链接[ShaderToy丨随机-Chromatic Metaballs实现](https://crowfeablog.com/2019/11/08/ShaderToy%E4%B8%A8%E9%9A%8F%E6%9C%BA-Chromatic%20Metaballs%E5%AE%9E%E7%8E%B0/)


## NPR
NPR即非真实性渲染，我们常见的卡通风格渲染就属于这种。卡通渲染可以应用在游戏、电影之中，可以做出十分有趣的效果。这一部分代码借鉴于冯乐乐的博客。

### comic
![img](https://s2.ax1x.com/2019/12/05/Q8x9s0.png)

博客链接[卡通风格渲染](https://crowfeablog.com/2019/12/05/%E5%8D%A1%E9%80%9A%E9%A3%8E%E6%A0%BC%E6%B8%B2%E6%9F%93Toon%20Shader/)

## About

- 如果您有任何的问题，或是想要看shader具体实现的过程，请移步我的博客[CrowFea丨Blog](https://crowfeablog.com/)


