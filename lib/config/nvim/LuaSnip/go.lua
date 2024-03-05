return {
  s({ trig = "if" },
    fmta(
      [[
        if <> {
          <>
        }
      ]],
      {
        i(1, "condition"),
        i(0)
      }
    )
  ),
  s({ trig = "ir" },
    fmta(
      [[
        if err != nil {
          return err
        }
      ]],
      {}
    )
  ),
}
