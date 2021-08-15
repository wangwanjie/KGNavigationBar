#!/usr/bin/python3
# -*- coding: utf-8 -*-

import os
import time


# 判断是否存在 podspec 文件
def isExistPodspec():
    allFiles = os.listdir(os.getcwd())
    isExist = False
    for fileName in allFiles:
        if '.podspec' in fileName:
            isExist = True
            # 记得跳出循环
            break
        else:
            isExist = False
    return isExist


# 自动获取 podspec 文件
def getPodspecFile():
    listFile = os.listdir(os.getcwd())
    # 文件后缀名，自动查找
    file_extension = "podspec"
    for fileName in listFile:
        if fileName.endswith(file_extension):
            return fileName

    os.system("say 未找到" + file_extension + "文件")
    return "not found"


# 自动获取版本号
def getPodspecVersion(podspecFileName):
    podspec_path = os.getcwd() + '/' + podspecFileName
    versionLine = ''
    for line in open(podspec_path):
        if 's.version' in line:
            versionLine = line
            break

    version = ''
    splitStr = versionLine.split("\"")
    if len(splitStr) <= 1:
        splitStr = versionLine.split("\'")

    if len(splitStr) > 1:
        version = splitStr[1]
    return version


if not isExistPodspec():
    # xcode build 触发
    # 回到上级目录
    os.chdir(os.path.abspath(os.path.dirname(os.getcwd())))

# podspec 文件
podspecFileName = getPodspecFile()

# 库名称
podName = podspecFileName.split(".")[0]
# 根目录
ROOT_DIR_PATH = os.getcwd() + '/' + podName
# 版本
version = getPodspecVersion(podspecFileName)
# 头文件名称
HeaderFileFullName = podName + '.h'


# 递归收集所有文件
def fileListForDir(dir):
    fileList = []
    for dir_path, subdir_list, file_list in os.walk(dir):
        # 隐私头文件目录不导入
        if dir_path.find('Private') > -1:
            print('过滤隐私目录:'+dir_path)
            continue
        # 可以在这里设置过滤不相关目录
        if not(dir_path.find(".git") > -1 or dir_path.find(".gitee") > -1 or dir_path.find(".svn") > -1 or dir_path.endswith('lproj') or dir_path.endswith('xcassets')):
            for fname in file_list:
                # if fname != HeaderFileFullName and (fname.lower().endswith(".h") or fname.lower().endswith(".c")):
                if fname != HeaderFileFullName and (fname.lower().endswith(".h")):
                    full_path = os.path.join(dir_path, fname)
                    # 这是全路径
                    # fileList.append(full_path + fname)
                    fileList.append(fname)
    return fileList


def main():

    localtime = time.localtime(time.time())
    date = time.strftime("%Y/%m/%d %H:%M", localtime)
    year = localtime.tm_year

    print('开始生成头文件')
    print('根目录：' + ROOT_DIR_PATH)
    print('版本号：' + version)
    print('时间：' + date)

    fileContent = '''//
//  %s.h
//  %s
//
//  Created by VanJay on %s.
//  Copyright © %s wangwanjie. All rights reserved.
//  This file is generated automatically.

#ifndef %s_h
#define %s_h

#import <UIKit/UIKit.h>

/// 版本号
static NSString *const %s_VERSION = @"%s";

''' % (podName, podName, date, year, podName, podName, podName, version)

    # 文件名列表
    fileList = fileListForDir(ROOT_DIR_PATH)
    for filename in fileList:
        fileContent += '''#if __has_include("%s")
#import "%s"
#endif

''' % (filename, filename)

    # 拼接尾部
    fileContent += '#endif /* %s_h */' % (podName)

    # 写入文件
    with open(ROOT_DIR_PATH + '/' + HeaderFileFullName, 'w') as file:
        print("生成头文件成功")
        file.write(fileContent)


if __name__ == "__main__":
    main()
