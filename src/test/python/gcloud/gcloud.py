#!/usr/bin/env python

from os import system
from sys import argv
import time

class GCInstance:
	def __init__(self, name):
		self.instance = name
		self.project = "ivory-infusion-209508" 
		self.zone = "europe-west1-b" 

	def local(self, cmd):
		print(cmd)
		system(cmd)

	def createCustom(self, cores=1, ram=1024):
		self.create("custom-{}-{}".format(cores,ram))

	#n1-highcpu-8
	def create(self, machine="f1-micro", args = "--preemptible"):
		self.delete()
		self.local('gcloud beta compute --project=ivory-infusion-209508 instances create {} --zone=europe-west1-b --machine-type={} --subnet=default --network-tier=PREMIUM --no-restart-on-failure --maintenance-policy=TERMINATE {} --service-account=470010940365-compute@developer.gserviceaccount.com --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append --disk=name=miaou,device-name=miaou,mode=rw,boot=yes'.format(self.instance, machine, args))


	def stopScript(self, script):
		self.local('gcloud compute --project {}  instances add-metadata {} --metadata-from-file shutdown-script={} --zone "{}"'.format(self.project, self.instance, script, self.zone))

	def start(self):
		self.local('gcloud compute --project "{}" instances start --zone "{}" "{}"'.format(self.project, self.zone, self.instance))  # --machine-type=f1-micro
		time.sleep(60) 


	def stopHours(self, hours):
		self.remote('sudo shutdown -P +{}'.format(int(hours*60)))

	def stop(self):
		self.remote('sudo shutdown -P now')

	def delete(self):
		self.local('gcloud compute --project "{}" instances delete "{}"  --zone "{}" --keep-disks all --quiet'.format(self.project, self.instance, self.zone))

	def remote(self, cmd):
		self.local('gcloud compute --project "{}" ssh --zone "{}" "{}" -- "{}"'.format(self.project, self.zone, self.instance, cmd))

	def localToRemote(self, source, target):
		self.remote("rm -rf {}".format(target))
		self.local('gcloud compute --project "{}" scp --zone "{}" {} {}:{}'.format(self.project, self.zone, source, self.instance, target))

	def remoteToLocal(self, source, target):
		self.remote("rm -rf {}".format(target))
		self.local('gcloud compute --project "{}" scp --zone "{}" {}:{} {}'.format(self.project, self.zone, self.instance, source,  target))

#setsid nohup (sbt test;sudo poweroff) &> sbtTest.txt
