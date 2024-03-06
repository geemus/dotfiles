return {
  s({ trig = "el" },
    fmta(
      [[
        else {
          <>
        }
      ]],
      {
        i(0)
      }
    )
  ),
  s({ trig = "ff" },
    fmta(
      [[
        log.Printf("%<>", <>)
      ]],
      {
        i(1, "s"),
        i(2, "var")
      }
    )
  ),
  s({ trig = "fl" },
    fmta(
      [[
        log.Println("<>")
      ]],
      {
        i(1, "s"),
      }
    )
  ),
  s({ trig = "fs" },
    fmta(
      [[
        log.Sprintf("%<>", <>)
      ]],
      {
        i(1, "s"),
        i(2, "var")
      }
    )
  ),
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
  s({ trig = "ife" },
    fmta(
      [[
        if <> {
          <>
        } else {
          <>
        }
      ]],
      {
        i(1, "condition"),
        i(2),
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
