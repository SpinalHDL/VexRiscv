#!/usr/bin/env python

from os import system
from sys import argv

def remote(cmd):
	cmd = "gcloud compute ssh miaou -- '" + cmd + "'"
	print(cmd)
	system(cmd)

def localToRemote(source, target):
	remote("rm -rf target")
	cmd = "gcloud compute scp " + source + " miaou:" + target
	print(cmd)
	system(cmd)

system("gcloud compute instances create miaou --machine-type=f1-micro")
system("rm -rf archive.tar.gz; git ls-files -z | xargs -0 tar -czf archive.tar.gz")
localToRemote("archive.tar.gz", "")
remote("tar -xzf archive.tar.gz")
remote("mkdir z;cd z; pwd")
remote("pwd")

