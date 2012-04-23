#!/bin/sh

#Install libraries from apt
sudo apt-get install openssl libssl-dev binutils g++ gcc

#Check if node exists
node=`which node 2>&1`
ret=$?
if [ $ret -ne 0 ] || ! [ -x "$node" ]; then
  echo "Installing node"
  mkdir -p node
  cd node
  curl http://nodejs.org/dist/node-v0.6.15.tar.gz > node.tgz
  tar xzf node.tgz
  cd node-v0.6.15
  ./configure
  make
  sudo make install
  cd ../..
  rm -rf node
fi

#Check if npm exists
npm=`which npm 2>&1`
ret=$?
#if [ $ret -ne 0 ] || ! [ -x "$npm" ]; then
  echo "Installing npm"
  mkdir -p npm
  cd npm
  curl http://npmjs.org/install.sh > install.sh
  sudo sh install.sh
  cd ..
  rm -rf npm
#fi

#Install npm packages
echo "Installing NPM packages"
npm install ws mongodb optimist browserify openid uglify-js patcher

#Download and unzip mongodb locally
mongo=`which mongo/mongo 2>&1`
ret=$?
if [ $ret -ne 0 ] || ! [ -x "$mongo" ]; then
  echo "Installing local copy of mongodb"
  rm -rf mongo
  mkdir -p mongo
  cd mongo
  
  mongourl="http://downloads.mongodb.org/linux/mongodb-linux-i686-static-2.0.4.tgz"
  if [ `uname -m` -eq "x86_64" ]; then
    mongourl="http://fastdl.mongodb.org/linux/mongodb-linux-x86_64-static-legacy-2.0.4.tgz"
  fi
  curl $mongourl  > mongo.tgz
  tar xzf mongo.tgz
  mv mongodb-*/bin/* .
  rm -rf mongo.tgz mongodb-* 
  mkdir db
  echo 'dbpath    = ./mongo/db
logpath   = ./mongo/mongodb.log
bind_ip   = 127.0.0.1
port      = 27017
logappend = true
auth      = false' > config.txt
  cd ..
fi

