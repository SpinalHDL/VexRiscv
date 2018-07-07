#!/usr/bin/env python

from os import system
from sys import argv

from gcloud import GCInstance

gci = GCInstance("vexriscv")
gci.create("n1-highcpu-8")
gci.start()
gci.stopHours(20)

gci.local("rm -rf archive.tar.gz; git ls-files -z | xargs -0 tar -czf archive.tar.gz")
gci.localToRemote("archive.tar.gz", "")
gci.localToRemote("src/test/python/gcloud/run.sh", "")
gci.remote("rm -rf run.txt; setsid nohup sh run.sh &> run.txt")

#setsid nohup (sbt test;sudo poweroff) &> sbtTest.txt
