return {
  s({ trig = "citations" },
    fmt(
      [[
        - After answering, include a numbered list of citation urls in <citations>.

      ]],
      {}
    )
  ),
  s({ trig = "cot" },
    fmt(
      [[
        - Before answering, think step-by-step in <cot>.

      ]],
      {}
    )
  ),
  s({ trig = "dnp" },
    fmt(
      [[
        - Do not preamble.

      ]],
      {}
    )
  ),
  s({ trig = "system" },
    fmt(
      [=[
        system = [[
          - You are {}.
          - Before answering, think step-by-step in <cot>.
          - Do not preamble.
          - Provide exact numbers and metrics where possible.
          - Provide 1 to 100 score with feedback.
          - Provide confidence percentages on claims.
        ]]
      ]=],
      {
        i(1, "role")
      }
    )
  ),
}
