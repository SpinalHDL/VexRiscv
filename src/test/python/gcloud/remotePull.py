#!/usr/bin/env python

from gcloud import GCInstance

gci = GCInstance("vexriscv")
gci.create()
gci.start()
gci.remoteToLocal("VexRiscv/sbtTest.txt","sbtTest.txt")
gci.stop()
gci.delete()
