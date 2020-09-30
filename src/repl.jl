export jet_repl

"""
    jet_repl()

Creates a REPL associated to the key `}` equivalent to calling `jet(s, true)` or `jet"str"`.
"""
function jet_repl()
  ReplMaker.initrepl(
    s -> jet(s, true),
    prompt_text = "jet> ",
    prompt_color = :black,
    start_key = '}',
    mode_name = "Jet_mode"
  )
end
