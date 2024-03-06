return {
  s({ trig = "#!" },
    fmta(
      [[
        #!/usr/bin/env ruby
      ]],
      {}
    )
  ),
  s({ trig = "frozen" },
    fmta(
      [[
        # frozen_string_literal: true
      ]],
      {}
    )
  ),
}
