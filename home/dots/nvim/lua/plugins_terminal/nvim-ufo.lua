return {
  'kevinhwang91/nvim-ufo',
  config = function()
    require('ufo').setup()
  end,
  dependencies = {
    { "kevinhwang91/promise-async" }
  }
}
