.ONESHELL:


regression_random:
	cd ../..
	export VEXRISCV_REGRESSION_CONFIG_COUNT=4
	export VEXRISCV_REGRESSION_FREERTOS_COUNT=no
	export VEXRISCV_REGRESSION_THREAD_COUNT=1
	sbt "testOnly vexriscv.TestIndividualFeatures"

regression_random_linux:
	cd ../..
	export VEXRISCV_REGRESSION_CONFIG_LINUX_RATE=1.0
	export VEXRISCV_REGRESSION_CONFIG_COUNT=3
	export VEXRISCV_REGRESSION_FREERTOS_COUNT=no
	export VEXRISCV_REGRESSION_THREAD_COUNT=1
	sbt "testOnly vexriscv.TestIndividualFeatures"


regression_random_baremetal:
	cd ../..
	export VEXRISCV_REGRESSION_CONFIG_LINUX_RATE=0.0
	export VEXRISCV_REGRESSION_CONFIG_COUNT=50
	export VEXRISCV_REGRESSION_FREERTOS_COUNT=no
	export VEXRISCV_REGRESSION_THREAD_COUNT=1
	sbt "testOnly vexriscv.TestIndividualFeatures"



regression_dhrystone:
	cd ../..
	sbt "testOnly vexriscv.DhrystoneBench"
