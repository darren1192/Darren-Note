## shell从了解到了解

shell 是一个用C语言编写的程序，俗称壳（用来区别于核），和内核是相对的，用于和用户交互，接收用户指令，调用相应的程序。

基本上，shell分为两大类。

##### 1、图形界面shell

Graphical User Interface shell 即 GUI shell。

也就是用户使用GUI和计算机核交互的shell，比如Windows下使用最广泛的Windows Explorer（Windows资源管理器），Linux下的X Window，以及各种更强大的CDE、GNOME、KDE、 XFCE，他们都是GUI Shell。

##### 2、命令行式shell

Command Line Interface shell ，即CLI shell。

也就是通过命令行和计算机交互的shell。 Windows NT 系统下有 cmd.exe（命令提示字符）和近年来微软大力推广的 Windows PowerShell。 Linux下有bash / sh / ksh / csh／zsh等 一般情况下，习惯把命令行shell（CLI shell）直接称做shell，以后，如果没有特别说明，shell就是指 CLI shell，后文也是主要讲Linux下的 CLI shell。



#### shell的种类

shell的种类有很多，我们可以通过**cat /etc/shells**来获取。

![屏幕快照 2019-07-18 下午9.32.53](http://ww2.sinaimg.cn/large/006tNc79ly1g54bgs4syyj30m808wacq.jpg)

其中：

1. bash:Bourne Again Shell 用来替代Bourne shell，也是目前大多数Linux系统默认的shell。
2. csh/tcsh:C shell 使用的是“类C”语法,csh是具有C语言风格的一种shell，tcsh是增强版本的csh，目前csh已经很少使用了。
3. sh:Bourne Shell 是一个比较老的shell，目前已经被/bin/bash所取代，在很多linux系统上，sh已经是一个指向bash的链接了。
4. zsh:是一个Linux用户很少使用的shell，这是由于大多数Linux产品安装，以及默认使用bash shell。但zsh具有很强大的提示和插件功能（没使用过，有人推荐过*Oh My Zsh*）。

#### 运行一段shell脚本

可以打开文本编辑器，新建一个文件**demo.sh**，扩展名为**sh**（sh代表shell）。

```shell
#!bin/bash
echo "hello world!"
```

***#!*** 是一个约定的标记，它告诉系统这个脚本需要什么解释器来执行，即使用哪一种shell。比如这里使用了 ***/bin/bash*** 来执行这个脚本。

**echo**命令用户向窗口输出文本。

运行shell脚本的话可以直接**cd**到当前目录，使用sh

```shell
sh demo.sh		
```

或者直接**./demo.sh**，但这样可能会报错**Permission denied**错误，这是没有执行权限，运行运行**chmod a+x demo.sh**加上执行权限即可。

