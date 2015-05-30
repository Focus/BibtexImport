fs = require 'fs'
ipc = require 'ipc'
Citation = require './citation'

module.exports=
class LocalTable
  topKeys = ["key", "author", "title", "year"]
  constructor: (@table)->
    @citations = []
    @redraw()

  redraw: ->
    @table.innerHTML = """
    <thead>
      <tr>
        <th>#{topKeys[0]}</th>
        <th>#{topKeys[1]}</th>
        <th>#{topKeys[2]}</th>
        <th>#{topKeys[3]}</th>
      </tr>
    </thead>
    """

    @tableBody = document.createElement "tbody"
    @table.appendChild(@tableBody)

    for cite in @citations
      tr = document.createElement "tr"
      tr.addEventListener "keyup", (event) =>
        index = event.target.parentNode.rowIndex-1
        return if not index? or index > @citations.length-1
        cIndex = event.target.cellIndex
        return if cIndex > topKeys.length-1
        key = topKeys[cIndex]
        ipc.send "edited", @citations[index].set(key, event.target.innerHTML)
      for key in topKeys
        th = document.createElement "th"
        th.setAttribute "contenteditable", "true"
        th.innerHTML = cite.get(key)
        tr.appendChild(th)
      @tableBody.appendChild(tr)

  readFromFile: (filePath)->
    return unless filePath?
    data = fs.readFileSync filePath, {encoding: "utf8"}
    return false if not data?
    @citations = []
    cites = data.split "@"
    cites.shift()
    for cite in cites
      @citations.push(new Citation(cite))
    @redraw()
    return true

  saveToFile: (filePath)->
    return unless filePath?
    content = ""
    for cite in @citations
      content += cite.toString() + "\n\n"
    return fs.writeFileSync filePath, content
