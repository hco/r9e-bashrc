#!/bin/bash
################################################################################
#                                                                              #
# Copyright (c) 2011 - 2016, Florian Sowade <f.sowade@r9e.de>                  #
#                                                                              #
# Permission to use, copy, modify, and/or distribute this software for any     #
# purpose with or without fee is hereby granted, provided that the above       #
# copyright notice and this permission notice appear in all copies.            #
#                                                                              #
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES     #
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF             #
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR      #
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES       #
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN        #
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF      #
# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.               #
#                                                                              #
################################################################################

set -eu

print_info()
{
    local message="${*}"

    echo "${message}" >&2
}

print_error()
{
    local message="${*}"

    echo "error: ${message}" >&2
}

main()
{
    # the configuration
    local base_path="${HOME}/.r9e"
    local install_path="${base_path}/bashrc"
    local r9e_init_file="${install_path}/src/init.sh"
    local last_updater_run_file="${install_path}/.last-r9e-bashrc-update-run"
    local repository='git://github.com/rioderelfte/r9e-bashrc.git'
    local user_bashrc="${HOME}/.bashrc"
    local user_zshrc="${HOME}/.zshrc"

    # check if installation is save
    if [ -e "${install_path}" ]; then
        print_error "${install_path} exists"
        exit 1
    fi

    if [ -e "${base_path}" -a ! -d "${base_path}" ]; then
        print_error "${base_path} exists and is no directory"
        exit 1
    fi

    # install the files
    print_info "installing r9e-bashrc to ${install_path}"
    mkdir -p "${base_path}"
    if ! git clone --quiet "${repository}" "${install_path}"; then
        if [ -d "${install_path}" ]; then
            rm -r "${install_path}"
        fi

        print_error 'could not clone the git repository'
        exit 1
    fi

    cat > "${last_updater_run_file}" <<EOF
This file is used by the automatic r9e-bashrc updater. Please do not touch it.
EOF

    for rc_file in "${user_bashrc}" "${user_zshrc}"; do
        local backup_file="${rc_file}.pre-r9e"

        if [ -e "${rc_file}" ]; then
            print_info "making a backup of your old ${rc_file} to ${backup_file}"
            mv "${rc_file}" "${backup_file}"
        fi

        cat > "${rc_file}" <<EOF
################################################################################
#                                                                              #
# Copyright (c) 2011 - 2016, Florian Sowade <f.sowade@r9e.de>                  #
#                                                                              #
# Permission to use, copy, modify, and/or distribute this software for any     #
# purpose with or without fee is hereby granted, provided that the above       #
# copyright notice and this permission notice appear in all copies.            #
#                                                                              #
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES     #
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF             #
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR      #
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES       #
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN        #
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF      #
# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.               #
#                                                                              #
################################################################################

# This file was auto generated by the r9e-bashrc installer.

# If you want to customize your bashrc apart from the variables listed below,
# this is probably the wrong place. See the r9e-bashrc documentation for ways to
# customize your bashrc.

# variables to customize the r9e-bashrc:
#_R9E_BASHRC_ENABLE_PROFILING=true
#_R9E_BASHRC_SOURCE_DEFAULT_ALIASES=false
#_R9E_BASHRC_SOURCE_DEFAULT_FUNCTIONS=false
#_R9E_BASHRC_PROMPT_AUTO_BOLD=false
#_R9E_BASHRC_ZSH_BREW_COMPLETION=false
#_R9E_BASHRC_ZSH_COMPINIT=false
_R9E_BASHRC_ENABLE_UPDATER=true

# start the r9e-bashrc
source '${r9e_init_file}'
EOF
    done

    print_info 'successfully installed r9e-bashrc'
}

main
