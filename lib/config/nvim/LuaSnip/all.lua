return {
  s({ trig = "date", name = "Current Date" }, {
    p(os.date, "%Y-%m-%d"),
  }),
  s({ trig = "datetime", name = "Current DateTime" }, {
    p(os.date, "%Y-%m-%d %H:%M"),
  }),
  s({ trig = "diso", name = "Current ISO DateTime" }, {
    p(os.date, "%Y-%m-%dT%H:%M:%S"),
  }),
  s({ trig = "time", name = "Current Time" }, {
    p(os.date, "%H:%M"),
  }),
}
