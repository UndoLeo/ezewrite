## ezewrite
ezewirte
1 complite all task with module 1 one by one
#Isp
apt-get install nano 
nano name.sh
copy code mdl1/isp/int
paste in nano
bash ./int
complete
#HQ-rtr
vi name.sh
copy code mdl1/hq/1_exec
paste vi 
type in term :wq!
next wget https://raw.githubusercontent.com/UndoLeo/ezewrite/refs/heads/main/www/mdl1/2_hq-rtr/2_Int-rtr.sh
hq-rtr complete
#BR-rtr
vi name.sh
copy code mdl1/hq/1_execbr
paste vi 
type in term :wq!
next wget https://raw.githubusercontent.com/UndoLeo/ezewrite/refs/heads/main/www/mdl1/3_br-rtr/2_br-int.sh
br-rtr complete
#br-srv
vi name.sh
copy code www/mdl1/4_br-srv/br-srv.sh
paste vi 
type in term :wq!
complete
#hqcli
vi name.sh
copy code www/mdl1/5_hq-cli/1.txt
paste vi 
complete
#hq-srv
vi name.sh
copy code www/mdl1/6_hq-srv/1_hq-srvinitF.sh
paste 
:wq!
wget https://raw.githubusercontent.com/UndoLeo/ezewrite/refs/heads/main/www/mdl1/6_hq-srv/2_exdnsS.sh
complet
#SSH
on br and hq 
wget https://raw.githubusercontent.com/UndoLeo/ezewrite/refs/heads/main/www/mdl1/7_SSH-SRV/sshex.sh
complet
#OSPF
on hq 
wget https://raw.githubusercontent.com/UndoLeo/ezewrite/refs/heads/main/www/mdl1/8_OSPF/1_hqosfp.sh
bash 1_hqosfp.sh
on br 
wget https://raw.githubusercontent.com/UndoLeo/ezewrite/refs/heads/main/www/mdl1/8_OSPF/2_osfpbrosfp.sh
bash 2_osfpbrosfp.sh
for all srv cli
wget https://raw.githubusercontent.com/UndoLeo/ezewrite/refs/heads/main/www/mdl1/8_OSPF/3_forall.sh
bash 3_forall.sh
 
