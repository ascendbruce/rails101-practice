# 在遠端伺服器上設置 Rails 環境
## 計劃

### 安裝順序

1. ~~設定 .bashrc, .gemrc~~
*  ~~更新系統~~
*  ~~設定 hostname~~
*  ~~percona srever~~
*  ~~git~~
*  ~~rbenv, ruby~~
*  ~~Nginx and passenger~~
*  ~~ImageMagic~~
*  ~~depoly (在server上放mysql設定)~~


## 用.pem連到ec2

    ssh -i bruce-exercise.pem ubuntu@ec2-54-248-145-123.ap-northeast-1.compute.amazonaws.com

### 排除疑難雜症

#### 連線被拒絕且出現 `UNPROTECTED PRIVATE KEY FILE!` 錯誤訊息

    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    @         WARNING: UNPROTECTED PRIVATE KEY FILE!          @
    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    Permissions 0644 for 'bruce-exercise.pem' are too open.
    It is required that your private key files are NOT accessible by others.
    This private key will be ignored.
    bad permissions: ignore key: bruce-exercise.pem
    Permission denied (publickey).

##### 解法
因為權限太開放，把gorup跟others的權限拔掉即可。

    chmod 600 bruce-exercise.pem

#### 剛登入完，出現 `Your environment specifies an invalid locale.` 訊息

    _____________________________________________________________________
    WARNING! Your environment specifies an invalid locale.
     This can affect your user experience significantly, including the
     ability to manage packages. You may install the locales by running:

       sudo apt-get install language-pack-UTF-8
         or
       sudo locale-gen UTF-8

    To see all available language packs, run:
       apt-cache search "^language-pack-[a-z][a-z]$"
    To disable this message for all users, run:
       sudo touch /var/lib/cloud/instance/locale-check.skip
    _____________________________________________________________________

##### 解法
依照建議執行

    sudo locale-gen UTF-8
    sudo touch /var/lib/cloud/instance/locale-check.skip

#### 下錯指令時，出現 `command-not-found has crashed` 錯誤訊息

    Sorry, command-not-found has crashed! Please file a bug report at:
    https://bugs.launchpad.net/command-not-found/+filebug
    Please include the following information with the report:

    command-not-found version: 0.2.44

##### 解法
來源: [http://ivaniliev.com/sorry-command-not-found-has-crashed/](http://ivaniliev.com/sorry-command-not-found-has-crashed/)


加到 `~/.bashrc`

    export LANGUAGE=en_US.UTF-8
    export LANG=en_US.UTF-8
    export LC_ALL=en_US.UTF-8

第一次可能還要跑

    locale-gen en_US.UTF-8
    sudo dpkg-reconfigure locales

## 更新系統

    sudo apt-get update
    sudo apt-get upgrade
    sudo apt-get autoremove
    sudo reboot

## 設定 hostname

    sudo hostname bruce-exercise
    sudo vim /etc/hostname

修改內容
> 127.0.0.1 bruce-exercise

    sudo vim /etc/hostname

取代成
> bruce-exercise

    hostname

應該要顯示
> bruce-exercise

## 安裝 percona srever

    sudo apt-key adv --keyserver keys.gnupg.net --recv-keys 1C4CBDCDCD2EFD2A
    sudo vim /etc/apt/sources.list

加上內容
> deb http://repo.percona.com/apt precise main
>
> deb-src http://repo.percona.com/apt precise main

    sudo apt-get update
    sudo apt-get install percona-server-server-5.5 percona-server-client-5.5


percona root: `f5Bx7dT9b0F`

## 安裝 Git 與有的沒的 libs (for building rbenv)
    sudo apt-get update
    sudo apt-get upgrade
    sudo apt-get install build-essential git-core curl libcurl4-openssl-dev libssl-dev zlib1g zlib1g-dev libreadline-gplv2-dev

## 安裝 rbenv, rubies

    sudo su -
    git clone git://github.com/sstephenson/rbenv.git /usr/local/rbenv
    touch /etc/profile.d/rbenv.sh
    chmod +x /etc/profile.d/rbenv.sh

    vim /etc/profile.d/rbenv.sh

內容：

    # rbenv setup
    export RBENV_ROOT=/usr/local/rbenv
    export PATH="$RBENV_ROOT/bin:$PATH"
    eval "$(rbenv init -)"

重新登入

    exit
    sudo su -

ruby-build (提供 `rbenv install`)

    git clone git://github.com/sstephenson/ruby-build.git /tmp/ruby-build
    /tmp/ruby-build/install.sh

安裝 ruby

    rbenv install 1.9.3-p448
    rbenv global 1.9.3-p448
    rbenv rehash

## Nginx and passenger

    sudo gem install passenger
    exit
    sudo su -
    passenger-install-nginx-module
    # 1. install nginx for me
    # Install to /opt/nginx

## ImageMagic

    apt-get install imagemagick libmagickwand-dev

## depoly

    sudo adduser apps
    sudo su - apps
    ssh-keygen
    more ~/.ssh/id_rsa.pub
    git clone git@github.com:ascendbruce/rails101_practice.git rails101

用 root 權限 bundle

    sudo su -
    cd /home/apps/rails101
    gem i bundler
    bundle install
    exit

遇到 mysql2 gem build failed

    apt-get install libmysqlclient18 libmysqlclient18-dev
    gem i mysql2

修改 Gemfile

    - gem "sqlite"
    + gem "mysql2"

設定 database.yml

    vim config/database.yml

內容

    production:
      adapter: mysql2
      encoding: utf8
      reconnect: false
      pool: 5
      host: localhost
      database: rails101_production
      username: root
      password: bruce

建立資料庫

    RAILS_ENV=production rake db:create
    RAILS_ENV=production rake dev:rebuild
    RAILS_ENV=production rake dev:fake

設定 nginx server

    vim /opt/nginx/conf/nginx.conf

內容

    http {
        ...
        # comment out 原本的 server

        server {
           listen 80;
           server_name localhost;
           root /home/apps/rails101/public;   # <--- be sure to point to 'public'!
           passenger_enabled on;
        }

        ...
    }


### log內出現 `application.css isn't precompiled` 錯誤訊息

    ActionView::Template::Error (application.css isn't precompiled)

解法

    sudo su -
    gem install execjs therubyracer
    exit
    # 將 `gem "therubyracer"` 加入 Gemfile
    RAILS_ENV=production bundle exec rake assets:precompile
    touch tmp/restart.txt

## 設定 cap

### cap deploy:setup 因為無法用 bruce-exercise.pem 登入 apps 帳號導致詢問密碼

解法

1. 參考作業練習7，在local端產生id_rsa.pub
2. 將id_rsa.pub內容放到遠端的 ~/.ssh/authorized_keys 內
3. 確認可以直接透過shell免密碼登入
4. 如果之前有照網路上一些範例指示加上 ssh_options[:keys] 等，都要移除掉
5. 再run一次cap deploy:setup，應該就可以了

### cap deploy 期間發生 No such file or directory - /home/apps/rails101/releases/20130910063601/config/database.yml

原因是rails101教學內指定 after callbacks for `deploy:update_code'
結果 `deploy:assets:precompile` 更早遇到，在 rake assets:precompile 的時候就因為找不到/config/database.yml而炸了

解法

    after("deploy:update_code") do

改成

    before("deploy:assets:precompile") do

