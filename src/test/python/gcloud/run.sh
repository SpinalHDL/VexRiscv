rm -rf sbtTest.txt
rm -rf VexRiscv
rm -rf SpinalHDL
#git clone https://github.com/SpinalHDL/SpinalHDL.git -b dev
mkdir SpinalHDL
tar -xzf spinal.tar.gz -C SpinalHDL
mkdir VexRiscv
tar -xzf archive.tar.gz -C VexRiscv
cd VexRiscv
sudo git init
sudo git add *
sudo git commit -m miaou
export VEXRISCV_REGRESSION_CONFIG_COUNT=128
export VEXRISCV_REGRESSION_FREERTOS_COUNT=30
sbt test
cd ..

#sudo apt-get install mailutils + https://cloud.google.com/compute/docs/tutorials/sending-mail/using-mailgun
echo "Miaou" | mail -s "VexRiscv cloud" charles.papon.90@gmail.com -A run.txt
sleep 15

sudo shutdown -P now


