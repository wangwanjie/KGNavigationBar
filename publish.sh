#!/bin/bash

directory="$(
    cd "$(dirname "$0")"
    pwd
)"
# 更新头文件
HeaderFileGenerator="$directory/HeaderFileGenerator.py"

if [[ -f "$HeaderFileGenerator" ]]; then
    python3 $HeaderFileGenerator
fi

# 文件后缀名，自动查找
file_extension="podspec"
podspec_path=$(find $directory -name "*.$file_extension" -maxdepth 1 -print)
need_pack=false

# 有错不退出
function notExitWithMessage() {
    echo "\033[;32m -------------------------------- \033[0m"
    printRed "${1}"
    echo "\033[;32m -------------------------------- \033[0m"
}

# 有错退出
function exitWithMessage() {
    echo "\033[;33m -------------------------------- \033[0m"
    printRed "${1}"
    echo "\033[;33m -------------------------------- \033[0m"
    exit ${2}
}

# 打印
function printRed() {
    echo "\033[;31m $1 \033[0m"
}

printRed "podspec路径:$podspec_path"

podspec_name=$(basename $podspec_path)
printRed "podspec名称:$podspec_name"

# 获取版本号
version=$(grep -E "s.version |s.version=" $podspec_path | head -1 | sed 's/'s.version'//g' | sed 's/'='//g' | sed 's/'\"'//g' | sed 's/'\''//g' | sed 's/'[[:space:]]'//g')
printRed "podspec版本:$version"

function helpFunction() {
    echo ""
    echo "Usage: $0 -p -h"
    echo "\t -p 需要打包 framework"
    echo "\t -h 查看帮助"
    exit 1
}

while getopts :p opt; do
    case "$opt" in
    p)
        need_pack=true
        printRed "需要打包"
        ;;
    ?) helpFunction ;;
    esac
done

git_branch=$(git symbolic-ref --short -q HEAD)

printRed "git 分支: $git_branch"

printRed "开始提交代码并打 tag：$version"
filename=$(echo $podspec_name | cut -d . -f1)
git rm -r --cached . -f
git add .
git commit -m "published $filename $version"

git push origin $git_branch

git tag -d $version
git push origin :refs/tags/$version

git tag -a $version -m "$version"
git push origin --tags
printRed "提交及推送代码、tags 结束\n"

printRed "开始发布 $filename 版本 $version 到 Cocoapods"
# 清除缓存
printRed cache clean --all

pod trunk push "${podspec_name}" --allow-warnings --skip-import-validation

if [ $? -ne 0 ]; then
    printRed "发布 $filename 版本 $version 失败"
    exit 1
fi

printRed "发布 $filename 版本 $version 到 Cocoapods 结束\n"

if [[ $need_pack == true ]]; then
    printRed "开始打包 framework"
    pod package ${podspec_name} --no-mangle --exclude-deps --force --spec-sources=https://github.com/CocoaPods/Specs.git

    if [ $? -ne 0 ]; then
        printRed "打包 framework失败"
        exit 1
    fi

    printRed "打包 framework 结束\n"
else
    printRed "不需要打包 framework"
fi
