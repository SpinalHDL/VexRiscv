#!/usr/bin/env python

from gcloud import GCInstance

gci = GCInstance("vexriscv")
gci.create()
gci.start()
gci.remoteToLocal("run.txt","run.txt")
gci.stop()
gci.delete()
