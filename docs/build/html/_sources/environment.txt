===============
Lab Environment 
===============
การสร้าง lab environment จะใช้ vagrant ข้างล่างนี้

.. image:: images/installguidearch-neutron-networks.png

.. literalinclude:: ./Vagrantfile-lab1


Download complete file :download:`Vagrantfile-lab1 <./Vagrantfile-lab1>`::

    mkdir openstack2
    wget https://thaiopen.github.io/SipaLinuxCourse/_downloads/Vagrantfile-lab1 
    wget 
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

    for n in $node; do vagrant scp hosts $n:/home/vagrant/;done
    for n in $node; do vagrant scp isconnect.sh $n:/home/vagrant/;done 

    for n in $node; do vagrant ssh $n -c "bash /home/vagrant/isconnect.sh"; done



