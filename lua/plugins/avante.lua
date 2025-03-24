return {
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    version = false, -- Never set this value to "*"! Never!
    opts = {
      --debug = true, -- 启用调试模式
      ui = {
        sidebar_width = 0.4,  -- 侧边栏占 40% 屏幕宽度
        input_height = 5,     -- 输入框高度 5 行
        output_height = 20,   -- 输出框高度 15 行
      },
      provider = "copilot", -- ✅ 不改动你的 provider 配置
      openai = {
        endpoint = "https://api.siliconflow.cn/v1", -- DeepSeek API 地址
        model = "Qwen/QwQ-32B", -- 使用 Qwen/QwQ-32B
        timeout = 30000, -- 超时时间，单位毫秒
        method = "POST",
        temperature = 0.7,
        max_tokens = 2048, -- 限制 token 数量
        top_p = 0.7,
        top_k = 50,
        frequency_penalty = 0.5,
        n = 1,
        -- response_format = { type = "text" }, -- DeepSeek 可能不支持，先去掉
        headers = {
          ["Authorization"] = "Bearer " .. (os.getenv("DEEPSEEK_API_KEY") or ""), -- 确保 Authorization 头
          ["Content-Type"] = "application/json" -- 需要 Content-Type
        }
      },
      -- ✅ ✅ ✅ 添加 copilot 支持（不影响 openai 设置）
      copilot = {
        model = "gpt-4", -- 模型名可自定义（Avante 会自动处理）
        timeout = 30000,
      },
    },
    build = "make",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "echasnovski/mini.pick", -- for file_selector provider mini.pick
      "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
      "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
      "ibhagwan/fzf-lua", -- for file_selector provider fzf
      "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
      "zbirenbaum/copilot.lua", -- for providers='copilot'
      {
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = { insert_mode = true },
            use_absolute_path = true,
          },
        },
      },
      {
        'MeanderingProgrammer/render-markdown.nvim',
        opts = { file_types = { "markdown", "Avante" } },
        ft = { "markdown", "Avante" },
      },
      -- ✅ Copilot 设置加载器
      {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        config = function()
          require("copilot").setup({
            suggestion = { enabled = false },
            panel = { enabled = false },
          })
        end,
      },
    },
  },
}
