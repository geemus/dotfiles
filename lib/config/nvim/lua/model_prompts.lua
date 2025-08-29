local anthropic = require('model.providers.anthropic')

-- utils
local mode = require('model').mode

return {
  commit = {
    provider = anthropic,
    mode = mode.INSERT,
    params = {
      model = 'claude-3-5-haiku-latest',
      system = [[
        You are an experienced software engineer.

        - Consider the git diff in the message.
        - Write a terse commit message according to the Conventional Commits specification.
        - Try to stay below 80 characters total.
        - Do not preamble and return only the commit message.
      ]]
    },
    builder = function()
      local git_diff = vim.fn.system({ 'git', 'diff', '--staged' })

      if not git_diff:match('^diff') then
        error('Git error:\n' .. git_diff)
      end

      print(git_diff)

      return {
        messages = {
          {
            role = 'user',
            content = git_diff,
          },
        },
      }
    end,
  },
  copyedit = {
    provider = anthropic,
    mode = mode.SPLIT,
    params = {
      model = 'claude-3-5-haiku-latest',
      system = [[
        You are an experienced copy editor.

        - Provide feedback on how to improve this writing.
      ]]
    },
    builder = function(input)
      return {
        messages = {
          {
            role = 'user',
            content = input,
          },
        },
      }
    end,
  },
}
