rm -rf sbtTest.txt
rm -rf VexRiscv
mkdir VexRiscv
tar -xzf archive.tar.gz -C VexRiscv
cd VexRiscv

export VEXRISCV_REGRESSION_CONFIG_COUNT=16
export VEXRISCV_REGRESSION_FREERTOS_COUNT=yes
sbt test
cd ..

#sudo apt-get install mailutils + https://cloud.google.com/compute/docs/tutorials/sending-mail/using-mailgun
echo "Miaou" | mail -s "VexRiscv cloud" charles.papon.90@gmail.com -A run.txt
sleep 15

sudo shutdown -P now


