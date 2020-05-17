read -p "请确认分支名：${dev_branch_name},y/n? " confirm_answer
if test $[confirm_answer] -eq $[n]
then
echo "您已取消创建分支！"
fi

{
# 当前版本号
version=`awk '/<version>[^<]+<\/version>/{gsub(/<version>|<\/version>/,"",$1);print $1;exit;}' pom.xml`
read -p "请输入版本名： " BUILD_NAME

# 新版本号的编码
new_version_number=`echo $version | sed 's/\(.*\..*\.\)//' | sed 's/-.*//g'`
new_version_number=`expr $new_version_number + 1`
echo $new_version_number
# 新版本号的编号=编码-需求版本名-SNAPSHOT
BUILD_NAME=$new_version_number-${BUILD_NAME}-SNAPSHOT
echo $BUILD_NAME
new_version=`echo $version | sed 's/\(.*\..*\.\).*\(-.*\)/\1'$BUILD_NAME'/'`
# 修改版本号
echo $new_version
mvn versions:set -DnewVersion=$new_version
}||{
echo "修改版本号时出现未知错误"
exit 1;
}
