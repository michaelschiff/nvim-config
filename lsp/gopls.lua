return {
  cmd = { 'gopls' },
  root_markers = { 'go.mod', 'go.sum' },
  filetypes = { 'go' },
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
      },
      staticcheck = true,
      gofumpt = true,
    },
  },
}
