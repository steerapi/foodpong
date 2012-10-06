$(".tabs").tabs()
$(".tabs").bind "change", (e) ->
  e.target # activated tab
  e.relatedTarget # previous tab
