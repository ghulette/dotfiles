function fish_title
    set -q argv[1]; or set argv fish
    echo (basename (pwd)) $argv;
end
