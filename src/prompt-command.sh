################################################################################
#                                                                              #
# Copyright (c) 2011 - 2014, Florian Sowade <f.sowade@r9e.de>                  #
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

_r9e_prompt_command()
{
    local return_code="${1}"

    if [ "${_R9E_SHELL}" = 'bash' ]; then
        # Store the current history to disk.
        history -a
    fi

    _r9e_export_prompt "${return_code}"

    unset _R9E_TMP_RETURN_CODE

    return "${return_code}"
}

_r9e_print_prompt_command()
{
    tr -ds '\n' ' ' <<"EOF"
_R9E_TMP_RETURN_CODE="${?}";
if type -t _r9e_prompt_command >/dev/zero; then
    _r9e_prompt_command "${_R9E_TMP_RETURN_CODE}";
else
    unset _R9E_TMP_RETURN_CODE;
fi;
EOF
}

_r9e_install_prompt_command()
{
    _r9e_profiling_timer_start _r9e_install_prompt_command

    if [ "${_R9E_SHELL}" = 'bash' ]; then
        if [[ "${PROMPT_COMMAND}" != *_r9e_prompt_command* ]]; then
            PROMPT_COMMAND="$(_r9e_print_prompt_command) ${PROMPT_COMMAND}"
        fi
    elif [ "${_R9E_SHELL}" = 'zsh' ]; then
        precmd()
        {
            _r9e_prompt_command "${?}"
        }
    fi

    _r9e_profiling_timer_end
}
