# This is very simple Makefile which encapsulates the build
# process of 'KadOS'. Type the following command
# for additional information:
#
# make help

.DEFAULT_GOAL := help

all: clean
	@{ \
		echo "Launching the main build script." ; \
		/usr/bin/time -f "\n  Elapsed time: %E" ./build.sh 2>&1 | tee KadOS.log ; \
		echo "" ; \
	}

clean:
	@{ \
		echo "Removing generated work artifacts." ; \
		rm -rf work ; \
		echo "Removing generated build artifacts." ; \
		rm -f KadOS.iso ; \
		rm -f KadOS.tgz ; \
		USE_PREDEFINED_KERNEL_CONFIG=`grep -i ^USE_PREDEFINED_KERNEL_CONFIG= .config | cut -f2- -d'=' | xargs` ; \
		if [ ! "$$USE_PREDEFINED_KERNEL_CONFIG" = "true" ] ; then \
			echo "Removing predefined Linux kernel config file." ; \
			rm -rf minimal_overlay/kernel.config ; \
		else \
			echo "Local Linux kernel config file is preserved." ; \
		fi ; \
		USE_PREDEFINED_BUSYBOX_CONFIG=`grep -i ^USE_PREDEFINED_BUSYBOX_CONFIG= .config | cut -f2- -d'=' | xargs` ; \
		if [ ! "$$USE_PREDEFINED_BUSYBOX_CONFIG" = "true" ] ; then \
			echo "Removing predefined BusyBox config file." ; \
			rm -rf minimal_overlay/busybox.config ; \
		else \
			echo "Local BusyBox config file is preserved." ; \
		fi ; \
		echo "Removing source level overlay software." ; \
		mv -f minimal_overlay/rootfs/README /tmp/mll_overlay_readme ; \
		cd minimal_overlay/rootfs ; \
		rm -rf * ; \
		cd ../.. ; \
		mv -f /tmp/mll_overlay_readme minimal_overlay/rootfs/README ; \
		echo "Removing build log file." ; \
		rm -f KadOS.log ; \
		USE_LOCAL_SOURCE=`grep -i ^USE_LOCAL_SOURCE= .config | cut -f2- -d'=' | xargs` ; \
		if [ ! "$$USE_LOCAL_SOURCE" = "true" ] ; then \
			echo "Removing local source files." ; \
			rm -rf source ; \
		else \
			echo "Local sources are preserved." ; \
		fi ; \
	}

qemu-bios:
	@{ \
		if [ ! -f ./KadOS.iso ] ; then \
			echo "" ; \
			echo "  ERROR: ISO image 'KadOS.iso' not found." ; \
			echo "" ; \
			exit 1 ; \
		fi ; \
		echo "Launching QEMU in BIOS mode." ; \
		./qemu-bios.sh ; \
	}

qemu-uefi:
	@{ \
		if [ ! -f ./KadOS.iso ] ; then \
			echo "" ; \
			echo "  ERROR: ISO image 'KadOS.iso' not found." ; \
			echo "" ; \
			exit 1 ; \
		fi ; \
		echo "Launching QEMU in UEFI mode." ; \
		./qemu-uefi.sh ; \
	}

src:
	@{ \
		echo "Generating source archive." ; \
		rm -f KadOS_*_src.tar.xz ; \
		cd minimal_overlay ; \
		./overlay_build.sh mll_source 1>/dev/null ; \
		cd .. ; \
		cp work/overlay/mll_source/*.tar.xz . ; \
		echo "Source archive is '`ls KadOS_*_src.tar.xz`'." ; \
	}

release: src
	@{ \
		echo "Removing old work artifacts." ; \
		rm -rf /tmp/mll_release ; \
		mkdir -p /tmp/mll_release ; \
		echo "Preparing MLL source tree." ; \
		cp KadOS_*_src.tar.xz /tmp/mll_release ; \
		cd /tmp/mll_release ; \
		tar -xf KadOS_*_src.tar.xz ; \
		cd /tmp/mll_release/KadOS_*/ ; \
		echo "Launching the main build script." ; \
		/usr/bin/time -f "\n  Elapsed time: %E" ./build.sh 2>&1 | tee KadOS.log ; \
		echo "" ; \
		echo "  Check the directory '/tmp/mll_release'." ; \
		echo "" ; \
	}

release2:
	@{ \
		echo "Removing old work artifacts." ; \
		rm -rf /tmp/mll_release2 ; \
		mkdir -p /tmp/mll_release2 ; \
		cd /tmp/mll_release2 ; \
		echo "Cloning the project repository." ; \
		git clone http://github.com/ivandavidov/minimal ; \
		cd minimal/src ; \
		echo "Ready to generate release." ; \
		make release ; \
	}

test:
	@{ \
		echo "" ; \
		echo "  This target is reserved for local tests." ; \
		echo "" ; \
	}

help:
	@{ \
		echo "" ; \
		echo "  make all       - clean the workspace and then generate 'KadOS.iso'." ; \
		echo "" ; \
		echo "  make clean     - remove all generated files." ; \
		echo "" ; \
		echo "  make help      - this is the default target." ; \
		echo "" ; \
		echo "  make release   - generate clean source tree in '/tmp/mll_release' and build MLL there." ; \
		echo "" ; \
		echo "  make release2  - clone the project repository and execute 'make release' from it." ; \
		echo "" ; \
		echo "  make src       - generate 'tar.xz' source archive." ; \
		echo "" ; \
		echo "  make qemu-bios - run 'KadOS' in QEMU with legacy BIOS compatibility." ; \
		echo "" ; \
		echo "  make qemu-uefi - run 'KadOS' in QEMU with UEFI compatibility." ; \
		echo "" ; \
	}
