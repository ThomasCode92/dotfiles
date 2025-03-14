return {
  "alker0/chezmoi.vim",
  lazy = false,
  init = function()
    vim.g["chezmoi#use_tmp_buffer"] = true -- this option is required
    vim.g["chezmoi#source_dir_path"] = os.getenv("HOME") .. "/.local/share/chezmoi"
  end,
}
