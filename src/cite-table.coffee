fs = require 'fs'
Citation = require './citation'

module.exports=
class CiteTable
  constructor: (@table) ->
    @topKeys = ["author", "title", "year"]
    @citations = []
    @highlighted = []
    @redraw()

  add: (cite)->
    return unless cite?
    @citations.push(cite)

  redraw: ->
    head = "<thead><tr><th></th>"
    for key in @topKeys
      head += "<th><h4>#{key}</h4></th>"
    head += "</tr></thread>"

    @table.innerHTML = head

    @tableBody = document.createElement "tbody"
    @table.appendChild(@tableBody)

    for cite in @citations
      tr = document.createElement "tr"
      tr.addEventListener "click", (event) =>
        index = event.target.parentNode.rowIndex-1
        return if not index? or index > @citations.length-1
        if index in @highlighted
          event.target.parentNode.style.background = ""
          @highlighted = @highlighted.filter (ind) -> ind isnt index
        else
          event.target.parentNode.style.background = "lightblue"
          @highlighted.push(index)

      th = document.createElement "th"
      th.innerHTML = ''
      tr.appendChild(th)
      for key in @topKeys
        th = document.createElement "th"
        th.setAttribute "contenteditable", "false"
        th.innerHTML = cite.get(key)
        tr.appendChild(th)
      @tableBody.appendChild(tr)

  getHighlighted: ->
    ret = []
    for index in @highlighted
      ret.push(@citations[index])
    return ret

  selectAll: ->
    trs = document.getElementsByTagName("tbody")[0].getElementsByTagName "tr"
    if @highlighted.length is @citations.length
      @highlighted = []
      for tr in trs
        tr.style.background = ""
    else
      @highlighted = [0..@citations.length-1]
      for tr in trs
        tr.style.background = "lightblue"
