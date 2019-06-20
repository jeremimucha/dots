function fish_prompt --description 'Write out the prompt'
	set -l last_status $status

    # User
    set_color $fish_color_user
    echo -n (whoami)
    set_color normal

    # Host
    # echo -n '@'
    # set_color $fish_color_host
    # echo -n (prompt_hostname)
    # set_color normal

    echo -n ':'

    # PWD
    set_color $fish_color_cwd
    echo -n (prompt_pwd)
    set_color normal

    __terlar_git_prompt
    # __fish_hg_prompt
    echo

    set_color -o fb7e14     # bold Half-Life orange
    if not test $last_status -eq 0
        set_color -o $fish_color_error
    end
    echo -n 'λ '
    set_color normal
end
