return {
  s({ trig = "> [!" },
    fmt(
      [[
        > [!{}]{} {}
        > {}
      ]],
      {
        c(1, {
          t("note"),
          t("bug"),
          t("danger"),
          t("example"),
          t("failure"),
          t("important"),
          t("info"),
          t("quote"),
          t("success"),
          t("summary"),
          t("todo"),
          t("question"),
          t("warning"),
        }),
        c(2, {
          t(""),
          t("+"),
          t("-"),
        }),
        i(3, "title"),
        i(4, "content"),
      }
    )
  ),
}
