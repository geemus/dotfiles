local anthropic = require('model.providers.anthropic')
local perplexity = require('model.providers.perplexity')

-- prompt helpers
local extract = require('model.prompts.extract')

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
- Do not preamble.
- Before providing the commit message, show step-by-step reasoning in clear, logical order starting each line with `# `.
- Prioritize brevity and semantic meaning.
- Write a commit message according to the Conventional Commits specification.
- The title should provide a clear summary in 50 characters or less, be all lowercase, and have no period at the end.
- The optional body should explain **why**, not just **what**
- Bullet points should be high level, concise, and start with '-'.
- Just write the message directly, do not wrap the message in "```".
      ]]
    },
    builder = function()
      local git_diff = vim.fn.system({ 'git', 'diff', '--staged', '--inter-hunk-context=16', '--unified=8' })

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
    end
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
  ['analyze-prompt'] = {
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
  },
  recipe = {
    provider = perplexity,
    mode = mode.APPEND,
    params = {
      model = 'sonar',
      system = [[
You are an experienced assistant.

You will be provided with a url for a recipe.

Review the provided url and extract the recipe in this format:

<recipe>
## {recipe-name}

* {first-quantity} {first-ingredient}
* {second-quantity} {second-ingredient}
...

1. {first-step}
2. {second-step}
...

Adapted from [{site-title}]({url})
</recipe>

Only include the extracted recipe starting with <recipe> on the line before and ending with </recipe> on the line after.
            ]]
    },
    builder = function(input)
      return {
        messages = {
          {
            role = 'user',
            content = 'Extract the recipe from the following url:' .. input,
          },
        },
      }
    end,
  },
  ['vibe-prompt'] = {
    provider = anthropic,
    mode = mode.REPLACE,
    params = {
      model = 'claude-3-5-haiku-latest',
      system = [[
You are an expert prompt engineer.

Provide a comprehensive, structured analysis including:

# Structural Analysis
- Evaluate clarity, specificity, and comprehensiveness.
- Identify any ambiguities or potential misunderstandings.

# Improvement Recommendations
- Suggest specific wording changes.
- Recommend additional context or instructions.
- Propose ways to make the prompt more precise and actionable.

- Before responding, show step-by-step reasoning in clear, logical order starting with `<think>` on the line before and ending with `</think>` on the line after.
- Provide a code block containing the prompt rewritten using the suggested improvements.
      ]]
    },
    builder = function(input)
      return {
        messages = {
          {
            role = 'user',
            content = 'Analyze the following prompt:\n\n' .. input
          },
        },
      }
    end,
    transform = extract.markdown_code,
  },
}
