#!/bin/sh

# ----------------------------
# 在 Tomcat 中部署运行 web 项目
# 
# 【示例】
# 1，复制widget war包并部署
#   sh deploy_local.sh tomcat/ widget/target/widget.war
# 
# 2，部署widget
#   sh deploy_local.sh tomcat/
# ----------------------------

# 参数有效性校验
if [ -z "$1" ]; then
	echo "sh deploy_local.sh tomcat_path [war_path]"
	exit 1
fi

tomcat_path="/data1/$1"

# 校验tomcat根目录是否存在
if [ ! -d "$tomcat_path" ]; then
	echo "Tomcat根目录不存在！"
	exit 1
fi

# 1，干掉tomcat进程
java_port=`ps aux | grep java | grep "$tomcat_path" | awk '{print $2}'`
if [ -n "$java_port" ]; then
	kill -9 "$java_port"
	echo "OK: killed java process."
fi

# 2，进入tomcat web项目部署目录
cd "$tomcat_path/webapps/"

# 3，部署war包
project="$2"
if [ -n "$project" ]; then
        rm -rf ./*
	cp "/media/Edward_/Work/workspace/$project" ROOT.war
	echo "OK: download war ($project)."
	sleep 1
fi

# 4，清理tomcat日志文件
rm -rf ../logs/*

# 5，重启tomcat，并查看启动日志
cd ../bin/
sh startup.sh
tail -f ../logs/catalina.out
