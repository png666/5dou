#-------------项目自定义部分(自定义好下列参数后再执行该脚本)

# (注意: 因为shell定义变量时,=号两边不能留空格,若scheme_name与info_plist_name有空格,脚本运行会失败)

# 计时
SECONDS=0

# 是否编译工作空间 (例:若是用Cocopods管理的.xcworkspace项目,赋值true;用Xcode默认创建的.xcodeproj,赋值false)
is_workspace="true"

# 指定项目的scheme名称
scheme_name="5dou"
# 工程中Target对应的配置plist文件名称, Xcode默认的配置文件为Info.plist
info_plist_name="Info"

# 指定要打包编译的方式 : Release,Debug
build_configuration="Release"

# 是否上传分发平台(fir)
is_uploadfir="true"

# firToken
fir_token="753183858b3661134595e2e7e30cbd9f"
upload_token=$fir_token

# 蒲公英上传
# 执行 curl -F "file=@/tmp/example.ipa" -F "uKey=xxx" -F "_api_key=xxx" https://qiniu-storage.pgyer.com/apiv1/app/upload 请根据开发者自己的账号，将其中的 uKey 和 _api_key 的值替换为相应的值。


# ----------------自动打包部分(无特殊情况不用修改)#

# 导出ipa所需要的plist文件路径 (默认为AdHocExportOptionsPlist.plist)
ExportOptionsPlistPath="./AutoPackageScript/AdHocExportOptionsPlist.plist"
# 返回上一级目录,进入项目工程目录
cd ..
# 获取项目名称
project_name=`find . -name *.xcodeproj | awk -F "[/.]" '{print $(NF-1)}'`
# 获取版本号,内部版本号,bundleID
info_plist_path="$project_name/$info_plist_name.plist"
bundle_version=`/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" $info_plist_path`
bundle_build_version=`/usr/libexec/PlistBuddy -c "Print CFBundleIdentifier" $info_plist_path`
bundle_identifier=`/usr/libexec/PlistBuddy -c "Print CFBundleVersion" $info_plist_path`
# 时间
DATE=`date '+%Y-%m-%d-%H-%m-%S'`
# 指定输出ipa路径
export_path=~/Desktop/"$scheme_name-$DATE"
# 指定输出归档文件地址
export_archive_path="$export_path/$scheme_name.xcarchive"
# 指定输出ipa地址
export_ipa_path="$export_path"
# 指定输出ipa名称
ipa_name="$scheme_name-v$bundle_version"

# AdHoc,AppStore,Enterprise三种打包方式的区别: http://blog.csdn.net/lwjok2007/article/details/46379945

echo "------------------------------------------------------"
echo "\033[36;1m请选择打包方式(输入序号,按回车即可) \033[0m"
echo "\033[33;1m1. AdHoc       \033[0m"
echo "\033[33;1m2. AppStore    \033[0m"
echo "\033[33;1m3. Enterprise  \033[0m"
echo "\033[33;1m4. Development \033[0m"
# 读取用户输入并存到变量里
read parameter
sleep 0.5
method="$parameter"

# 判读用户是否有输入
if [ -n "$method" ]
then
if [ "$method" = "1" ] ; then
ExportOptionsPlistPath="./AutoPackageScript/AdHocExportOptionsPlist.plist"
elif [ "$method" = "2" ] ; then
ExportOptionsPlistPath="./AutoPackageScript/AppStoreExportOptionsPlist.plist"
elif [ "$method" = "3" ] ; then
ExportOptionsPlistPath="./AutoPackageScript/ExportOptions.plist"
elif [ "$method" = "4" ] ; then
ExportOptionsPlistPath="./AutoPackageScript/DevelopmentExportOptionsPlist.plist"
else
echo "输入的参数无效!!!"
exit 1
fi
fi

echo "------------------------------------------------------"
echo "\033[32m是否上传分发平台(fir,输入序号,按回车即可) \033[0m"
echo "\033[33;1m1. 不上传 (默认) \033[0m"
echo "\033[33;1m2. 上传         \033[0m"
read para
sleep 0.5

if [ -n "$para" ]
then
if [ "$para" = "1" ]
then
is_uploadfir="false"
elif [ "$para" = "2" ]
then
is_uploadfir="true"
else
echo "参数无效...."
exit 1
fi
else
is_uploadfir="false"
fi

echo "------------------------------------------------------"
echo "\033[32m开始构建项目  \033[0m"
# 指定输出文件目录不存在则创建
if [ -d "$export_path" ] ; then
echo $export_path
else
mkdir -pv $export_path
fi

# 判断编译的项目类型是workspace还是project
if $is_workspace ; then
# 编译前清理工程
xcodebuild clean -workspace ${project_name}.xcworkspace \
-scheme ${scheme_name} \
-configuration ${build_configuration}

xcodebuild archive -workspace ${project_name}.xcworkspace \
-scheme ${scheme_name} \
-configuration ${build_configuration} \
-archivePath ${export_archive_path}
else
# 编译前清理工程
xcodebuild clean -project ${project_name}.xcodeproj \
-scheme ${scheme_name} \
-configuration ${build_configuration}

xcodebuild archive -project ${project_name}.xcodeproj \
-scheme ${scheme_name} \
-configuration ${build_configuration} \
-archivePath ${export_archive_path}
fi

#  检查是否构建成功
#  xcarchive 实际是一个文件夹不是一个文件所以使用 -d 判断
if [ -d "$export_archive_path" ] ; then
echo "\033[32;1m项目构建成功 \033[0m"
else
echo "\033[31;1m项目构建失败 \033[0m"
exit 1
fi
echo "------------------------------------------------------"

echo "\033[32m开始导出ipa文件 \033[0m"
xcodebuild  -exportArchive \
-archivePath ${export_archive_path} \
-exportPath ${export_ipa_path} \
-exportOptionsPlist ${ExportOptionsPlistPath}
# 修改ipa文件名称
mv $export_ipa_path/$scheme_name.ipa $export_ipa_path/$ipa_name.ipa

# 检查文件是否存在
if [ -f "$export_ipa_path/$ipa_name.ipa" ] ; then
echo "\033[32;1m导出 ${ipa_name}.ipa 包成功 \033[0m"
open $export_path
else
echo "\033[31;1m导出 ${ipa_name}.ipa 包失败 \033[0m"
exit 1
fi
# 输出打包总用时
echo "\033[36;1m使用AutoPackageScript打包总用时: ${SECONDS}s \033[0m"

#上传分发平台
if $is_uploadfir ; then
fir login -T $upload_token       # fir.im token
fir publish $export_ipa_path/$ipa_name.ipa
fi

exit 0
