#!/bin/bash
#!/bin/bash
echo "您正在创建新的开发分支："
read -p "请为新的开发分支选择开发类型，0为bug，1为新需求，2为改善性小需求：" dev_type

# 创建分支名
dev_date=`date +%Y%m%d`
case ${dev_type} in
  0)
  read -p "请输入禅道bug的id：" dev_bug_id
  echo ${dev_date}
  echo ${dev_bug_id}
  dev_branch_name=hotfix-bug-${dev_date}-${dev_bug_id}
  echo ${dev_branch_name}
  ;;

  1)
  read -p "请输入新需求英文名：" dev_feature_name
  dev_branch_name=feature-main-${dev_date}-${dev_feature_name}
  ;;

  2)
  read -p "请输入禅道任务id：" dev_optimize_id
  dev_branch_name=hotfix-optimize-${dev_date}-${dev_optimize_id}
  ;;
  *)
  echo "请输入可选的开发类型！"
  exit 0
  ;;
esac

# 再次确认
read -p "请确认分支名：${dev_branch_name},y/n? " confirm_answer
if [ ${confirm_answer} == "n" ]
then
echo "您已取消创建分支！">&2
exit 1
fi


# 从master切dev分支
git checkout -b ${dev_branch_name}

# --------------------修改中台版本号---------
# 当前版本号
version=`awk '/<version>[^<]+<\/version>/{gsub(/<version>|<\/version>/,"",$1);print $1;exit;}' pom.xml`
BUILD_NAME=$dev_mark

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
# --------------------end----------

git add ./
git commit -m "指定版本号"
git push --set-upstream origin ${dev_branch_name}
echo "分支已创建成功！并切换到分支"+${dev_branch_name}
exit 0



