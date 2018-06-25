#!/usr/bin/env bash
#Author:zsnmwy

PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin:/opt/summer_game:/root/.nvm/versions/node/v10.5.0/bin
export PATH

# fonts color
Green="\033[32m"
Red="\033[31m"
Yellow="\033[33m"
GreenBG="\033[42;37m"
RedBG="\033[41;37m"
Font="\033[0m"
Green_font_prefix="\033[32m"
Red_font_prefix="\033[31m"
Green_background_prefix="\033[42;37m"
Red_background_prefix="\033[41;37m"
Font_color_suffix="\033[0m"

# notification information
Info="${Green}[信息]${Font}"
OK="${Green}[OK]${Font}"
Error="${Red}[错误]${Font}"

# files/floder path
SUMMER_GAME_FILES_DIR="/opt/summer_game"

source /etc/os-release
VERSION=$(echo ${VERSION} | awk -F "[()]" '{print $2}')
BIT=$(uname -m)

Is_root() {
	if [ $(id -u) == 0 ]; then
		echo -e "${OK} ${GreenBG} 当前用户是root用户，进入安装流程 ${Font} "
	else
		echo -e "${Error} ${RedBG} 当前用户不是root用户 退出脚本 ${Font}"
		exit 1
	fi
}

#检测安装完成或失败
judge(){
	if [[ $? -eq 0 ]];then
		echo -e "${OK} ${GreenBG} $1 完成 ${Font}"
		sleep 1
	else
		echo -e "${Error} ${RedBG} $1 失败${Font}"
		exit 1
	fi
}

Check_system() {
	echo -e "${ID}"
	echo -e "${VERSION_ID}"
	if [[ "${ID}" == "centos" ]]; then
        Get_token
        yum update
        judge "更新源"
        yum install git  wget sed -y
        judge "安装 git wget sed"
	elif [[ "${ID}" == "ubuntu" ]]; then
        Get_token
        apt-get update
        judge "更新源"
        apt-get install git wget sed -y
        judge "安装 git wget sed"
	elif [[ "${ID}" == "raspbian" ]]; then
        Get_token
        apt-get update
        judge "更新源"
        apt-get install git wget sed -y
        judge "安装 git wget sed"
    elif [[ "${ID}" == "debian" ]]; then
        Get_token
        apt-get update
        judge "更新源"
        apt-get install git wget sed -y
        judge "安装 git wget sed"
	else
		echo -e "${Error} ${RedBG} 当前系统为 ${ID} ${VERSION_ID} 不在支持的系统列表内，安装中断 ${Font} "
		sleep 2
		exit 1
	fi
}

Get_token(){
    echo -e "${Info} ${GreenBG} 请到 https://steamcommunity.com/saliengame/gettoken 获取 token ${Font}"
    echo -e "${Info} ${GreenBG} 记得先登录steamcommunity ${Font}"
	read -p "请输入token：" steam_token
}

Install_nvm_node_V10.x_PM2() {
	echo -e "${Info} ${GreenBG} nvm安装阶段 ${Font}"
	wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.33.8/install.sh | bash #This install nvm
    judge "安装nvm"
	export NVM_DIR="$HOME/.nvm"
	[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
	[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion
	echo -e "${Info} ${GreenBG} node安装阶段 ${Font}"
	nvm install 10.5.0 # This install node v10.x
    judge "安装node 10.x"
	node -v            # Show node version
	#npm i -g nrm                                                       # Use npm install nrm
	#nrm use taobao                                                     # Registry set to: https://registry.npm.taobao.org/
	echo -e "${Info} ${GreenBG} pm2安装阶段 ${Font}"
	npm i -g pm2 # This install pm2
    judge "使用npm安装pm2"
    npm install -g yarn # This install yarn
    judge "使用npm安装yarn"
}

install_steam_2018(){
    mkdir -p ${SUMMER_GAME_FILES_DIR}
    git clone https://github.com/Indexyz/steam_2018_summer_game.git ${SUMMER_GAME_FILES_DIR}
    judge "clone steam_2018_summer_game"
    cat ${SUMMER_GAME_FILES_DIR}/config/default.json | sed 's/YOUR_TOKEN/'"$(echo $steam_token)"'/g'  > ${SUMMER_GAME_FILES_DIR}/config/default.json
    judge "修改token"
    cd ${SUMMER_GAME_FILES_DIR}
    yarn
    yarn run build
}

Get_steamcommunity_ip() {
	curl 'https://cloudflare-dns.com/dns-query?ct=application/dns-json&name=steamcommunity.com&type=A' | cut -d '"' -f34
}

Add_hosts_steamcommunity() {
	Check_hosts=$(cat /etc/hosts | grep steamcommunity.com)
	if [[ ! ${Check_hosts} ]]; then
		echo -e "准备修改hosts"
		cat >>/etc/hosts <<EOF
IPAddress steamcommunity.com
EOF
		echo -e "${Info} ${GreenBG} 使用sed修改hosts ${Font}"
		sed -i -e 's#IPAddress#'"$(echo $(Get_steamcommunity_ip))"'#g' /etc/hosts
        judge "修改steamcommunity IP"
		ip_address=$(cat /etc/hosts | grep steamcommunity.com)
		echo -e "${Info} ${GreenBG} ${ip_address} ${Font}"
	else
		get_ip=$(cat /etc/hosts | grep steamcommunity.com | cut -d ' ' -f 1)
		echo "${get_ip}"
		sed -i -e 's#'"$(echo ${get_ip})"'#'"$(echo $(Get_steamcommunity_ip))"'#' /etc/hosts
        judge "修改steamcommunity IP"
		echo "已经更新hosts"
		cat /etc/hosts | grep steamcommunity.com
	fi
}

Get_command_to_bin(){
    touch ${SUMMER_GAME_FILES_DIR}/start1.sh
    chmod 777 ${SUMMER_GAME_FILES_DIR}/start1.sh
    cat >> ${SUMMER_GAME_FILES_DIR}/start1.sh <<EOF
node ${SUMMER_GAME_FILES_DIR}/dist/index.js
EOF
    touch ${SUMMER_GAME_FILES_DIR}/start2.sh
    chmod 777 ${SUMMER_GAME_FILES_DIR}/start2.sh
    cat >> ${SUMMER_GAME_FILES_DIR}.sh <<EOF
cd ${SUMMER_GAME_FILES_DIR}
npm run dev
EOF
    cd /bin
    wget https://raw.githubusercontent.com/zsnmwy/steam-summer-game-script-2018/master/steamgame
    judge "下载steamgame"
    chmod 777 steamgame
}

Is_root

echo -e "
欢迎使用steam—summer-game—install-script-2018

在使用前请先获取token哟

请到 https://steamcommunity.com/saliengame/gettoken 获取 token

记得先登录steamcommunity

脚本有任何问题请到下面的网址反馈

https://github.com/zsnmwy/steam-summer-game-script-2018

程序有问题请到下面的网站反馈

https://github.com/Indexyz/steam_2018_summer_game

"
read -p "按任意键继续"

rm -rf ${SUMMER_GAME_FILES_DIR}
rm -r /bin/steamgame

Check_system #Get token
Add_hosts_steamcommunity
Install_nvm_node_V10.x_PM2
install_steam_2018
Get_command_to_bin
bash