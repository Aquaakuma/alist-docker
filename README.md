### alist-docker

这是一个非官方的dockerize的Alist。

### Alist项目地址

https://github.com/Xhofe/alist

### 如何使用

创建一个配置文件

```shell
mkdir ~/Alist/config
cd ~/Alist/config
vim conf.yml
```

在conf.yml写入如下内容并修改相应配置:

```yaml
info:
  title: AList #标题
  logo: "" #网站logo 如果填写,则会替换掉默认的
  footer_text: Xhofe's Blog #网页底部文字
  footer_url: https://www.nn.ci #网页底部文字链接
  music_img: https://img.oez.cc/2020/12/19/0f8b57866bdb5.gif #预览音乐文件时的图片
  check_update: true #前端是否显示更新
  script: #自定义脚本,可以是脚本的链接，也可以直接是脚本内容,如document.querySelector('body').style="background-image:url('https://api.mtyqx.cn/api/random.php');background-attachment:fixed"
  autoplay: true #视频是否自动播放
  preview:
    text: [txt,htm,html,xml,java,properties,sql,js,md,json,conf,ini,vue,php,py,bat,gitignore,yml,go,sh,c,cpp,h,hpp] #要预览的文本文件的后缀，可以自行添加
server:
  address: "0.0.0.0"
  port: "5244"
  search: true
  static: dist
  site_url: '*'
  password: password #用于重建目录
ali_drive:
  api_url: https://api.aliyundrive.com/v2
  max_files_count: 50 #重建目录时每次请求的文件
  drives:
  - refresh_token: refresh_token #refresh_token
    root_folder: root_folder #根目录的file_id
    name: drive0 #盘名，多个盘不可重复
    password: pass #该盘密码，空则不设密码，修改需要重建生效
    hide: false #是否在主页隐藏该盘，不可全部隐藏，至少暴露一个
  - refresh_token: xxx
    root_folder: root
    name: drive1
    password: pass
    hide: false
database:
  type: sqlite3
  dBFile: alist.db

```

```docker
docker run -d -p 5244:5244 -v ~/Alist/config:/config tut123456/alist-docker:latest # 这里填入相应版本号
```

也可以使用docker-compose部署，`docker-compose.yml`配置如下：

```yml
version: "2.1"
services:
  alist:
    image: tut123456/alist-docker:latest # 这里填入相应版本号
    privileged: true
    container_name: alist
    volumes:
      - ~/Alist/config:/config
    ports:
      - 5244:5244
    restart: unless-stopped
```
