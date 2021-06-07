#!/bin/bash
red() {
  printf '\e[1;31m%s\n\e[0;39;49m' "$@"
}
green() {
  printf '\e[1;32m%s\n\e[0;39;49m' "$@"
}
blue() {
  printf '\e[1;36m%s\n\e[0;39;49m' "$@"
}
pink() {
  printf '\e[1;35m%s\n\e[0;39;49m' "$@"
}
brown() {
  printf '\e[1;33m%s\n\e[0;39;49m' "$@"
}
pakage() {
	blue 'Start Install Package'
	echo ""
	sudo add-apt-repository -y ppa:ubuntu-toolchain-r/test
	sudo apt-get install g++-4.7 -y c++-4.7 -y
	sudo apt-get update
	sudo apt-get upgrade -y
	sudo apt-get install libreadline-dev -y libconfig-dev -y libssl-dev -y lua5.2 -y liblua5.2-dev -y lua-socket -y lua-sec -y lua-expat -y libevent-dev -y make unzip git redis-server autoconf g++ -y libjansson-dev -y libpython-dev -y expat libexpat1-dev -y
	sudo apt-get install screen -y
	sudo apt-get install tmux -y
	sudo apt-get install libstdc++6 -y
	sudo apt-get install lua-lgi -y
	sudo apt-get install libnotify-dev
	sudo cp /usr/share/zoneinfo/Asia/Tehran /etc/localtime
	sudo apt-get install axel
	axel http://luarocks.org/releases/luarocks-2.2.2.tar.gz
	tar zxpf luarocks-2.2.2.tar.gz
	rm luarocks-2.2.2.tar.gz
	cd luarocks-2.2.2
	./configure
	make build
	make install
	sudo make bootstrap
	sudo apt-get install libnotify-dev -y
	sudo luarocks install serpent
	sudo luarocks install redis-lua
	sudo luarocks install json-lua
	sudo luarocks install lua-cjson
	cd ..
	rm -rf luarocks-2.2.2
	sudo rm -rf /usr/local/lib/lua/5.2/cjson.so && wget http://telepremium.ir/download/cjson.so && sudo mv cjson.so /usr/local/lib/lua/5.2 && sudo chmod +x /usr/local/lib/lua/5.2/cjson.so
	echo ""
blue 'All Package Installed'
}
install() {
		wget https://valtman.name/files/telegram-bot-180116-nightly-linux --no-check-certificate
		mv telegram-bot-180116-nightly-linux tg
		chmod +x tg
		mkdir Data
		sudo rm -rf /usr/local/lib/lua/5.2/tdbot.lua && wget http://telepremium.ir/TelePremium/tdbot.lua && sudo mv tdbot.lua /usr/local/lib/lua/5.2
}
reconfig () {
 rm -rf DataConfig.lua
 rm -rf Auto
 cd ../
 rm -rf .telegram-bot
 cd self
 echo ""
 echo ""
 red "اطلاعات قدیمی پاک شد"
}
 setdata() {
red "لطفا اطلاعات مربوطه را تکمیل کنید :"
echo ""
blue  "آیدی اکانت : "; tput sc; read sudo; echo ""
blue  "آیدی سازنده : "; tput sc; read creator; echo ""
blue  "شماره ردیس : "; tput sc; read redis; echo ""
blue  "نام اکانت : "; tput sc; read ProfileAcc; echo ""

cat <<EOF > DataConfig.lua
--- اطلاعات ربات ----
do 
    local _ = {
RedisIndex = $redis,
Fullsudo = $sudo,
Creator = $creator,
ProfileUser = "$ProfileAcc"
}
return _
end
EOF
echo ""
green "اطلاعات ذخیره شد."
mv DataConfig.lua Data
mv HelpSelf.pdf Data

}
login() {
rm -rf ~/.telegram-bot/$ProfileAcc 
	red  "لطفا شماره خود را ارسال کنید: "; tput sc; read v1; ./tg -p $ProfileAcc --login --phone=$v1
}

auto() {
echo "#!/bin/sh
VAR=\"\${HOME}/TelePremium-Self\"
if [ ! \$1 ]; then
	tmux new-session -d -s 'self_'$ProfileAcc \"\$VAR/Auto run\"
	echo \"self [$ProfileAcc] started\"
elif [ \"\$1\" = \"run\" ]; then
	cd \$VAR
	while true; do
		screen ./tg -p $ProfileAcc -s \$VAR/bot.lua | grep -v \"{\"
		killall screen
		screen -wipe
	done
fi" > Auto
chmod +x Auto
	sed -i -e 's/\r$//' Auto
green "فایل اتو لانچ ساخته شد."
green "جهت اتولانچ ./Auto ارسال کنید"
}

blue "انتخاب کنید:"
blue "1= نصب برای اولین بار"
blue "2= نصب مجدد"
blue "3= نصب پیشنیاز"
read choose
if [ "$choose" = "1" ]; then
	install
	echo ""
	echo ""
	setdata
	echo ""
	echo ""
	login
	echo ""
	echo ""
	auto
	echo ""
	echo ""
elif [ "$choose" = "2" ]; then
	reconfig
	echo ""
	echo ""
	setdata
	echo ""
	echo ""
	login
	echo ""
	echo ""
	auto
	echo ""
	echo ""
	elif [ "$choose" = "3" ]; then
	pakage
	echo ""
	echo ""
fi