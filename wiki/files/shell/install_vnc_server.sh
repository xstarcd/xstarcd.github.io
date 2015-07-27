#!/bin/bash
#########################################
#Function:    install vnc server
#Usage:       bash install_vnc_server.sh
#Author:      Customer service department
#Company:     Alibaba Cloud Computing
#Version:     1.0
#########################################

check_os_release()
{
  while true
  do
    os_release=$(grep "Red Hat Enterprise Linux Server release" /etc/issue 2>/dev/null)
    os_release_2=$(grep "Red Hat Enterprise Linux Server release" /etc/redhat-release 2>/dev/null)
    if [ "$os_release" ] && [ "$os_release_2" ]
    then
      if echo "$os_release"|grep "release 5" >/dev/null 2>&1
      then
        os_release=redhat5
        echo "$os_release"
      elif echo "$os_release"|grep "release 6" >/dev/null 2>&1
      then
        os_release=redhat6
        echo "$os_release"
      else
        os_release=""
        echo "$os_release"
      fi
      break
    fi
    os_release=$(grep "CentOS release" /etc/issue 2>/dev/null)
    os_release_2=$(grep "CentOS release" /etc/*release 2>/dev/null)
    if [ "$os_release" ] && [ "$os_release_2" ]
    then
      if echo "$os_release"|grep "release 5" >/dev/null 2>&1
      then
        os_release=centos5
        echo "$os_release"
      elif echo "$os_release"|grep "release 6" >/dev/null 2>&1
      then
        os_release=centos6
        echo "$os_release"
      else
        os_release=""
        echo "$os_release"
      fi
      break
    fi
    os_release=$(grep -i "ubuntu" /etc/issue 2>/dev/null)
    os_release_2=$(grep -i "ubuntu" /etc/lsb-release 2>/dev/null)
    if [ "$os_release" ] && [ "$os_release_2" ]
    then
      if echo "$os_release"|grep "Ubuntu 10" >/dev/null 2>&1
      then
        os_release=ubuntu10
        echo "$os_release"
      elif echo "$os_release"|grep "Ubuntu 12" >/dev/null 2>&1
      then
        os_release=ubuntu12
        echo "$os_release"
      else
        os_release=""
        echo "$os_release"
      fi
      break
    fi
    os_release=$(grep -i "debian" /etc/issue 2>/dev/null)
    os_release_2=$(grep -i "debian" /proc/version 2>/dev/null)
    if [ "$os_release" ] && [ "$os_release_2" ]
    then
      if echo "$os_release"|grep "Linux 6" >/dev/null 2>&1
      then
        os_release=debian6
        echo "$os_release"
      else
        os_release=""
        echo "$os_release"
      fi
      break
    fi
    break
    done
}

exit_script()
{
  echo -e "\033[1;40;31mInstall $1 error,will exit.\n\033[0m"
  rm -f $LOCKfile
  exit 1
}

modify_rhel5_yum()
{
  rpm --import http://mirrors.163.com/centos/RPM-GPG-KEY-CentOS-5
  cd /etc/yum.repos.d/
  wget http://mirrors.163.com/.help/CentOS-Base-163.repo -O CentOS-Base-163.repo
  sed -i '/mirrorlist/d' CentOS-Base-163.repo
  sed -i 's/\$releasever/5/' CentOS-Base-163.repo
  yum clean metadata
  yum makecache
  cd ~
}

modify_rhel6_yum()
{
  rpm --import http://mirrors.163.com/centos/RPM-GPG-KEY-CentOS-6
  cd /etc/yum.repos.d/
  wget http://mirrors.163.com/.help/CentOS-Base-163.repo -O CentOS-Base-163.repo
  sed -i '/mirrorlist/d' CentOS-Base-163.repo
  sed -i '/\[addons\]/,/^$/d' CentOS-Base-163.repo
  sed -i 's/\$releasever/6/' CentOS-Base-163.repo
  sed -i 's/RPM-GPG-KEY-CentOS-5/RPM-GPG-KEY-CentOS-6/' CentOS-Base-163.repo
  yum clean metadata
  yum makecache
  cd ~
}

update_ubuntu10_apt_source()
{
echo -e "\033[40;32mBackup the original configuration file,new name and path is /etc/apt/sources.list.back.\n\033[40;37m"
cp -fp /etc/apt/sources.list /etc/apt/sources.list.back
cat > /etc/apt/sources.list <<EOF
#ubuntu
deb http://cn.archive.ubuntu.com/ubuntu/ maverick main restricted universe multiverse
deb http://cn.archive.ubuntu.com/ubuntu/ maverick-security main restricted universe multiverse
deb http://cn.archive.ubuntu.com/ubuntu/ maverick-updates main restricted universe multiverse
deb http://cn.archive.ubuntu.com/ubuntu/ maverick-proposed main restricted universe multiverse
deb http://cn.archive.ubuntu.com/ubuntu/ maverick-backports main restricted universe multiverse
deb-src http://cn.archive.ubuntu.com/ubuntu/ maverick main restricted universe multiverse
deb-src http://cn.archive.ubuntu.com/ubuntu/ maverick-security main restricted universe multiverse
deb-src http://cn.archive.ubuntu.com/ubuntu/ maverick-updates main restricted universe multiverse
deb-src http://cn.archive.ubuntu.com/ubuntu/ maverick-proposed main restricted universe multiverse
deb-src http://cn.archive.ubuntu.com/ubuntu/ maverick-backports main restricted universe multiverse
#163
deb http://mirrors.163.com/ubuntu/ maverick main universe restricted multiverse
deb-src http://mirrors.163.com/ubuntu/ maverick main universe restricted multiverse
deb http://mirrors.163.com/ubuntu/ maverick-security universe main multiverse restricted
deb-src http://mirrors.163.com/ubuntu/ maverick-security universe main multiverse restricted
deb http://mirrors.163.com/ubuntu/ maverick-updates universe main multiverse restricted
deb http://mirrors.163.com/ubuntu/ maverick-proposed universe main multiverse restricted
deb-src http://mirrors.163.com/ubuntu/ maverick-proposed universe main multiverse restricted
deb http://mirrors.163.com/ubuntu/ maverick-backports universe main multiverse restricted
deb-src http://mirrors.163.com/ubuntu/ maverick-backports universe main multiverse restricted
deb-src http://mirrors.163.com/ubuntu/ maverick-updates universe main multiverse restricted
#lupaworld
deb http://mirror.lupaworld.com/ubuntu/ maverick main universe restricted multiverse
deb-src http://mirror.lupaworld.com/ubuntu/ maverick main universe restricted multiverse
deb http://mirror.lupaworld.com/ubuntu/ maverick-security universe main multiverse restricted
deb-src http://mirror.lupaworld.com/ubuntu/ maverick-security universe main multiverse restricted
deb http://mirror.lupaworld.com/ubuntu/ maverick-updates universe main multiverse restricted
deb http://mirror.lupaworld.com/ubuntu/ maverick-proposed universe main multiverse restricted
deb-src http://mirror.lupaworld.com/ubuntu/ maverick-proposed universe main multiverse restricted
deb http://mirror.lupaworld.com/ubuntu/ maverick-backports universe main multiverse restricted
deb-src http://mirror.lupaworld.com/ubuntu/ maverick-backports universe main multiverse restricted
deb-src http://mirror.lupaworld.com/ubuntu/ maverick-updates universe main multiverse restricted
EOF
apt-get update
}

update_ubuntu12_apt_source()
{
echo -e "\033[40;32mBackup the original configuration file,new name and path is /etc/apt/sources.list.back.\n\033[40;37m"
cp -fp /etc/apt/sources.list /etc/apt/sources.list.back
cat > /etc/apt/sources.list <<EOF
#ubuntu
deb http://cn.archive.ubuntu.com/ubuntu/ precise main restricted universe multiverse
deb http://cn.archive.ubuntu.com/ubuntu/ precise-security main restricted universe multiverse
deb http://cn.archive.ubuntu.com/ubuntu/ precise-updates main restricted universe multiverse
deb http://cn.archive.ubuntu.com/ubuntu/ precise-proposed main restricted universe multiverse
deb http://cn.archive.ubuntu.com/ubuntu/ precise-backports main restricted universe multiverse
deb-src http://cn.archive.ubuntu.com/ubuntu/ precise main restricted universe multiverse
deb-src http://cn.archive.ubuntu.com/ubuntu/ precise-security main restricted universe multiverse
deb-src http://cn.archive.ubuntu.com/ubuntu/ precise-updates main restricted universe multiverse
deb-src http://cn.archive.ubuntu.com/ubuntu/ precise-proposed main restricted universe multiverse
deb-src http://cn.archive.ubuntu.com/ubuntu/ precise-backports main restricted universe multiverse
#163
deb http://mirrors.163.com/ubuntu/ precise main restricted
deb-src http://mirrors.163.com/ubuntu/ precise main restricted
deb http://mirrors.163.com/ubuntu/ precise-updates main restricted
deb-src http://mirrors.163.com/ubuntu/ precise-updates main restricted
deb http://mirrors.163.com/ubuntu/ precise universe
deb-src http://mirrors.163.com/ubuntu/ precise universe
deb http://mirrors.163.com/ubuntu/ precise-updates universe
deb-src http://mirrors.163.com/ubuntu/ precise-updates universe
deb http://mirrors.163.com/ubuntu/ precise multiverse
deb-src http://mirrors.163.com/ubuntu/ precise multiverse
deb http://mirrors.163.com/ubuntu/ precise-updates multiverse
deb-src http://mirrors.163.com/ubuntu/ precise-updates multiverse
deb http://mirrors.163.com/ubuntu/ precise-backports main restricted universe multiverse
deb-src http://mirrors.163.com/ubuntu/ precise-backports main restricted universe multiverse
deb http://mirrors.163.com/ubuntu/ precise-security main restricted
deb-src http://mirrors.163.com/ubuntu/ precise-security main restricted
deb http://mirrors.163.com/ubuntu/ precise-security universe
deb-src http://mirrors.163.com/ubuntu/ precise-security universe
deb http://mirrors.163.com/ubuntu/ precise-security multiverse
deb-src http://mirrors.163.com/ubuntu/ precise-security multiverse
deb http://extras.ubuntu.com/ubuntu precise main
deb-src http://extras.ubuntu.com/ubuntu precise main
#sohu
deb http://mirrors.sohu.com/ubuntu/ precise main restricted
deb-src http://mirrors.sohu.com/ubuntu/ precise main restricted
deb http://mirrors.sohu.com/ubuntu/ precise-updates main restricted
deb-src http://mirrors.sohu.com/ubuntu/ precise-updates main restricted
deb http://mirrors.sohu.com/ubuntu/ precise universe
deb-src http://mirrors.sohu.com/ubuntu/ precise universe
deb http://mirrors.sohu.com/ubuntu/ precise-updates universe
deb-src http://mirrors.sohu.com/ubuntu/ precise-updates universe
deb http://mirrors.sohu.com/ubuntu/ precise multiverse
deb-src http://mirrors.sohu.com/ubuntu/ precise multiverse
deb http://mirrors.sohu.com/ubuntu/ precise-updates multiverse
deb-src http://mirrors.sohu.com/ubuntu/ precise-updates multiverse
deb http://mirrors.sohu.com/ubuntu/ precise-backports main restricted universe multiverse
deb-src http://mirrors.sohu.com/ubuntu/ precise-backports main restricted universe multiverse
deb http://mirrors.sohu.com/ubuntu/ precise-security main restricted
deb-src http://mirrors.sohu.com/ubuntu/ precise-security main restricted
deb http://mirrors.sohu.com/ubuntu/ precise-security universe
deb-src http://mirrors.sohu.com/ubuntu/ precise-security universe
deb http://mirrors.sohu.com/ubuntu/ precise-security multiverse
deb-src http://mirrors.sohu.com/ubuntu/ precise-security multiverse
deb http://extras.ubuntu.com/ubuntu precise main
deb-src http://extras.ubuntu.com/ubuntu precise main
#cn99
deb http://ubuntu.cn99.com/ubuntu/ precise main restricted universe multiverse
deb http://ubuntu.cn99.com/ubuntu/ precise-updates main restricted universe multiverse
deb http://ubuntu.cn99.com/ubuntu/ precise-security main restricted universe multiverse
deb http://ubuntu.cn99.com/ubuntu/ precise-backports main restricted universe multiverse
deb http://ubuntu.cn99.com/ubuntu-cn/ precise main restricted universe multiverse
#uestc
deb http://ubuntu.uestc.edu.cn/ubuntu/ precise main restricted universe multiverse
deb http://ubuntu.uestc.edu.cn/ubuntu/ precise-backports main restricted universe multiverse
deb http://ubuntu.uestc.edu.cn/ubuntu/ precise-proposed main restricted universe multiverse
deb http://ubuntu.uestc.edu.cn/ubuntu/ precise-security main restricted universe multiverse
deb http://ubuntu.uestc.edu.cn/ubuntu/ precise-updates main restricted universe multiverse
deb-src http://ubuntu.uestc.edu.cn/ubuntu/ precise main restricted universe multiverse
deb-src http://ubuntu.uestc.edu.cn/ubuntu/ precise-backports main restricted universe multiverse
deb-src http://ubuntu.uestc.edu.cn/ubuntu/ precise-proposed main restricted universe multiverse
deb-src http://ubuntu.uestc.edu.cn/ubuntu/ precise-security main restricted universe multiverse
deb-src http://ubuntu.uestc.edu.cn/ubuntu/ precise-updates main restricted universe multiverse
#ustc
deb http://debian.ustc.edu.cn/ubuntu/ precise main restricted universe multiverse
deb http://debian.ustc.edu.cn/ubuntu/ precise-backports restricted universe multiverse
deb http://debian.ustc.edu.cn/ubuntu/ precise-proposed main restricted universe multiverse
deb http://debian.ustc.edu.cn/ubuntu/ precise-security main restricted universe multiverse
deb http://debian.ustc.edu.cn/ubuntu/ precise-updates main restricted universe multiverse
deb-src http://debian.ustc.edu.cn/ubuntu/ precise main restricted universe multiverse
deb-src http://debian.ustc.edu.cn/ubuntu/ precise-backports main restricted universe multiverse
deb-src http://debian.ustc.edu.cn/ubuntu/ precise-proposed main restricted universe multiverse
deb-src http://debian.ustc.edu.cn/ubuntu/ precise-security main restricted universe multiverse
deb-src http://debian.ustc.edu.cn/ubuntu/ precise-updates main restricted universe multiverse
#bjtu
deb http://mirror.bjtu.edu.cn/ubuntu/ precise main multiverse restricted universe
deb http://mirror.bjtu.edu.cn/ubuntu/ precise-backports main multiverse restricted universe
deb http://mirror.bjtu.edu.cn/ubuntu/ precise-proposed main multiverse restricted universe
deb http://mirror.bjtu.edu.cn/ubuntu/ precise-security main multiverse restricted universe
deb http://mirror.bjtu.edu.cn/ubuntu/ precise-updates main multiverse restricted universe
deb-src http://mirror.bjtu.edu.cn/ubuntu/ precise main multiverse restricted universe
deb-src http://mirror.bjtu.edu.cn/ubuntu/ precise-backports main multiverse restricted universe
deb-src http://mirror.bjtu.edu.cn/ubuntu/ precise-proposed main multiverse restricted universe
deb-src http://mirror.bjtu.edu.cn/ubuntu/ precise-security main multiverse restricted universe
deb-src http://mirror.bjtu.edu.cn/ubuntu/ precise-updates main multiverse restricted universe
#lupaworld
deb http://mirror.lupaworld.com/ubuntu/ precise main universe restricted multiverse
deb-src http://mirror.lupaworld.com/ubuntu/ precise main universe restricted multiverse
deb http://mirror.lupaworld.com/ubuntu/ precise-security universe main multiverse restricted
deb-src http://mirror.lupaworld.com/ubuntu/ precise-security universe main multiverse restricted
deb http://mirror.lupaworld.com/ubuntu/ precise-updates universe main multiverse restricted
deb http://mirror.lupaworld.com/ubuntu/ precise-proposed universe main multiverse restricted
deb-src http://mirror.lupaworld.com/ubuntu/ precise-proposed universe main multiverse restricted
deb http://mirror.lupaworld.com/ubuntu/ precise-backports universe main multiverse restricted
deb-src http://mirror.lupaworld.com/ubuntu/ precise-backports universe main multiverse restricted
deb-src http://mirror.lupaworld.com/ubuntu/ precise-updates universe main multiverse restricte
EOF
apt-get update
}


update_debian_apt_source()
{
echo -e "\033[40;32mBackup the original configuration file,new name and path is /etc/apt/sources.list.back.\n\033[40;37m"
cp -fp /etc/apt/sources.list /etc/apt/sources.list.back
cat > /etc/apt/sources.list <<EOF
#163
deb http://mirrors.163.com/debian squeeze main contrib non-free
deb-src http://mirrors.163.com/debian squeeze main contrib non-free
#debian
deb http://security.debian.org/ squeeze/updates main contrib
deb-src http://security.debian.org/ squeeze/updates main contrib
deb http://ftp.debian.org/debian/ squeeze-updates main contrib
deb-src http://ftp.debian.org/debian/ squeeze-updates main contrib
#cdn
deb http://cdn.debian.net/debian/ squeeze main
deb-src http://cdn.debian.net/debian/ squeeze main
deb http://cdn.debian.net/debian/ squeeze-updates main contrib
deb-src http://cdn.debian.net/debian/ squeeze-updates main contrib
#sohu
deb http://mirrors.sohu.com/debian squeeze main contrib non-free
deb-src http://mirrors.sohu.com/debian squeeze main contrib non-free
#163 update
deb http://mirrors.163.com/debian squeeze-proposed-updates main contrib non-free
deb-src http://mirrors.163.com/debian squeeze-proposed-updates main contrib non-free
#queeze-backports
deb http://mirrors.163.com/debian-backports/ squeeze-backports main contrib non-free
deb-src http://mirrors.163.com/debian-backports/ squeeze-backports main contrib non-free
#sohu update
deb http://mirrors.sohu.com/debian squeeze-proposed-updates main contrib non-free
deb-src http://mirrors.sohu.com/debian squeeze-proposed-updates main contrib non-free
#sjtu
deb http://ftp.sjtu.edu.cn/debian/ squeeze main non-free contrib
deb http://ftp.sjtu.edu.cn/debian/ squeeze-proposed-updates main non-free contrib
deb http://ftp.sjtu.edu.cn/debian-security/ squeeze/updates main non-free contrib
EOF
apt-get update
}

rhel5_vnc_config()
{
cat >$vnc_xstartup_config<<EOF
#!/bin/sh

# Uncomment the following two lines for normal desktop:
# unset SESSION_MANAGER
# exec /etc/X11/xinit/xinitrc

[ -x /etc/vnc/xstartup ] && exec /etc/vnc/xstartup
[ -r \$HOME/.Xresources ] && xrdb \$HOME/.Xresources
xsetroot -solid grey
vncconfig -iconic &
xterm -geometry 80x24+10+10 -ls -title "\$VNCDESKTOP Desktop" &
#twm &
gnome-session &
EOF
cat >$vnc_sysconfig_vncservers<<EOF
# The VNCSERVERS variable is a list of display:user pairs.
#
# Uncomment the lines below to start a VNC server on display :2
# as my 'myusername' (adjust this to your own).  You will also
# need to set a VNC password; run 'man vncpasswd' to see how
# to do that.
#
# DO NOT RUN THIS SERVICE if your local area network is
# untrusted!  For a secure way of using VNC, see
# <URL:http://www.uk.research.att.com/archive/vnc/sshvnc.html>.

# Use "-nolisten tcp" to prevent X connections to your VNC server via TCP.

# Use "-nohttpd" to prevent web-based VNC clients connecting.

# Use "-localhost" to prevent remote VNC clients connecting except when
# doing so through a secure tunnel.  See the "-via" option in the
# 'man vncviewer' manual page.

# VNCSERVERS="2:myusername"
# VNCSERVERARGS[2]="-geometry 800x600 -nolisten tcp -nohttpd -localhost"
VNCSERVERS="1:root"
EOF
}

check_selinux_config()
{
  if grep "SELINUX=enforcing" $selinux_config >/dev/null 2>&1
  then
    sed -i 's/SELINUX=enforcing/SELINUX=disabled/' $selinux_config
  fi
}

centos5_install_vnc_server()
{
  if [ "$1" == "redhat5" ]
  then
    if rpm -qa|grep redhat-logos >/dev/null 2>&1
    then
      yum remove $(rpm -qa|grep redhat-logos) -y
    fi
  fi
  if yum grouplist "GNOME Desktop Environment"|grep "Available" >/dev/null 2>&1
  then
    if ! yum groupinstall "GNOME Desktop Environment" -y
    then
      exit_script "GNOME Desktop Environment"
    fi
  fi
  if ! rpm -q vnc-server >/dev/null 2>&1
  then
    if ! yum install vnc-server -y
    then
      exit_script vnc-server
    fi
    vncserver <<EOF
$password
$password
EOF
  else
    vncpasswd <<EOF
$password
$password
EOF
  fi
  vncserver -kill :1
  service vncserver stop
  service pcscd stop
  chkconfig --del pcscd
  yum remove esc -y
  rhel5_vnc_config
  chmod 755 $vnc_xstartup_config
  chkconfig --level 345 vncserver on
  service NetworkManager stop
  chkconfig --del NetworkManager
  check_selinux_config
  sleep 20
  service vncserver start
}

centos6_install_vnc_server()
{
  if yum grouplist "X Window System"|grep "Available" >/dev/null 2>&1
  then
    if ! yum groupinstall "X Window System" -y
    then
      exit_script "X Window System"
    fi
  fi
  if yum grouplist "Desktop"|grep "Available" >/dev/null 2>&1
  then
    if ! yum groupinstall "Desktop" -y
    then
      exit_script Desktop
    fi
  fi
  if yum grouplist "Chinese Support"|grep "Available" >/dev/null 2>&1
  then
    if ! yum groupinstall "Chinese Support" -y
    then
      exit_script "Chinese Support"
    fi
  fi
  if ! rpm -q tigervnc-server >/dev/null 2>&1
  then
    if ! yum install tigervnc-server -y
    then
      exit_script tigervnc-server
    fi
    vncserver <<EOF
$password
$password
EOF
  else
    vncpasswd <<EOF
$password
$password
EOF
  fi
  vncserver -kill :1
  service vncserver stop
  service pcscd stop
  chkconfig --del pcscd
  yum remove esc -y
  sed -i 's/.*!= root.*/#&/' /etc/pam.d/gdm 
  dbus-uuidgen >/var/lib/dbus/machine-id
  rhel5_vnc_config
  chmod 755 $vnc_xstartup_config
  chkconfig --level 345 vncserver on
  service NetworkManager stop
  chkconfig --del NetworkManager
  sleep 20
  service vncserver start
  check_selinux_config
}

ubuntu_install_vnc_server()
{
  if ! dpkg -s lxde >/dev/null 2>&1
  then
    if ! apt-get install lxde -y --force-yes --fix-missing
    then
      exit_script lxde
    fi
  fi
  if ! dpkg -s ttf-arphic-uming >/dev/null 2>&1
  then
    if ! apt-get install ttf-arphic-uming -y --force-yes --fix-missing
    then
      exit_script ttf-arphic-uming
    fi
  fi
  if ! dpkg -s vnc4server >/dev/null 2>&1
  then
    if ! apt-get install vnc4server -y --force-yes --fix-missing
    then
      exit_script vnc4server
    fi
    vncserver <<EOF
$password
$password
EOF
  else
    vncpasswd <<EOF
$password
$password
EOF
  fi
  vncserver -kill :1
  sed -i 's/x-window-manager \&/startlxde \&/' $vnc_xstartup_config
  sed -i '/vncserver/d' $rc_local
  sed -i 's/^exit 0$/su root \-c "\/usr\/bin\/vncserver \-name my-vnc-server \-geometry 1280x800 \:1"\nexit 0/' $rc_local
  sleep 5
  vncserver
}


####################Start###################
#check lock file ,one time only let the script run one time 
LOCKfile=/tmp/.$(basename $0)
if [ -f "$LOCKfile" ]
then
  echo -e "\033[1;40;31mThe script is already exist,please next time to run this script.\n\033[0m"
  exit
else
  echo -e "\033[40;32mStep 1.No lock file,begin to create lock file and continue.\n\033[40;37m"
  touch $LOCKfile
fi

#check user
if [ $(id -u) != "0" ]
then
  echo -e "\033[1;40;31mError: You must be root to run this script, please use root to install this script.\n\033[0m"
  rm -f $LOCKfile
  exit 1
fi

vnc_xstartup_config=/root/.vnc/xstartup
vnc_sysconfig_vncservers=/etc/sysconfig/vncservers
selinux_config=/etc/selinux/config
rc_local=/etc/rc.local
password=$(cat /dev/urandom | head -1 | md5sum | head -c 6)

echo -e "\033[40;32mStep 2.Begen to check the OS issue.\n\033[40;37m"
os_release=$(check_os_release)
if [ "X$os_release" == "X" ]
then
  echo -e "\033[1;40;31mThe OS does not identify,So this script is not executede.\n\033[0m"
  rm -f $LOCKfile
  exit 0
else
  echo -e "\033[40;32mThis OS is $os_release.\n\033[40;37m"
fi

echo -e "\033[40;32mStep 3.Begen to modify the source configration file and update.\n\033[40;37m"
case "$os_release" in
redhat5|centos5)
  modify_rhel5_yum
  ;;
redhat6|centos6)
  modify_rhel6_yum
  ;;
ubuntu10)
  update_ubuntu10_apt_source
  ;;
ubuntu12)
  update_ubuntu12_apt_source
  ;;
debian6)
  update_debian_apt_source
  ;;
esac

echo -e "\033[40;32mStep 4.Begen to check and install vnc server.\n\033[40;37m"
case "$os_release" in
redhat5|centos5)
  centos5_install_vnc_server $os_release
  ;;
redhat6|centos6)
  centos6_install_vnc_server $os_release
  ;;
ubuntu10|ubuntu12|debian6)
  ubuntu_install_vnc_server
  ;;
esac

echo -e "\033[40;32m.Install success.The vnc password is \"$password\",this script now exit!\n\033[40;37m"
rm -f $LOCKfile