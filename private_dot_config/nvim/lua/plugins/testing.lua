local function find_nearest_node_modules_dir()
  local current_dir = vim.fn.expand("%:p:h") -- current buffer dir
  while current_dir ~= "/" do
    if vim.fn.isdirectory(current_dir .. "/node_modules") == 1 then
      return current_dir
    end
    current_dir = vim.fn.fnamemodify(current_dir, ":h")
  end
  return nil
end

local function get_root_dir()
  local original_cwd = vim.fn.getcwd()
  local node_modules_dir = find_nearest_node_modules_dir()
  return node_modules_dir or original_cwd
end

return {
  "nvim-neotest/neotest",
  dependencies = {
    "marilari88/neotest-vitest",
    "nvim-neotest/neotest-jest",
  },
  opts = {
    adapters = {
      ["neotest-vitest"] = {
        cwd = get_root_dir,
        filter_dir = function(name, rel_path, root)
          return name ~= "node_modules"
        end,
      },
      ["neotest-jest"] = {
        cwd = get_root_dir,
        jestCommand = "npx jest --silent --runInBand",
        jestConfigFile = "jest.config.ts",
        -- Custom test file matcher for projects with tests/ directory
        isTestFile = function(file_path)
          -- Match standard patterns
          if file_path:match("%.test%.[jt]sx?$") or file_path:match("%.spec%.[jt]sx?$") then
            return true
          end

          -- Match files in tests/ directory
          if file_path:match("/tests/.*%.[jt]sx?$") then
            return true
          end

          -- If none of the patterns match, return false
          return false
        end,
      },
    },
  },
}
