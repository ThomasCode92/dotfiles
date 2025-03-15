vim.filetype.add({
  filename = {
    -- docker-compose filetypes
    ["docker-compose.yml"] = "yaml.docker-compose",
    ["docker-compose.yaml"] = "yaml.docker-compose",
  },
})
