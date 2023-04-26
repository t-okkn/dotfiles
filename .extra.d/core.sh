#!/bin/sh
##### ~/.extra.d/core.sh #####

########################################
# Core 機能
########################################

function get_arch() {
  local _ostype _cputype _bitness _clibtype
  _ostype="$(uname -s)"
  _cputype="$(uname -m)"
  _bitness=0
  _clibtype="gnu"

  if [ "$_ostype" = "Linux" ]; then
    if [ "$(uname -o)" = "Android" ]; then
      _ostype="Android"
    fi

    if ldd --version 2>&1 | grep -q 'musl'; then
      _clibtype="musl"
    fi
  fi

  if [ "$_ostype" = "Darwin" ] && [ "$_cputype" = "i386" ]; then
    # MacOS上での `uname -m` は嘘
    if sysctl hw.optional.x86_64 | grep -q ': 1'; then
      _cputype="x86_64"
    fi
  fi

  if [ "$_ostype" = "SunOS" ]; then
    if [ "$(/usr/bin/uname -o)" = "illumos" ]; then
      _ostype="illumos"
    fi

    if [ "$_cputype" = "i86pc" ]; then
      _cputype="$(isainfo -n)"
    fi
  fi

  case "$_ostype" in
    "Android")
      _ostype="linux-android"
      ;;

    "Linux")
      _ostype="linux-$_clibtype"

      if [ ! -L /proc/self/exe ]; then
        local _pexe
        _pexe=$(head -c 5 /proc/self/exe)

        if [ "$_pexe" = "$(printf '\177ELF\001')" ]; then
          _bitness=32

        elif [ "$_pexe" = "$(printf '\177ELF\002')" ]; then
          _bitness=64
        fi
      fi
      ;;

    "FreeBSD")
      _ostype="freebsd"
      ;;

    "NetBSD")
      _ostype="netbsd"
      ;;

    "DragonFly")
      _ostype="dragonfly"
      ;;

    "Darwin")
      _ostype="darwin"
      ;;

    "SunOS")
      _ostype="sunos"
      ;;

    "illumos")
      _ostype="illumos"
      ;;

    MINGW* | MSYS* | CYGWIN* | "Windows_NT")
      _ostype="windows-gnu"
      ;;

    *)
      _ostype="unknown"
      ;;

  esac

  case "$_cputype" in
    "i386" | "i486" | "i686" | "i786" | "x86")
      _cputype="x86"
      ;;

    "x86_64" | "x86-64" | "x64" | "amd64")
      _cputype="x86_64"
      ;;

    "xscale" | "arm")
      _cputype="arm"

      if [ "$_ostype" = "linux-android" ]; then
        _ostype="linux-androideabi"
      fi
      ;;

    "armv6l")
      _cputype="arm"

      if [ "$_ostype" = "linux-android" ]; then
        _ostype="linux-androideabi"
      else
        _ostype="${_ostype}eabihf"
      fi
      ;;

    "armv7l" | "armv8l")
      _cputype="armv7"

      if [ "$_ostype" = "linux-android" ]; then
        _ostype="linux-androideabi"
      else
        _ostype="${_ostype}eabihf"
      fi
      ;;

    "aarch64" | "arm64")
      _cputype="aarch64"
      ;;

    "mips")
      if [ "$(check_endianness)" = "little" ]; then
        _cputype="mipsel"

      else
        _cputype="mips"
      fi
      ;;

    "mips64")
      if [ "$_bitness" -eq 64 ]; then
        _ostype="${_ostype}abi64"

        if [ "$(check_endianness)" = "little" ]; then
          _cputype="mips64el"

        else
          _cputype="mips64"
        fi
      fi
      ;;

    "ppc")
      _cputype="powerpc"
      ;;

    "ppc64")
      _cputype="powerpc64"
      ;;

    "ppc64le")
      _cputype="powerpc64le"
      ;;

    "s390x")
      _cputype="s390x"
      ;;

    "riscv64")
      _cputype="riscv64gc"
      ;;

    *)
      _cputype="unknown"
      ;;

  esac

  # 64-bit Linux 上で 32-bit Linux がユーザーランドで動作している場合
  # 32-bit とみなして回答する
  if [ "$_ostype" = "linux-gnu" ] && [ "$_bitness" -eq 32 ]; then
    case $_cputype in
      "x86_64")
        local _exe_mac
        _exe_mac=$(head -c 19 /proc/self/exe | tail -c 1)

        if [ "$_exe_mac" != "$(printf '\076')" ]; then
          _cputype="x86"
        fi
        ;;

        "mips64")
          if [ "$(check_endianness)" = "little" ]; then
            _cputype="mipsel"

          else
            _cputype="mips"
          fi
          ;;

        "powerpc64")
          _cputype=powerpc
          ;;

        "aarch64")
          _cputype="armv7"

          if [ "$_ostype" = "linux-android" ]; then
            _ostype="linux-androideabi"
          else
            _ostype="${_ostype}eabihf"
          fi
          ;;

        "riscv64gc")
          _cputype="incompatible"
          ;;
    esac
  fi

  echo "${_ostype}:${_cputype}"
}

function exists_cmd() {
  type "$1" > /dev/null 2>&1
}

function check_endianness() {
  local _endianness
  _endianness="$(head -c 6 /proc/self/exe | tail -c 1)"

  if [ "$_endianness" = "$(printf '\001')" ]; then
    echo "little"

  elif [ "$_endianness" = "$(printf '\002')" ]; then
    echo "big"

  else
    echo "unknown"
  fi
}
