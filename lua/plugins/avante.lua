return {
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    version = false, -- Never set this value to "*"! Never!
    opts = {
      debug = true, -- 启用调试模式
      provider = "openai",
      openai = {
        endpoint = "https://api.siliconflow.cn/v1", -- DeepSeek API 地址
        model = "Qwen/QwQ-32B", -- 使用 Qwen/QwQ-32B
        timeout = 30000, -- 超时时间，单位毫秒
        method = "POST",
        temperature = 0.7,
        max_tokens = 512, -- 限制 token 数量
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
    },
  },
}
