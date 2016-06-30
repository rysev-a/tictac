Function.prototype.papp = ()->
  slice = Array.prototype.slice
  fn = this
  args = slice.call(arguments)
  return ()-> fn.apply(this, args.concat(slice.call(arguments)))

