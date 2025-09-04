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
You are an experienced software engineer crafting commit messages.

- A git diff will be provided in a diff code block starting with "```diff" and ending with "```".
- Write a terse commit message according to the Conventional Commits specification.
- Prioritize brevity and semantic meaning.
- Do not preamble and return only the commit message.
      ]]
    },
    builder = function()
      local git_diff = vim.fn.system({ 'git', 'diff', '--staged', '--unified=8' })

      if not git_diff:match('^diff') then
        error('Git error:\n' .. git_diff)
      end

      return {
        messages = {
          {
            role = 'user',
            content = 'Analyze this git diff:\n\n```diff\n' .. git_diff .. '\n```',
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
You are an experienced copy editor specializing in startup communications.

Analyze potential internal memos and provide comprehensive, structured analysis including:

- Simplify language while maintaining the core meaning.
- Convert passive to active voice.
- Optimize sentence structure for clarity.
- Ensure concise, direct communication.
      ]]
    },
    builder = function(input)
      return {
        messages = {
          {
            role = 'user',
            content = 'Analyze the following memo:\n\n' .. input,
          },
        },
      }
    end,
  },
  prompt = {
    provider = anthropic,
    mode = mode.SPLIT,
    params = {
      model = 'claude-3-5-haiku-latest',
      system = [[
You are an expert prompt engineering consultant analyzing potential prompts.

Provide a comprehensive, structured analysis including:

# Structural Analysis
- Evaluate clarity, specificity, and comprehensiveness.
- Identify any ambiguities or potential misunderstandings.

# Improvement Recommendations
- Suggest specific wording changes.
- Recommend additional context or instructions.
- Propose ways to make the prompt more precise and actionable.

# Scoring on 1-100 Scale
- Clarity
- Completeness
- Probability of generating desired output

# Examples:
- Provides 1-2 concrete examples of how the prompt could be rewritten.

Provide detailed, constructive feedback that improves the prompt's effectiveness.
            ]]
    },
    builder = function(input)
      return {
        messages = {
          {
            role = 'user',
            content = 'Analyze the following prompt:\n\n' .. input,
          },
        },
      }
    end,
  }
}
