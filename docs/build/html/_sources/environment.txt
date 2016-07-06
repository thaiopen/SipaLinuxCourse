===============
Lab Environment 
===============
การสร้าง lab environment จะใช้ vagrant ข้างล่างนี้

.. image:: images/installguidearch-neutron-networks.png

.. literalinclude:: ./Vagrantfile-lab1


Download complete file :download:`Vagrantfile-lab1 <./Vagrantfile-lab1>`::

    mkdir openstack2
    vagrant plugin install vagrant-scp
    sudo systemctl start firewalld

    wget https://thaiopen.github.io/SipaLinuxCourse/_downloads/Vagrantfile-lab1 
    
    mv Vagrantfile-lab1 Vagrantfile

    vagrant plugin install vagrant-scp
    sudo systemctl start firewalld

    cat << HOST  > hosts
    127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
    ::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
    10.0.0.11  controller.example.com  controller
    10.0.0.21  network.example.com  network
    10.0.0.31  compute1.example.com compute1
    10.0.0.32  compute2.example.com  compute2
    10.0.0.41  block1.example.com  block1
    10.0.0.51  object1.example.com  object1
    HOST

    cat << TEST > isconnect.sh
    #!/bin/bash
    ping -c 2 controller
    ping -c 2 network 
    ping -c 2 compute1
    ping -c 2 compute2
    ping -c 2 block1
    ping -c 2 object1 
    TEST

    node="controller network compute1 compute2 block1 object1"
    echo $node

    for n in $node; do vagrant scp hosts $n:/home/vagrant/;done
    for n in $node; do vagrant scp isconnect.sh $n:/home/vagrant/;done 

    for n in $node; do vagrant ssh $n -c "bash /home/vagrant/isconnect.sh"; done


ติดตั้ง package ที่ controller และโหนดอื่น แต่มีรายละเอียดของ ``/etc/chrony.conf`` โดยให้เครื่อง controller node 
ชี้ตรงไปยัง ntp server ส่วนเครื่องอื่นให้ชี้มาที่เครื่อง controller ติดตั้ง package ชื่อว่า chrony เพื่อต้องการ  sync เวลาให้กับทุกๆโหนด 
โดยสามารถที่จะเข้าไปยัง เครื่อง controller ได้จากเครื่อง host โดยการใช้คำสั่ง ``vagrant ssh controller`` 
โดยผ่านทาง secure shell ได้โดยตรง
::
   
    for n in $node; do vagrant ssh $n -c "sudo yum install chrony -y"; done
    vagrant ssh controller

    sudo su -   
    timedatectl

    vi /etc/chrony.conf 

เพิ่ม รายชื่อ ของ ntp server
::

   #line3
   server 0.centos.pool.ntp.org iburst
   server 1.centos.pool.ntp.org iburst
   server 2.centos.pool.ntp.org iburst
   server 3.centos.pool.ntp.org iburst

     #เปลี่ยนเป็็น

   server 1.th.pool.ntp.org iburst
   server 0.asia.pool.ntp.org iburst
   server 2.asia.pool.ntp.org iburst

     #อนุญาติให้ client เข้ามา sync
   #line21
   allow 10.0.0.0/24

     #ให้ restart service chrony.conf 
   systemctl list-unit-files | grep chrony
   systemctl start chronyd.service
   systemctl enable chronyd.service
   chronyc sources
   chronyc tracking

   exit
   exit
     #กลับออกไป ที่ host
