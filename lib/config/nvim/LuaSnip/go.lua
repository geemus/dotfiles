return {
  -- bubbletea
  s({ trig = "tclient" },
    fmta(
      [[
        var err error
        clientCmd := &auth.Client{
          Config: c.Config,
          Anc:    c.anc,
        }
        c.anc, err = clientCmd.Perform(ctx, drv)
        if err != nil {
          return err
        }
      ]],
      {}
    )
  ),
  s({ trig = "tdone" },
    fmta(
      [[
        fmt.Fprintln(&b, ui.StepDone("<>"))
      ]],
      {
        i(1, "step")
      }
    )
  ),
  s({ trig = "theader" },
    fmta(
      [[
        fmt.Fprintln(&b, ui.Header(fmt.Sprintf("<> %s", ui.Whisper("`<>`"))))
      ]],
      {
        i(1, "header"),
        i(2, "cmd")
      }
    )
  ),
  s({ trig = "thint" },
    fmta(
      [[
        fmt.Fprintln(&b, ui.StepHint("<> %s"))
      ]],
      {
        i(1, "hint")
      }
    )
  ),
  s({ trig = "tinprogress" },
    fmta(
      [[
        fmt.Fprintln(&b, ui.StepInProgress(fmt.Sprintf("<>…%s", m.spinner.View())))
      ]],
      {
        i(1, "step")
      }
    )
  ),
  s({ trig = "tm" },
    fmta(
      [[
        type <> struct{}

        func (m *<>) Init() tea.Cmd { return nil }

        func (m *<>) Update(msg tea.Msg) (tea.Model, tea.Cmd) { return m, nil }

        func (m *<>) View() string {
          var b strings.Builder

          return b.String()
        }
      ]],
      {
        i(1, "model"),
        rep(1),
        rep(1),
        rep(1)
      }
    )
  ),

  -- fmt
  s({ trig = "ff" },
    fmta(
      [[
        fmt.Printf("%<>", <>)
      ]],
      {
        i(1, "format"),
        i(2, "var")
      }
    )
  ),
  s({ trig = "ffl" },
    fmta(
      [[
        fmt.Fprintln(&<>, "<>")
      ]],
      {
        i(1, "writer"),
        i(2, "string")
      }
    )
  ),
  s({ trig = "fl" },
    fmta(
      [[
        fmt.Println("<>")
      ]],
      {
        i(1, "string"),
      }
    )
  ),
  s({ trig = "fs" },
    fmta(
      [[
        fmt.Sprintf("%<>", <>)
      ]],
      {
        i(1, "format"),
        i(2, "var")
      }
    )
  ),

  -- logging
  s({ trig = "lf" },
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
  s({ trig = "ll" },
    fmta(
      [[
        log.Println("<>")
      ]],
      {
        i(1, "s"),
      }
    )
  ),
  s({ trig = "ls" },
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

  -- misc
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
  s({ trig = "ie" },
    fmta(
      [[
        if err != nil {
          return err
        }
      ]],
      {}
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

  -- testing
  s({ trig = "tie" },
    fmta(
      [[
        if err != nil {
          t.Fatal(err)
        }
      ]],
      {}
    )
  ),
  s({ trig = "tiwg" },
    fmta(
      [[
        if want, got := <>, <>; want != got {
          t.Errorf("want:\n\n%s\n\ngot:\n\n%s\n\n", want, got)
        }
      ]],
      {
        i(1, "want"),
        i(2, "got")
      }
    )
  ),

}
