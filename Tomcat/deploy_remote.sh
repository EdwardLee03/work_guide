#!/bin/sh

# ----------------------------
# 在 Tomcat 中部署运行 web 项目
# 
# 【示例】
# sh deploy_web.sh tomcat/ http://redmine.intra.weibo.com:8081/nexus/content/repositories/releases/com/weibo/api/widget/1.21/widget-1.21.war
# ----------------------------

# 参数有效性校验
if [ -z "$1" ]; then
	echo "sh deploy_web.sh tomcat_path war_download_path"
	exit 1
fi

tomcat_path="/data1/$1"

# 校验tomcat根目录存在与否
if [ ! -d "$tomcat_path" ]; then
	echo "tomcat根目录不存在！"
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

# 3，部署远程war包
project="$2"
if [ -n "$project" ]; then
        rm -rf ./*
	wget "$project" -O ROOT.war
	echo "OK: download war ($project)."
	sleep 1
fi

# 4，清理tomcat日志文件
rm -rf ../logs/*

# 5，重启tomcat，并查看启动日志
cd ../bin/
sh startup.sh
tail -f ../logs/catalina.out
