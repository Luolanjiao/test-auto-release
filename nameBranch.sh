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
n=$["n"]
if test $[confirm_answer] -eq $[n]
then
echo "您已取消创建分支！"
fi


# 从master切dev分支
git checkout -b ${dev_branch_name}
git push --set-upstream origin ${dev_branch_name}
echo "分支已创建成功！并切换到分支"+${dev_branch_name}
exit 0
