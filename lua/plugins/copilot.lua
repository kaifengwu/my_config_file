return {
  "zbirenbaum/copilot.lua",
  event = "InsertEnter",
  priority = 1000,  -- ✅ 让 copilot 提前加载
  config = function()
    require("copilot").setup({
      panel = { enabled = false },
      suggestion = {
        enabled = true,       -- ✅ 启用自动补全
        auto_trigger = true,  -- ✅ 自动触发补全
        debounce = 75,
        keymap = {
          accept = "<C-p>",       -- ⬅️ 接受补全建议（可改）
          accept_word = "<C-j>",       -- ⬅️ 接受补全一个词建议（可改）
          accept_line = "<C-l>",       -- ⬅️ 接受补全一行建议（可改）
          accept_line = "<C-n>",       -- ⬅️ 接受补全一行建议（可改）
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-]>",
        },
      },

    })
  vim.cmd [[highlight CopilotSuggestion guifg=#5f87ff ctermfg=12]]
  end,
}

