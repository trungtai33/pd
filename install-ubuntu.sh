#!/data/data/com.termux/files/usr/bin/bash
if [ "$(uname -o)" != "Android" ]; then
	printf "\n\e[31mError: This script only executes on Termux.\e[0m\n\n"
	exit 1
fi
case "$(uname -m)" in
	aarch64)
		arch="arm64"
		multiarch="aarch64-linux-gnu"
		;;
	armv7l|armv8l)
		arch="armhf"
		multiarch="arm-linux-gnueabihf"
		;;
	x86_64)
		arch="amd64"
		multiarch="x86_64-linux-gnu"
		;;
	*)
		printf "\n\e[31mError: Architecture '$(uname -m)' is not supported.\e[0m\n\n"
		exit 1
		;;
esac
for i in curl dialog proot; do
	if [ -z "$(command -v ${i})" ]; then
		printf "\n\e[31mError: '${i}' is not installed.\e[0m\n\n"
		exit 1
	fi
done
version=$(dialog --title "Ubuntu Installer" --inputbox "Enter the version code name:" 8 50 2>&1 > /dev/tty); clear
if [ -z "${version}" ]; then
	exit 1
fi
directory="ubuntu-${version}"
distribution="Ubuntu (${version})"
if [ -d "${PREFIX}/share/${directory}" ]; then
	printf "\n\e[31mError: '${distribution}' is already installed.\e[0m\n\n"
	exit 1
fi
mkdir -p "${PREFIX}/share/${directory}/rootfs"
tarball="${PREFIX}/share/${directory}/rootfs.tar.gz"
printf "\n\e[34m[\e[32m*\e[34m]\e[36m Downloading ${distribution}, please wait...\e[34m\n\n"
if ! curl --location --output "${tarball}" \
	"https://partner-images.canonical.com/core/${version}/current/ubuntu-${version}-core-cloudimg-${arch}-root.tar.gz"; then
	printf "\e[0m\n\e[34m[\e[31m!\e[34m]\e[31m Download failed, please check your network connection.\e[0m\n\n"
	rm -rf "${PREFIX}/share/${directory}"
	exit 1
fi
printf "\e[0m\n\e[34m[\e[32m*\e[34m]\e[36m Installing ${distribution}, please wait...\e[0m\n"
if ! proot --link2symlink \
	tar -xf "${tarball}" --directory="${PREFIX}/share/${directory}/rootfs" --exclude='dev' > /dev/null 2>&1; then
	printf "\e[34m[\e[31m!\e[34m]\e[31m Installation failed, please check version code name.\e[0m\n\n"
	rm -rf "${PREFIX}/share/${directory}"
	exit 1
fi
rm -f "${tarball}"
cat <<- EOF > "${PREFIX}/share/${directory}/rootfs/etc/ld.so.preload"
	/lib/${multiarch}/libgcc_s.so.1
	EOF
cat <<- EOF > "${PREFIX}/share/${directory}/rootfs/etc/profile.d/config.sh"
	export LANG="C.UTF-8"
	export MOZ_FAKE_NO_SANDBOX="1"
	export PULSE_SERVER="127.0.0.1"
	EOF
rm -f "${PREFIX}/share/${directory}/rootfs/etc/resolv.conf"
cat <<- EOF > "${PREFIX}/share/${directory}/rootfs/etc/resolv.conf"
	nameserver 8.8.8.8
	nameserver 8.8.4.4
	EOF
rm -f "${PREFIX}/share/${directory}/rootfs/etc/hosts"
cat <<- EOF > "${PREFIX}/share/${directory}/rootfs/etc/hosts"
	127.0.0.1  localhost
	::1        localhost ip6-localhost ip6-loopback
	EOF
while read groupname groupid; do
	chmod +w "${PREFIX}/share/${directory}/rootfs/etc/group"
	cat <<- EOF >> "${PREFIX}/share/${directory}/rootfs/etc/group"
		${groupname}:x:${groupid}:
		EOF
	chmod +w "${PREFIX}/share/${directory}/rootfs/etc/gshadow"
	cat <<- EOF >> "${PREFIX}/share/${directory}/rootfs/etc/gshadow"
		${groupname}:!::
		EOF
done < <(paste <(id -Gn | tr ' ' '\n') <(id -G | tr ' ' '\n'))
cat <<- EOF > "${PREFIX}/share/${directory}/loadavg"
	0.35 0.22 0.15 1/575 7767
	EOF
cat <<- EOF > "${PREFIX}/share/${directory}/stat"
	cpu  265542 13183 24203 611072 152293 68 191340 255 0 0 0
	cpu0 265542 13183 24203 611072 152293 68 191340 255 0 0 0
	intr 815181 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
	ctxt 90620544
	btime 163178502
	processes 25384
	procs_running 2
	procs_blocked 0
	softirq 1857962 55 2536781 34 1723322 8 2457784 5 1914410
	EOF
cat <<- EOF > "${PREFIX}/share/${directory}/uptime"
	11965.80 11411.22
	EOF
cat <<- EOF > "${PREFIX}/share/${directory}/vmstat"
	nr_free_pages 705489
	nr_alloc_batch 0
	nr_inactive_anon 1809
	nr_active_anon 61283
	nr_inactive_file 69543
	nr_active_file 58416
	nr_unevictable 64
	nr_mlock 64
	nr_anon_pages 60894
	nr_mapped 99503
	nr_file_pages 130218
	nr_dirty 9
	nr_writeback 0
	nr_slab_reclaimable 2283
	nr_slab_unreclaimable 3714
	nr_page_table_pages 1911
	nr_kernel_stack 687
	nr_unstable 0
	nr_bounce 0
	nr_vmscan_write 0
	nr_vmscan_immediate_reclaim 0
	nr_writeback_temp 0
	nr_isolated_anon 0
	nr_isolated_file 0
	nr_shmem 2262
	nr_dirtied 3675
	nr_written 3665
	nr_pages_scanned 0
	workingset_refault 1183
	workingset_activate 1183
	workingset_nodereclaim 0
	nr_anon_transparent_hugepages 0
	nr_free_cma 0
	nr_dirty_threshold 21574
	nr_dirty_background_threshold 5393
	pgpgin 541367
	pgpgout 23248
	pswpin 1927
	pswpout 2562
	pgalloc_dma 182
	pgalloc_normal 76067
	pgalloc_high 326333
	pgalloc_movable 0
	pgfree 1108260
	pgactivate 53201
	pgdeactivate 2592
	pgfault 420060
	pgmajfault 4323
	pgrefill_dma 0
	pgrefill_normal 2589
	pgrefill_high 0
	pgrefill_movable 0
	pgsteal_kswapd_dma 0
	pgsteal_kswapd_normal 0
	pgsteal_kswapd_high 0
	pgsteal_kswapd_movable 0
	pgsteal_direct_dma 0
	pgsteal_direct_normal 1211
	pgsteal_direct_high 7987
	pgsteal_direct_movable 0
	pgscan_kswapd_dma 0
	pgscan_kswapd_normal 0
	pgscan_kswapd_high 0
	pgscan_kswapd_movable 0
	pgscan_direct_dma 0
	pgscan_direct_normal 4172
	pgscan_direct_high 25365
	pgscan_direct_movable 0
	pgscan_direct_throttle 0
	pginodesteal 0
	slabs_scanned 9728
	kswapd_inodesteal 0
	kswapd_low_wmark_hit_quickly 0
	kswapd_high_wmark_hit_quickly 0
	pageoutrun 1
	allocstall 189
	pgrotated 7
	drop_pagecache 0
	drop_slab 0
	htlb_buddy_alloc_success 0
	htlb_buddy_alloc_fail 0
	unevictable_pgs_culled 64
	unevictable_pgs_scanned 0
	unevictable_pgs_rescued 0
	unevictable_pgs_mlocked 64
	unevictable_pgs_munlocked 0
	unevictable_pgs_cleared 0
	unevictable_pgs_stranded 0
	EOF
cat <<- EOF > "${PREFIX}/share/${directory}/model"
	$(getprop ro.product.brand) $(getprop ro.product.model)
	EOF
cat <<- EOF > "${PREFIX}/share/${directory}/version"
	Linux version $(uname -r) (termux@android) (gcc version 4.9.0 (GCC)) $(uname -v)
	EOF
cat <<- EOF > "${PREFIX}/bin/start-${directory}"
	#!/data/data/com.termux/files/usr/bin/bash
	unset LD_PRELOAD
	cmdline="proot"
	cmdline+=" --kernel-release=$(uname -r)"
	cmdline+=" --kill-on-exit"
	cmdline+=" --link2symlink"
	cmdline+=" --root-id"
	cmdline+=" --rootfs=\${PREFIX}/share/${directory}/rootfs"
	cmdline+=" --bind=/dev"
	cmdline+=" --bind=/dev/urandom:/dev/random"
	cmdline+=" --bind=/proc"
	cmdline+=" --bind=/proc/self/fd:/dev/fd"
	cmdline+=" --bind=/proc/self/fd/0:/dev/stdin"
	cmdline+=" --bind=/proc/self/fd/1:/dev/stdout"
	cmdline+=" --bind=/proc/self/fd/2:/dev/stderr"
	cmdline+=" --bind=/sys"
	cmdline+=" --bind=/storage/emulated/0:/sdcard"
	cmdline+=" --bind=/data/data/com.termux"
	cmdline+=" --bind=\${PREFIX}/share/${directory}/rootfs/tmp:/dev/shm"
	if ! cat /proc/loadavg > /dev/null 2>&1; then
	        cmdline+=" --bind=\${PREFIX}/share/${directory}/loadavg:/proc/loadavg"
	fi
	if ! cat /proc/stat > /dev/null 2>&1; then
	        cmdline+=" --bind=\${PREFIX}/share/${directory}/stat:/proc/stat"
	fi
	if ! cat /proc/uptime > /dev/null 2>&1; then
	        cmdline+=" --bind=\${PREFIX}/share/${directory}/uptime:/proc/uptime"
	fi
	if ! cat /proc/vmstat > /dev/null 2>&1; then
	        cmdline+=" --bind=\${PREFIX}/share/${directory}/vmstat:/proc/vmstat"
	fi
	cmdline+=" --bind=\${PREFIX}/share/${directory}/model:/sys/firmware/devicetree/base/model"
	cmdline+=" --bind=\${PREFIX}/share/${directory}/version:/proc/version"
	cmdline+=" --bind=\${PREFIX}/tmp:/tmp"
	cmdline+=" /usr/bin/env --ignore-environment"
	cmdline+=" TERM=\${TERM-xterm-256color}"
	cmdline+=" /bin/su --login"
	cmd="\$@"; [ -z "\$1" ] && exec \${cmdline} || \${cmdline} "\${cmd}"
	EOF
chmod +x "${PREFIX}/bin/start-${directory}"
printf "\e[34m[\e[32m*\e[34m]\e[36m Installation finished.\e[0m\n\n"
printf "\e[36mNow run '\e[32mstart-${directory}\e[36m' to launch.\e[0m\n\n"
