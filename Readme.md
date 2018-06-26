# 欢迎使用本脚本

本脚本是基于[steam_2018_summer_game](https://github.com/Indexyz/steam_2018_summer_game)的二次开发。

可以更加方便地挂游戏。

1. 会安装`nvm`并安装`node v10.5.0`

1. 会获取最新的`steam社区的IP`并且写入到`hosts`里面，以确保在国内挂游戏也能够顺利进行。

1. 文件将会安装到`/opt/summer_game`

## 安装

```shell
wget --no-check-certificate  -O summer_game_script.sh https://raw.githubusercontent.com/zsnmwy/steam-summer-game-script-2018/master/summer_game_script.sh && bash summer_game_script.sh
```

## 使用方法

```shell
使用方法

steamgame

    --start1      | -s1   启动方式: node index.js
    --start2      | -s2   启动方式: npm run dev
    --log         | -l    查看挂游戏的日志
    --remove      | -r    移除挂游戏的任务
    --status      | -st   查看挂游戏的状态

```

```shell
e.g.

查看日志

steamgame --log

或

steamgame -l
```
