# Will return non-zero status if the current directory is not managed by git
is_in_git_repo() {
    git rev-parse HEAD > /dev/null 2>&1
}

# Switch branch with Git log preview (ctrl-space,B)
fzf_git_choose_branch() {
    is_in_git_repo || return

    PREVIEW_COMMAND='git log --color=always --oneline --decorate --graph {-1}'
    TARGET_BRANCH=$(git branch | fzf --preview="$PREVIEW_COMMAND" --ansi | sed -e 's/[\* ]//g')
    if [ ! -z "$TARGET_BRANCH" ]
    then
        echo "Attempting to switch to branch: $TARGET_BRANCH"
        git checkout $TARGET_BRANCH
    fi
    return
}
zle -N fzf_git_choose_branch
bindkey '^@b' fzf_git_choose_branch
