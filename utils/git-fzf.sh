# Will return non-zero status if the current directory is not managed by git
is_in_git_repo() {
    git rev-parse HEAD > /dev/null 2>&1
}

# Switch branch with Git log preview (ctrl-space,B)
fzf_git_choose_branch() {
    is_in_git_repo || return

    PREVIEW_COMMAND='git log --color=always --oneline --decorate --graph {-1}'
    TARGET_BRANCH=$(git branch | fzf-tmux --preview="$PREVIEW_COMMAND" --ansi | sed -e 's/[\* ]//g')
    if [ ! -z "$TARGET_BRANCH" ]
    then
        echo -e ""
        git checkout $TARGET_BRANCH
    fi
    zle reset-prompt
}
zle -N fzf_git_choose_branch
bindkey '^@b' fzf_git_choose_branch

# Show diffs (ctrl-space,D)
fzf_git_diff() {
    is_in_git_repo || return

    PREVIEW_COMMAND='git diff --stat --color=always {-1}'
    TARGET_BRANCH=$(git branch --all | fzf-tmux --preview="$PREVIEW_COMMAND" --ansi | sed -e 's/[\* ]//g')
    if [ ! -z "$TARGET_BRANCH" ]
    then
        PREVIEW_COMMAND="git diff --color=always $TARGET_BRANCH.. -- {-1}"
        git diff --name-only $TARGET_BRANCH | fzf-tmux --preview="$PREVIEW_COMMAND" -d "70%" --ansi > /dev/null
    fi
    zle reset-prompt
}
zle -N fzf_git_diff
bindkey '^@d' fzf_git_diff

# Show diffs for merge options (ctrl-space,M)
fzf_git_merge() {
    is_in_git_repo || return

    PREVIEW_COMMAND='git diff --stat --color=always {-1}'
    TARGET_BRANCH=$(git branch --all | fzf-tmux --preview="$PREVIEW_COMMAND" --ansi | sed -e 's/[\* ]//g')
    if [ ! -z "$TARGET_BRANCH" ]
    then
        echo -e ""
        git merge $TARGET_BRANCH
    fi
    zle reset-prompt
}
zle -N fzf_git_merge
bindkey '^@m' fzf_git_merge
