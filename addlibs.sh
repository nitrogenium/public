cd /tmp
wget http://archive.ubuntu.com/ubuntu/pool/main/b/boost1.71/libboost-filesystem1.71.0_1.71.0-6ubuntu6_amd64.deb
wget http://mirrors.xmission.com/ubuntu/pool/main/g/gcc-10/libgcc-s1_10-20200411-0ubuntu1_amd64.deb
wget http://mirrors.edge.kernel.org/ubuntu/pool/main/g/gcc-10/gcc-10-base_10-20200411-0ubuntu1_amd64.deb
wget http://archive.ubuntu.com/ubuntu/pool/main/b/boost1.71/libboost-program-options1.71.0_1.71.0-6ubuntu6_amd64.deb
wget http://archive.ubuntu.com/ubuntu/pool/main/libe/libevent/libevent-2.1-7_2.1.11-stable-1_amd64.deb
wget http://archive.ubuntu.com/ubuntu/pool/main/g/gcc-10/libstdc++6_10-20200411-0ubuntu1_amd64.deb
dpkg -i gcc-10-base_10-20200411-0ubuntu1_amd64.deb
dpkg -i libgcc-s1_10-20200411-0ubuntu1_amd64.deb
dpkg -i libboost-filesystem1.71.0_1.71.0-6ubuntu6_amd64.deb
dpkg -i libboost-program-options1.71.0_1.71.0-6ubuntu6_amd64.deb
dpkg -i libevent-2.1-7_2.1.11-stable-1_amd64.deb
dpkg -i libstdc++6_10-20200411-0ubuntu1_amd64.deb
