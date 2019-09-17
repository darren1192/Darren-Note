
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





