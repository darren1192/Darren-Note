# iOS xcodebuild 自动打包入门

目前在了解自动打包这块，不管是 `fastlane` 、 `xctool` 还是啥，基本原理都是调用 `xcodebuild` 方法去实现，所以这一篇先入门 `xcodebuild`。

关于 `xcodebuild` ，先了解几个命令:

- 查看手册：  `man xcodebuild` 
- 查看版本号：  `xcodebuild -version `
- 查看帮助： `xcodebuild -help` 
- 查看已安装SDK列表： `xcodebuild -showsdks`
- 查看xcodebuild目录： `xcode-select -print-path`
- 查看项目配置： `xcodebuild -showBuildSettings`
- 编译项目： `xcodebuild`

在终端输入`xcodebuild -help` 可以查看一些常用方法。

```
xcodebuild [-project <projectname>] [[-target <targetname>]...|-alltargets] [-configuration <configurationname>] [-arch <architecture>]... [-sdk [<sdkname>|<sdkpath>]] [-showBuildSettings [-json]] [<buildsetting>=<value>]... [<buildaction>]...
       xcodebuild [-project <projectname>] -scheme <schemeName> [-destination <destinationspecifier>]... [-configuration <configurationname>] [-arch <architecture>]... [-sdk [<sdkname>|<sdkpath>]] [-showBuildSettings [-json]] [-showdestinations] [<buildsetting>=<value>]... [<buildaction>]...
       xcodebuild -workspace <workspacename> -scheme <schemeName> [-destination <destinationspecifier>]... [-configuration <configurationname>] [-arch <architecture>]... [-sdk [<sdkname>|<sdkpath>]] [-showBuildSettings] [-showdestinations] [<buildsetting>=<value>]... [<buildaction>]...
       xcodebuild -version [-sdk [<sdkfullpath>|<sdkname>] [-json] [<infoitem>] ]
       xcodebuild -list [[-project <projectname>]|[-workspace <workspacename>]] [-json]
       xcodebuild -showsdks [-json]
       xcodebuild -exportArchive -archivePath <xcarchivepath> [-exportPath <destinationpath>] -exportOptionsPlist <plistpath>
       xcodebuild -exportNotarizedApp -archivePath <xcarchivepath> -exportPath <destinationpath>
       xcodebuild -exportLocalizations -localizationPath <path> -project <projectname> [-exportLanguage <targetlanguage>...]
       xcodebuild -importLocalizations -localizationPath <path> -project <projectname>
       xcodebuild -resolvePackageDependencies [-project <projectname>|-workspace <workspacename>] -clonedSourcePackagesDirPath <path>
       ···
```

这里就不做一一介绍，但是有几个项目级别的参数要注意:

- `workspace` 是一个项目的总文件，里面可以包含一个或者几个`project`, 一般大家会把项目依赖的 `project`，放在一个 `workspace`中，比如 Cocoapods 这个工具就把依赖放在了一个单独的叫`Pods`的 `project`，让后通过 `workspace` 把项目组织在一起。
- `project` 一个组织项目里代码和资源的文件。`project` 是必不可少，`workspace`是可选的。如果你只有一个`project`，并且不依赖其他`project`则是不需要`workspace`的。
- `target` 定义编译时需要哪些文件和资源，对环境有哪些要求，编译中要不要加入什么自定义的步骤。一个 project 可以有多个文件`target`, 比如在iOS和 macOS 共用代码的项目里，可以分别有 iOS 和 macOS 两个不同的`target` 每个 target 包含整个项目里自己需要的文件和设置。
- `scheme` 定义了你怎样使用 `target` 的方式，相当于在 `target` 外观有包了一层，属于定义 `target` 的外部环境。在什么环境下使用 target，是 Build，run，Test，Profile 等等。build 这个 target 要不要 Debug 的符号信息，跑起来编译好的二进制文件时，要不要带参数，带什么参数，二进制文件跑起来后应该生活在什么样的环境？系统语言是什么，Metal 要不要开启？二进制跑起来后要不要对程序的内存进行监控，比如`Zombie Objects`等等。因为`scheme` 是为`target`服务的，所以 Xcode 是创建`target` 是默认创建对应的`scheme`。

一般情况我们明确指定，`workspace`、 `scheme`这两个基本参数就可以，没有 `workspace` 的则指定`projec`。[来源](https://www.taijicoder.com/2018/05/24/explain-xcodebuild/)

对于xcodebuild的介绍先到这里，想看更仔细的，请移步[官网](https://help.apple.com/xcode/mac/current/#/itcaec37c2a6) 或者在终端执行 `man xcodebuild` 或者 `xcodebuild -help` 。

下面，我们去亲自实操一个打包项目。

新建一个工程`XcodeBuildDemo`。

![](https://tva1.sinaimg.cn/large/006y8mN6ly1g72han7i2oj30dm05c758.jpg)

然后在创建一个脚本文件`xd.sh`

```

#使用方法
if [ ! -d ./IPADir ];
then
mkdir -p IPADir;
fi

#工程绝对路径
project_path=$(cd `dirname $0`; pwd)

#工程名
project_name="XcodeBuildDemo"

#scheme名
scheme_name="XcodeBuildDemo"

#打包模式 Debug/Release
development_mode=Debug

#build文件夹路径
build_path=${project_path}/build

#plist文件所在路径
exportOptionsPlistPath=${project_path}/exportTest.plist

#导出.ipa文件所在路径
exportIpaPath=${project_path}/IPADir/${development_mode}


echo '正在清理工程'

xcodebuild \
clean -configuration ${development_mode} -quiet  || exit

echo '清理完成'

echo '正在编译工程:'${development_mode}

xcodebuild \
archive -project ${project_path}/${project_name}.xcodeproj \
-scheme ${scheme_name} \
-configuration ${development_mode} \
-archivePath ${build_path}/${project_name}.xcarchive  -quiet  || exit

echo '编译完成'

echo '开始ipa打包'

xcodebuild -exportArchive -archivePath ${build_path}/${project_name}.xcarchive \
-configuration ${development_mode} \
-exportPath ${exportIpaPath} \
-exportOptionsPlist ${exportOptionsPlistPath} \
-quiet || exit

if [ -e $exportIpaPath/$scheme_name.ipa ]; then
echo 'ipa包已导出'
open $exportIpaPath
else
echo 'ipa包导出失败 '
fi
echo '打包ipa完成  '
```

将shell脚本和写好的版本配置文件放在 `XcodeBuildDemo.xcodeproj` 同一个目录文件下

![](https://tva1.sinaimg.cn/large/006y8mN6ly1g72hltnrdaj30r40c2di7.jpg)



在终端cd到当前目录，执行 `xd.sh` 脚本。可以得到最后的结果

![](https://tva1.sinaimg.cn/large/006y8mN6ly1g72hnw2tszj30e60esacw.jpg)

至此，关于xcodebuild自动打包入门就到这里。



 

