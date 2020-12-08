#!/bin/sh
# shellcheck shell=sh
# shellcheck source=/dev/null

# Copyright Intel Corporation
# SPDX-License-Identifier: MIT
# https://opensource.org/licenses/MIT


# ############################################################################

# Overview

# This is the top-level environment variable setup script for use with Intel
# OneAPI toolkits. Most "tools" or "components" that are part of an Intel
# oneAPI installation include an `env/vars.sh` script that configures the
# environment variables needed for that specific tool to work. More details
# are available via this script's "--help" argument.

# NOTE: This script is designed to be POSIX compatible, so that it can more
# easily be _sourced_ by a variety of shell scripts (zsh, ksh, bash, etc.) on
# a variety of UNIX-style systems (macOS and Linux). The "shebang" on line one
# of this script has no bearing on the actual shell that is used to execute
# this script, because it will always be executed within the context of the
# shell from which it is sourced.


# ############################################################################

# Globals

# Name of this script is needed to reliably detect source with /bin/sh.
# Knowing the name of this script is a reasonable assumption because several
# of our extension/plugins assume this well-known name for referencing this
# script. This script is designed to be compatible with /bin/sh so it works
# across multiple Linux/BSD shells, in particular: bash and zsh.

script_name=setvars.sh
env_vars_args=""
config_file=""
config_array=""
component_array=""
posix_nl='
'

# TODO: create an enumerated list of script return codes.


# ############################################################################

# To be called if we encounter bad command-line args or user asks for help.

# Inputs:
#   none
#
# Outputs:
#   message to stdout

usage() {
  echo "  "
  echo "usage: source ${script_name}" '[--force] [--config=file] [--help] [...]'
  echo "  --force        force ${script_name} to re-run, doing so may overload environment"
  echo "  --config=file  customize env vars using a ${script_name} configuration file"
  echo "  ...            additional args are passed to individual env/vars.sh scripts"
  echo "                 additional arguments must follow this script's arguments"
  echo "  "
  echo "  --help         display this help message and exit"
  echo "  "
}


# ############################################################################

# To be called in preparation to exit this script, on error or success.

# Usage:
#   prep_for_exit <return-code> ; return
#
# Without a "; return" immediately following the call to this function, this
# sourced script will not exit!! Using the "exit" command causes a sourced
# script to exit the containing terminal session.
#
# Inputs:
#   Expects $1 to specify a return code. A "0" is considered a success.
#
# Outputs:
#   return code (provided as input or augmented when none was provided)

# For POSIX, limit utility usage to "native" core utilities in this script.
# Especially important for macOS where Brew may have replaced core utilities.

prep_for_exit() {
  script_return_code=$1

  # Restore original $@ array.
  # TODO: can we restore quotes?
  eval set -- "$script_args" || true

  unset -v SETVARS_CALL || true

  # make sure we're dealing with numbers
  # TODO: add check for non-numeric return codes.
  if [ "$script_return_code" = "" ] ; then
    script_return_code=255
  fi

  if [ "$script_return_code" -eq 0 ] ; then
    export SETVARS_COMPLETED=1
  fi

  return $script_return_code
}


# ############################################################################

# Since zsh manages the expansion of for loop expressions differently than
# bash, ksh and sh, we must use the "for arg do" loop (no "in" operator) that
# implicitly relies on the positional arguments array ($@). There is only one
# $@ array; this function saves that array in a format that can be easily
# restored to the $@ array at a later time.

# see http://www.etalabs.net/sh_tricks.html ("Working with arrays" section)

# Usage:
#   array_var=$(save_args "$@")
#   eval "set -- $array_var" # restores array to the $@ variable
#
# Inputs:
#   The $@ array.
#
# Outputs:
#   Cleverly encoded string that represents the $@ array.

save_args() {
  for arg do
    printf "%s\n" "$arg" | sed -e "s/'/'\\\\''/g" -e "1s/^/'/" -e "\$s/\$/' \\\\/" ;
  done
  # echo needed to pickup final continuation "\" so it's not added as an arg
  echo " "
}

# Save a master copy of the arguments array ($@) passed to this script so we
# can restore it, if needed later.
script_args=$(save_args "$@")


# ############################################################################

# Convert a list of '\n' terminated strings into a format that can be moved
# into the positional arguments array ($@) using the eval "set -- $array_var"
# command. It removes blank lines from the list (awk 'NF') in the process. It
# is not possible to combine the prep and eval steps into a single function
# because you lose the context that contains the resulting "$@" array upon
# return from this function.

# Usage:
#   eval set -- "$(prep_for_eval "$list_of_strings_with_nl")"
#
# Inputs:
#   The passed parameter is expected to be a collection of '\n' terminated
#   strings (e.g., such as from a find or grep command).
#
# Outputs:
#   Cleverly encoded string that represents the $@ array.

prep_for_eval() {
  echo "$1" | awk 'NF' | sed -e "s/^/'/g" -e "s/$/' \\\/g" -e '$s/\\$//'
}


# ############################################################################

# Get absolute path to script, when sourced from bash, zsh and ksh shells.
# Uses `readlink` to remove links and `pwd -P` to turn into an absolute path.
# Converted into a POSIX-compliant function.

# Usage:
#   script_dir=$(get_script_path "$script_rel_path")
#
# Inputs:
#   script/relative/pathname/scriptname
#
# Outputs:
#   /script/absolute/pathname

# executing function in a *subshell* to localize vars and effects on `cd`
get_script_path() (
  script="$1"
  while [ -L "$script" ] ; do
    # combining next two lines fails in zsh shell
    script_dir=$(command dirname -- "$script")
    script_dir=$(cd "$script_dir" && command pwd -P)
    script="$(readlink "$script")"
    case $script in
      (/*) ;;
       (*) script="$script_dir/$script" ;;
    esac
  done
  # combining next two lines fails in zsh shell
  script_dir=$(command dirname -- "$script")
  script_dir=$(cd "$script_dir" && command pwd -P)
  echo "$script_dir"
)


# ############################################################################

# Check to insure that this script is being sourced, not executed.
# see https://stackoverflow.com/a/38128348/2914328
# see https://stackoverflow.com/a/28776166/2914328
# see https://stackoverflow.com/a/60783610/2914328
# see https://stackoverflow.com/a/2942183/2914328

# This script is designed to be POSIX compatible, there are a few lines in the
# code block below that contain elements that are specific to a shell. The
# shell-specific elements are needed to identify the sourcing shell.

sourced=0 ;
sourced_sh="$(ps -p "$$" -o  command= | awk '{print $1}')" ;
sourced_nm="$(ps -p "$$" -o  command= | awk '{print $2}')" ;

# ${var:-} needed to pass "set -eu" checks
# see https://unix.stackexchange.com/a/381465/103967
# see https://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap02.html#tag_18_06_02
if [ -n "${ZSH_VERSION:-}" ] ; then     # only executed in zsh
  sourcer=$(printf "%s" "ZSH version = ${ZSH_VERSION}") ;
  sourced=0 ;
  sourced_sh="zsh" ;                    # only meaningful if sourced=1
  sourced_nm="${(%):-%x}" ;             # ditto
  if [ -n "$ZSH_EVAL_CONTEXT" ] ; then  # only present in zsh 5.x and later
    case $ZSH_EVAL_CONTEXT in (*:file*) sourced=1 ;; esac ;
  fi
elif [ -n "${KSH_VERSION:-}" ] ; then   # only executed in ksh or mksh or lksh
  sourcer=$(printf "%s" "KSH version = ${KSH_VERSION}") ;
  sourced=0 ;
  if [ "$(set | grep KSH_VERSION)" = "KSH_VERSION=.sh.version" ] ; then # ksh
    if [ "$(cd "$(dirname -- "$0")" && pwd -P)/$(basename -- "$0")" \
      != "$(cd "$(dirname -- "${.sh.file}")" && pwd -P)/$(basename -- "${.sh.file}")" ] ; then
      sourced=1 ;
      sourced_sh="ksh" ;                # only meaningful if sourced=1
      sourced_nm="${.sh.file}" ;        # ditto
    fi
  else # mksh or lksh detected (also check for [lm]ksh renamed as ksh)
    sourced_sh="$(basename -- "$0")"
    if [ "mksh" = "$sourced_sh" ] || [ "lksh" = "$sourced_sh" ] || [ "ksh" = "$sourced_sh" ] ; then
      sourced=1 ;
      # force [lm]ksh to issue error msg; contains this script's rel/path/filename
      sourced_nm="$( (echo "${.sh.file}") 2>&1 )" || : ;
      sourced_nm="$(expr "${sourced_nm:-}" : '^.*ksh: \(.*\)\[[0-9]*\]:')" ;
    fi
  fi
elif [ -n "${BASH_VERSION:-}" ] ; then  # only executed in bash
  sourcer=$(printf "%s" "BASH version = ${BASH_VERSION}") ;
  sourced=0 ;
  sourced_sh="bash" ;                   # only meaningful if sourced=1
  # shellcheck disable=2128
  sourced_nm=$BASH_SOURCE ;             # ditto
  (return 0 2>/dev/null) && sourced=1 ;
# TODO: following needs further testing to work in dash
elif [ "${0:-}" = "dash" ] ; then
  sourcer=$(printf "%s" "DASH version = unknown") ;
  sourced=1 ;                           # see error messages below for outcome
  sourced_sh="dash" ;                   # see error messages below for outcome
  sourced_nm="$sourced_nm" ;
# Only reliable way to detect sh source is to know the name of this script.
# TODO: following needs further testing to work in sh
elif [ "$(basename -- "$0")" != "$script_name" ] ; then
  sourcer=$(printf "%s" "SH version = unknown") ;
  sourced=1 ;                           # see error messages below for outcome
  sourced_sh="sh" ;                     # see error messages below for outcome
  sourced_nm="$sourced_nm" ;
fi

if [ ${sourced:-} -eq 0 ] ; then
  >&2 echo ":: ERROR: Incorrect usage: \"$script_name\" must be sourced." ;
  if [ "zsh" = "$sourced_sh" ] ; then
    >&2 echo "   Sourcing in ZSH requires version 5+. You have version $ZSH_VERSION."
  fi
  usage
  prep_for_exit 253 ; exit
fi

if [ "$sourced_sh" = "sh" ] || [ "$sourced_sh" = "dash" ] ; then
  # TODO: include a function to search "well-known locations" for ${script_name}.
  >&2 echo ":: ERROR: Unable to proceed: no support for sourcing from '[dash|sh]' shell." ;
  >&2 echo "   This script must be sourced. Did you execute or source this script?" ;
  >&2 echo "   Can be caused by sourcing from inside a \"shebang-less\" script." ;
  >&2 echo "   Can also be caused by sourcing from ZSH version 4.x or older." ;
  prep_for_exit 1 ; return
fi

# Determine path to this file ($script_name).
# Expects to be located at the top (root) of the oneAPI install directory.
script_root=$(get_script_path "${sourced_nm:-}")


# ############################################################################

# Interpret command-line arguments passed to this script and remove them.
# Ignore unrecognized CLI args, they will be passed to the env/vars scripts.
# see https://unix.stackexchange.com/a/258514/103967

help=0
force=0
config=0
config_file=""

for arg do
  shift
  case "$arg" in
    (--help)
      help=1
      ;;
    (--force)
      force=1
      ;;
    (--config=*)
      config=1
      config_file="$(expr "$arg" : '--config=\(.*\)')"
      ;;
    (*)
      set -- "$@" "$arg"
      ;;
  esac
  # echo "\$@ = " "$@"
done

# Save a copy of the arguments array ($@) to be passed to the env/vars
# scripts. This copy excludes the arguments consumed by this script.
# TODO: figure out a way to use $@ in vars.sh call (see end of script)
# TODO: probably means save to $@, double-quote $@ elements and save to $*
# env_vars_args=$(save_args "$@")
env_vars_args="$*"

if [ "$help" != "0" ] ; then
  usage
  prep_for_exit 254 ; return
fi

if [ "${SETVARS_COMPLETED:-}" = "1" ] ; then
  if [ $force -eq 0 ] ; then
    echo ":: WARNING: ${script_name} has already been run. Skipping re-execution."
    echo "   To force a re-execution of ${script_name}, use the '--force' option."
    echo "   Using '--force' can result in excessive use of your environment variables."
    prep_for_exit 3 ; return
  fi
fi

# If a config file has been supplied, check that it exists and is readable.
if [ "${config:-}" -eq 1 ] ; then
  # fix problem "~" alias, in case it is part of $config_file pathname
  config_file_fix=$(printf "%s" "$config_file" | sed -e "s:^\~:$HOME:")
  if [ ! -r "$config_file_fix" ] ; then
    echo ":: ERROR: $script_name config file could not be found or is not readable."
    echo "   Confirm that \"${config_file}\" path and filename are valid and readable."
    prep_for_exit 4 ; return
  fi
fi


# ############################################################################

# Find those components in the installation folder that include an
# `env/vars.sh` script. We need to "uniq" that list to remove duplicates,
# which happens when multiple versions of a component are installed
# side-by-side.

version_default="latest"

# 2>/dev/null because install folder is read-only, generates an error msg
component_array=$(find "$script_root" -mindepth 3 -maxdepth 3 -name "env" 2>/dev/null | awk 'NF')

# Since we cannot search for `-path "*/env/vars.sh"` in the find command
# above (due to macOS/find/-path/symlink issues), we must check to be sure
# that all `env` folders we found include a `vars.sh` script.
temp_array=""
eval set -- "$(prep_for_eval "$component_array")"
for arg do
  arg=$(basename -- "$(dirname -- "$(dirname -- "$arg")")")
  if [ -r "${script_root}/${arg}/${version_default}/env/vars.sh" ] ; then
    temp_array=${temp_array}${arg}$posix_nl
  fi
done
component_array=$temp_array

# eliminate duplicate component names and
# get final count of $component_array elements
component_array="$(printf "%s\n" "$component_array" | uniq)"
temp_var=$(printf "%s\n" "$component_array" | wc -l)

if [ "$temp_var" -le 0 ] ; then
  echo ":: ERROR: No env folders found: No \"env/vars.sh\" scripts to process."
  echo "   The \"${script_name}\" script expects to be located in the installation folder."
  prep_for_exit 5 ; return
fi


# ############################################################################

# At this point, if a config file was provided, it is readable.
# Put contents of $config_file into $config_array, and validate content.
# TODO: condense this section; probably not worth the effort.

if [ "$config" = "1" ] ; then

  # get the contents of the $config_file and eliminate blank lines
  config_array=$(awk 'NF' "$config_file_fix")
  temp_array=$(printf "%s\n" "$config_array" | tr "\n" " ")

  # Test $config_file: do the requested component paths exist?
  eval set -- "$(prep_for_eval "$config_array")"
  for arg do
    arg_base=$(expr "$arg" : '\(.*\)=.*')
    arg_verz=$(expr "$arg" : '.*=\(.*\)')
    arg_path=${script_root}/${arg_base}/${arg_verz}/env/vars.sh
    # skip test of "default=*" entry here, do it later
    if [ "default" = "$arg_base" ] ; then
      continue
    # skip test of "*=exclude" entry here, do it later
    elif [ "exclude" = "$arg_verz" ] ; then
      continue
    elif [ ! -r "$arg_path" ] || [ "" = "$arg_base" ] ; then
      echo ":: ERROR: Bad config file entry: Unknown component specified."
      echo "   Confirm that \"$arg\" entry in \"$config_file\" is correct."
      prep_for_exit 6 ; return
    fi
  done

  # Test $config_file: do the requested component versions exist?
  eval set -- "$(prep_for_eval "$config_array")"
  for arg do
    arg_base=$(expr "$arg" : '\(.*\)=.*')
    arg_verz=$(expr "$arg" : '.*=\(.*\)')
    arg_path=${script_root}/${arg_base}/${arg_verz}/env/vars.sh
    # perform "default=*" test we skipped above
    if [ "default" = "$arg_base" ] && [ "exclude" != "$arg_verz" ]; then
      echo ":: ERROR: Bad config file entry: Invalid \"$arg\" entry."
      echo "   \"default=exclude\" is the only valid \"default=\" statement."
      prep_for_exit 7 ; return
    elif [ "default" = "$arg_base" ] && [ "exclude" = "$arg_verz" ]; then
      version_default=$arg_verz
      continue
    # perform "*=exclude" test we skipped above (except "default=exclude")
    elif [ "exclude" = "$arg_verz" ] ; then
      # no need to validate the component name, since this is an exclude
      # "*=exclude" lines are ignored when we call the env/vars.sh scripts
      continue
    elif [ ! -r "$arg_path" ] || [ "" = "$arg_verz" ] ; then
      echo ":: ERROR: Bad config file entry: Unknown version \"$arg_verz\" specified."
      echo "   Confirm that \"$arg\" entry in \"$config_file\" is correct."
      prep_for_exit 8 ; return
    fi
  done

fi


# ############################################################################

# After completing the previous section we know the final "$version_default"
# value. It defaults to "latest" but could have been changed by the
# $config_file to "exclude" by including a "default=exclude" statement.

# add $version_default to all $component_array elements
eval set -- "$(prep_for_eval "$component_array")"
temp_array=""
for arg do
  arg=${arg}"="${version_default}
  temp_array=${temp_array}${arg}$posix_nl
done
component_array=$temp_array


# ############################################################################

# If a config file was provided, add it to the end of our $component_array,
# but only after first removing from the $component_array those that are in
# the $config_array, so we do not initialize a component twice.

if [ "$config" = "1" ] ; then

  # remove components from $component_array that are in $config_array
  eval set -- "$(prep_for_eval "$config_array")"
  for arg do
    arg_base=$(expr "$arg" : '\(.*\)=.*')
    component_array=$(printf "%s\n" "$component_array" | sed -e "s/^$arg_base=.*$//")
  done

  # append $config_array to $component_array to address what we removed
  component_array=${component_array}${posix_nl}${config_array}${posix_nl}

fi

# remove any blank lines resulting from all prior operations
component_array=$(printf "%s\n" "$component_array" |  awk 'NF')


# ############################################################################

# Finally! It's time to actually use the $component_array list that we have
# assembled to initialize the oneAPI environment. Up to this point, we've
# minimized any permanent changes to the user's environment, in case of errors
# that might cause a premature exit from this script.

# Adding the SETVARS_CALL=1 parameter to the source arguments list because
# passing arguments to sourced scripts is dicey and inconsistent. Technically,
# the defined positional parameters are supposed to flow automatically through
# to the next sourced shell, but that behavior is inconsistent from shell to
# shell and between macOS and Linux.
# see https://unix.stackexchange.com/questions/441515/parameters-passed-to-a-sourced-script-are-wrong

echo ":: initializing oneAPI environment ..."
echo "   $sourcer"

# ONEAPI_ROOT is expected to point to the top level oneAPI install folder.
# SETVARS_CALL tells env/vars scripts they are being sourced by this script.
export ONEAPI_ROOT=${script_root}
export SETVARS_CALL=1

# source the list of components in the $component_array
temp_var=0
eval set -- "$(prep_for_eval "$component_array")"
for arg do
  arg_base=$(expr "$arg" : '\(.*\)=.*')
  arg_verz=$(expr "$arg" : '.*=\(.*\)')
  arg_path=${script_root}/${arg_base}/${arg_verz}/env/vars.sh

  # echo ":: $arg_path"

  if [ "exclude" = "$arg_verz" ] ; then
    continue
  else
    if [ -r "$arg_path" ]; then
      echo ":: $arg_base -- $arg_verz"
      # zsh distinguishes between "." and "source" and source is more
      # consistent between shells -- we disallow use of "sh" at beginning
      # shellcheck disable=SC2086
      source "$arg_path" 'SETVARS_CALL=1 ' $env_vars_args
      temp_var=$((temp_var + 1))
    else
      echo ":: ERROR: \"$arg_path\" could not be found or is not readable."
      echo "   Confirm that \"$arg_path\" exists and is readable."
      echo "   Could be caused by a bad or corrupted product installation."
      prep_for_exit 252 ; return
    fi
  fi
done

if [ "$temp_var" -eq 0 ] ; then
  echo ":: ERROR: No env scripts found: No \"env/vars.sh\" scripts to process."
  echo "   This can be caused by a bad or incomplete \"--config\" file."
  prep_for_exit 251 ; return
fi

echo ":: oneAPI environment initialized ::"
prep_for_exit 0 ; return
