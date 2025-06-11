{ pkgs }: {
  plugins = with pkgs.vimPlugins; [
    nvim-treesitter
    nvim-treesitter-parsers.bash
    nvim-treesitter-parsers.c
    nvim-treesitter-parsers.css
    nvim-treesitter-parsers.dockerfile
    nvim-treesitter-parsers.fish
    nvim-treesitter-parsers.gitattributes
    nvim-treesitter-parsers.gitcommit
    nvim-treesitter-parsers.gitignore
    nvim-treesitter-parsers.go
    nvim-treesitter-parsers.gpg
    nvim-treesitter-parsers.html
    nvim-treesitter-parsers.json
    nvim-treesitter-parsers.latex
    nvim-treesitter-parsers.lua
    nvim-treesitter-parsers.luadoc
    nvim-treesitter-parsers.markdown
    nvim-treesitter-parsers.markdown_inline
    nvim-treesitter-parsers.mermaid
    nvim-treesitter-parsers.nix
    nvim-treesitter-parsers.python
    nvim-treesitter-parsers.regex
    nvim-treesitter-parsers.rust
    nvim-treesitter-parsers.sql
    nvim-treesitter-parsers.toml
    nvim-treesitter-parsers.tsx
    nvim-treesitter-parsers.vim
    nvim-treesitter-parsers.vimdoc
    nvim-treesitter-parsers.yaml
    nvim-treesitter-parsers.zig
  ];
  config = ''
    vim.wo.foldmethod = 'expr'
    vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'

    require("nvim-treesitter.configs").setup({
      auto_install = true,
      parser_install_dir = vim.fn.stdpath("data") .. "/parsers",
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      ident = { enable = true }, 
      rainbow = {
        enable = true,
        extended_mode = true,
        max_file_lines = nil,
      }
    })
  '';
  deps = with pkgs; [ gcc nodejs tree-sitter grc ];
}
