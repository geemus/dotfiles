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
- Prioritize brevity and semantic meaning.
- Do not preamble and return only the commit message.
      ]]
    },
    builder = function()
      local git_diff = vim.fn.system({ 'git', 'diff', '--staged' })

      if not git_diff:match('^diff') then
        error('Git error:\n' .. git_diff)
      end

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
You are an experienced copy editor specializing in startup communications.

Analyze each message as a potential internal memo and provide comprehensive, structured analysis including:

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
            content = input,
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
You are an expert prompt engineering consultant analyzing each message as a potential prompt.

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
            content = input,
          },
        },
      }
    end,
  }
}
