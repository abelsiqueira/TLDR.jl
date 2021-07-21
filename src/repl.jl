export tldr_repl

"""
    tldr_repl()

Creates a REPL associated to the key `}` equivalent to calling `tldr(s, true)` or `tldr"str"`.
"""
function tldr_repl()
  ReplMaker.initrepl(
    s -> tldr(s, true),
    prompt_text = "tldr> ",
    prompt_color = :black,
    start_key = '}',
    mode_name = "TLDR_mode"
  )
end
