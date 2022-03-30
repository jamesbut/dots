# Defined interactively
function fish_prompt --description 'Custom prompt'
    #Save the return status of the previous command
    set -l last_pipestatus $pipestatus
    set -lx __fish_last_status $status # Export for __fish_print_pipestatus.

    #Git functions
    function _git_branch_name
        set -l branch (git symbolic-ref --quiet HEAD 2>/dev/null)
        if set -q branch[1]
            echo (string replace -r '^refs/heads/' '' $branch)
        else
            echo (git rev-parse --short HEAD 2>/dev/null)
        end
    end

    function _is_git_dirty
        echo (git status -s --ignore-submodules=dirty 2>/dev/null)
    end

    function _is_git_repo
        type -q git
        or return 1
        git rev-parse --git-dir >/dev/null 2>&1
    end

    function _hg_branch_name
        echo (hg branch 2>/dev/null)
    end

    function _is_hg_dirty
        echo (hg status -mard 2>/dev/null)
    end

    function _is_hg_repo
        fish_print_hg_root >/dev/null
    end

    function _repo_branch_name
        _$argv[1]_branch_name
    end

    function _is_repo_dirty
        _is_$argv[1]_dirty
    end

    function _repo_type
        if _is_hg_repo
            echo hg
            return 0
        else if _is_git_repo
            echo git
            return 0
        end
        return 1
    end

    #Something to do with root user?
    if functions -q fish_is_root_user; and fish_is_root_user
        printf '%s@%s %s%s%s# ' $USER (prompt_hostname) (set -q fish_color_cwd_root
                                                         and set_color $fish_color_cwd_root
                                                         or set_color $fish_color_cwd) \
            (prompt_pwd) (set_color normal)

    #I assume this is my normal use case
    else
        set -l pipestatus_string (__fish_print_pipestatus "[" "] " "|" (set_color $fish_color_status) \
                                  (set_color --bold $fish_color_status) $last_pipestatus)

        set -l cyan (set_color -o cyan)
        set -l yellow (set_color -o yellow)
        set -l red (set_color -o red)
        set -l green (set_color -o green)
        set -l blue (set_color -o blue)
        set -l normal (set_color normal)

        #Add git information
        set -l repo_info
        if set -l repo_type (_repo_type)
            set -l repo_branch $red(_repo_branch_name $repo_type)
            set repo_info "$blue $repo_type:($repo_branch$blue)"

            set -l dirty (_is_repo_dirty $repo_type)
            if test -n "$dirty"
                set -l dirty "$yellow ✗"
                set repo_info "$repo_info$dirty"
            end
        end

        # Disable PWD shortening by default.
        set -q fish_prompt_pwd_dir_length
        or set -lx fish_prompt_pwd_dir_length 0

        printf '[%s] %s%s@%s %s%s %s%s%s %s%s\n> ' (date "+%H:%M:%S") (set_color brblue) \
            #$USER (prompt_hostname) (set_color $fish_color_cwd) $PWD $pipestatus_string \
            $USER (prompt_hostname) (set_color $fish_color_cwd) (prompt_pwd) \
            $pipestatus_string $repo_info (set_color normal)
    end
end
