#!/usr/bin/env python

from os import system
from sys import argv

project = "ivory-infusion-209508" 
zone = "europe-west1-b" 
instance = "miaou"

def local(cmd):
	print(cmd)
	system(cmd)

def remote(cmd):
	cmd = 'gcloud compute --project "{}" ssh --zone "{}" "{}" -- "{}"'.format(project, zone, instance, cmd)
	print(cmd)
	system(cmd)

def localToRemote(source, target):
	remote("rm -rf target")
	cmd = 'gcloud compute --project "{}" scp --zone "{}" {} {}:{}'.format(project, zone, source, instance, target)
	print(cmd)
	system(cmd)

#local("sbt test &")
local("python -c 'from os import system; system(\"(sbt test >> sbtTest.txt) &\")'")
#python -c 'from os import system; system("sbt test")' &
