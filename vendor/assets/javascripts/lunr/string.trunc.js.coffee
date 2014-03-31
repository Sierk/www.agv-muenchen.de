String::trunc = (n, useWordBoundary) ->
  if @length > n
    s_ = @substr(0, n - 1)
    s_ = s_.substr(0, s_.lastIndexOf(" ")) if useWordBoundary
    s_ + "&hellip;"
  else
    this
