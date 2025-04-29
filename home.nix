{
  config,
  pkgs,
  inputs,
  ...
}: {
  home.stateVersion = "25.05";
  programs.home-manager.enable = true;
  programs.zsh = {
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = ["git" "zoxide" "fzf" "sudo"];
      theme = "robbyrussell";
    };
    localVariables = {
      ZOXIDE_CMD_OVERRIDE = "cd";
    };
    profileExtra = ''
      export PATH="/Applications/Sublime Text.app/Contents/SharedSupport/bin:$PATH"
      eval "$(/opt/homebrew/bin/brew shellenv)"
    '';
    initContent = ''
    unset_proxy() {
        unset HTTP_PROXY
        unset http_proxy
        unset HTTPS_PROXY
        unset https_proxy
    }

    set_proxy() {
        export HTTP_PROXY=http://aproxy.corproot.net:8080
        export HTTPS_PROXY=http://aproxy.corproot.net:8080
        export http_proxy=http://aproxy.corproot.net:8080
        export https_proxy=http://aproxy.corproot.net:8080
    }
    [[ ! -r '/Users/taabaroy/.opam/opam-init/init.zsh' ]] || source '/Users/taabaroy/.opam/opam-init/init.zsh' > /dev/null 2> /dev/null
    '';
  };
  home.packages = [
    pkgs.nodejs_23
    pkgs.gh
    pkgs.nerd-fonts.jetbrains-mono
    pkgs.nerd-fonts.bigblue-terminal
    pkgs.zoxide
    pkgs.fzf
    pkgs.lazygit
    pkgs.odin
    pkgs.ols
    pkgs.bun
    pkgs.ocaml
    pkgs.ripgrep
    inputs.shelly.defaultPackage.${pkgs.system}
  ];

  home.sessionVariables = {
    SHELL = "/bin/zsh";
  };

  programs.opam = {
    enable = true;
  };
  
  programs.git = {
    enable = true;
    includes = [
      {
        # Personal
        contents.user = {
          name = "RoBaertschi";
          email = "rtmbaertschi007@gmail.com";
        };
      }
      {
        # Work
        condition = "gitdir:~/work/";
        contents.user = {
          name = "Robin Bärtschi";
          email = "robin.baertschi@swisscom.com";
        };
      }
    ];
    signing = {
      format = "ssh";
      signByDefault = true;
      key = "~/.ssh/id_ed25519";
    };
  };

  programs.tmux = {
    enable = true;
    baseIndex = 1;
    clock24 = true;
    mouse = true;
    prefix = "C-Space";
    keyMode = "vi";
    extraConfig = ''
      set-option -a terminal-features 'alacritty:RGB'
      bind -n M-H previous-window
      bind -n M-L next-window
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
      bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
      bind '"' split-window -v -c "#{pane_current_path}"
      bind % split-window -h -c "#{pane_current_path}"

      #!/usr/bin/env bash

      # TokyoNight colors for Tmux

      set -g mode-style "fg=#7aa2f7,bg=#3b4261"

      set -g message-style "fg=#7aa2f7,bg=#3b4261"
      set -g message-command-style "fg=#7aa2f7,bg=#3b4261"

      set -g pane-border-style "fg=#3b4261"
      set -g pane-active-border-style "fg=#7aa2f7"

      set -g status "on"
      set -g status-justify "left"

      set -g status-style "fg=#7aa2f7,bg=#16161e"

      set -g status-left-length "100"
      set -g status-right-length "100"

      set -g status-left-style NONE
      set -g status-right-style NONE

      set -g status-left "#[fg=#15161e,bg=#7aa2f7,bold] #S #[fg=#7aa2f7,bg=#16161e,nobold,nounderscore,noitalics]"
      set -g status-right "#[fg=#16161e,bg=#16161e,nobold,nounderscore,noitalics]#[fg=#7aa2f7,bg=#16161e] #{prefix_highlight} #[fg=#3b4261,bg=#16161e,nobold,nounderscore,noitalics]#[fg=#7aa2f7,bg=#3b4261] %Y-%m-%d  %I:%M %p #[fg=#7aa2f7,bg=#3b4261,nobold,nounderscore,noitalics]#[fg=#15161e,bg=#7aa2f7,bold] #h "
      if-shell '[ "$(tmux show-option -gqv "clock-mode-style")" == "24" ]' {
        set -g status-right "#[fg=#16161e,bg=#16161e,nobold,nounderscore,noitalics]#[fg=#7aa2f7,bg=#16161e] #{prefix_highlight} #[fg=#3b4261,bg=#16161e,nobold,nounderscore,noitalics]#[fg=#7aa2f7,bg=#3b4261] %Y-%m-%d  %H:%M #[fg=#7aa2f7,bg=#3b4261,nobold,nounderscore,noitalics]#[fg=#15161e,bg=#7aa2f7,bold] #h "
      }

      setw -g window-status-activity-style "underscore,fg=#a9b1d6,bg=#16161e"
      setw -g window-status-separator ""
      setw -g window-status-style "NONE,fg=#a9b1d6,bg=#16161e"
      setw -g window-status-format "#[fg=#16161e,bg=#16161e,nobold,nounderscore,noitalics]#[default] #I  #W #F #[fg=#16161e,bg=#16161e,nobold,nounderscore,noitalics]"
      setw -g window-status-current-format "#[fg=#16161e,bg=#3b4261,nobold,nounderscore,noitalics]#[fg=#7aa2f7,bg=#3b4261,bold] #I  #W #F #[fg=#3b4261,bg=#16161e,nobold,nounderscore,noitalics]"

      # tmux-plugins/tmux-prefix-highlight support
      set -g @prefix_highlight_output_prefix "#[fg=#e0af68]#[bg=#16161e]#[fg=#16161e]#[bg=#e0af68]"
      set -g @prefix_highlight_output_suffix ""

      set -g default-shell /bin/zsh
      set -g default-command /bin/zsh
    '';
    plugins = with pkgs; [
      tmuxPlugins.sensible
      tmuxPlugins.vim-tmux-navigator
      tmuxPlugins.yank
    ];
  };
}
