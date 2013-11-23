#!/bin/sh

# 构建项目
#
# 【示例】
# 	打包 invite 项目
# 	sh maven_project_build.sh invite
#
# 项目命名规则
# 	对于 $name 项目
# 	其包含 '$name-service, $name-web, $blossom-v3' 3个子项目

if [ -z "$1" ]; then
	echo 'sh maven_project_build.sh $project_name'
	exit 1
fi

project_name="$1"

# 1, install xxx-service.jar into the local repository, for use as a dependency in other projects locally
cd "$project_name/$project_name-service"
mvn clean install

# 2, install xxx-web.jar
cd "../$project_name-web"
mvn clean install

# 3, package blossom-v3.war
cd blossom/blossom-v3/
mvn clean package

# end
echo "Package 'blossom-v3' complete!"
