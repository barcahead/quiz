exports.index = (req, res) ->
  res.render 'index'

exports.partials = (req, res) ->
  id = req.params.id
  res.render 'partials'+id