#!/usr/bin/env zsh

# This script prints an icon representing the operating system it is run on.
# It uses the `uname` command to determine the OS type and prints the corresponding icon.
#
# The script first checks if the OS is Linux and if it is Android.
# If not, it uses a case statement to match the OS type and print the corresponding icon.
# For Linux, it further checks the distribution by reading the /etc/os-release file.

UNAME="$(uname)"

ANDROID_ICON=''
APPLE_ICON=''
FREEBSD_ICON=''
LINUX_ICON=''
LINUX_ARCH_ICON=''
LINUX_CENTOS_ICON=''
LINUX_COREOS_ICON=''
LINUX_DEBIAN_ICON=''
LINUX_RASPBIAN_ICON=''
LINUX_ELEMENTARY_ICON=''
LINUX_FEDORA_ICON=''
LINUX_GENTOO_ICON=''
LINUX_MAGEIA_ICON=''
LINUX_MINT_ICON=''
LINUX_NIXOS_ICON=''
LINUX_MANJARO_ICON=''
LINUX_DEVUAN_ICON=''
LINUX_ALPINE_ICON=''
LINUX_AOSC_ICON=''
LINUX_OPENSUSE_ICON=''
LINUX_SABAYON_ICON=''
LINUX_SLACKWARE_ICON=''
LINUX_UBUNTU_ICON=''
SUNOS_ICON=''
WINDOWS_ICON=''

if [[ $UNAME == Linux && "$(uname -o 2>/dev/null)" == Android ]]; then
  printf $ANDROID_ICON
else
  case $UNAME in
    SunOS)                     printf $SUNOS_ICON;;
    Darwin)                    printf $APPLE_ICON;;
    CYGWIN_NT-* | MSYS_NT-*)   printf $WINDOWS_ICON;;
    FreeBSD|OpenBSD|DragonFly) printf $FREEBSD_ICON;;
    Linux)
      local os_release_id
      [[ -f /etc/os-release &&
        "${(f)$((</etc/os-release) 2>/dev/null)}" =~ "ID=([A-Za-z]+)" ]] && os_release_id="${match[1]}"
      case "$os_release_id" in
        *alpine*)                printf $LINUX_ALPINE_ICON;;
        *aosc*)                  printf $LINUX_AOSC_ICON;;
        *arch*)                  printf $LINUX_ARCH_ICON;;
        *centos*)                printf $LINUX_CENTOS_ICON;;
        *coreos*)                printf $LINUX_COREOS_ICON;;
        *debian*)                printf $LINUX_DEBIAN_ICON;;
        *devuan*)                printf $LINUX_DEVUAN_ICON;;
        *elementary*)            printf $LINUX_ELEMENTARY_ICON;;
        *fedora*)                printf $LINUX_FEDORA_ICON;;
        *gentoo*)                printf $LINUX_GENTOO_ICON;;
        *linuxmint*)             printf $LINUX_MINT_ICON;;
        *mageia*)                printf $LINUX_MAGEIA_ICON;;
        *manjaro*)               printf $LINUX_MANJARO_ICON;;
        *nixos*)                 printf $LINUX_NIXOS_ICON;;
        *opensuse*|*tumbleweed*) printf $LINUX_OPENSUSE_ICON;;
        *raspbian*)              printf $LINUX_RASPBIAN_ICON;;
        *sabayon*)               printf $LINUX_SABAYON_ICON;;
        *slackware*)             printf $LINUX_SLACKWARE_ICON;;
        *ubuntu*)                printf $LINUX_UBUNTU_ICON;;
        *)                       printf $LINUX_ICON;;
      esac
      ;;
  esac
fi
