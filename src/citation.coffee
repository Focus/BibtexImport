module.exports=
class Citation
  @key: null
  @type: null
  @properties: null
  constructor: (text)->
    @parse(text)
  get: (field)->
    return null if not @properties?
    if field is "key"
      return @key
    if field is "type"
      return @type
    for property in @properties
      return property.content if property.name is field
    return null
  set: (field, value)->
    return null if not @properties?
    if field is "key"
      return false if @key is value
      @key = value
      return true
    if field is "type"
      return false if @type is value
      @type = value
      return true
    for property in @properties
      if property.name is field
        return false if property.content is value
        property.content = value
        return true
    @properties.push({name: field, content: value})
    return true
  splitBib: (text)->
    splits = []
    balance = 0
    last = -1
    for ch, i in text
      if (ch is ',') and (balance is 0)
        splits.push(text.substring(last+1, i))
        last = i
      else if (ch is '\"') and (balance is 0)
        delim = "\""
        balance++
      else if (ch is '{') and (balance is 0)
        delim = '{'
        balance++
      else if balance isnt 0
        balance++ if (ch is delim) and (delim is '{')
        balance-- if (ch is '}') and (delim is '{')
        balance = 0 if (ch is delim) and (delim is "\"")
    if (last+1) isnt (text.length-1)
      splits.push(text.substring(last+1,text.length))
    splits

  parse: (text)->
    return unless text?
    text = text.replace(/\n|\r/g, " ")
    return if text.indexOf("}") is -1
    balance = 1
    it = text.indexOf("{") + 1
    at = text.indexOf("@")
    return if it is 0
    if at > it or at is -1
      at = 0
    @type = text.substring(at, it-1)
    @type = @type.replace(/\s+/g,"")
    text = text.substring(it)
    #We first strip the bib entry into the bit in between @{...} as there may be comments outside
    balance = 1
    for ch, i in text
      balance++ if ch is '{'
      balance-- if ch is '}'
      break if balance is 0
    return if balance isnt 0
    text = text.substring(0,i)
    items = @splitBib(text)
    return if items.length is 0
    @key = items[0]
    items.splice(0, 1)
    @key = @key.replace(/\s+/g,"")
    @properties = []
    for item in items
      eq = item.indexOf("=")
      continue if eq is -1 or eq is (item.length - 1)
      name = item.substring(0,eq).replace(/\s+/g,"").toLowerCase()
      content = item.substring(eq+1)
      qInd = content.indexOf("\"")
      bInd = content.indexOf("{")
      continue if ((qInd < 0) and (bInd < 0)) #or (qInd > content.length()-1) or (bInd > content.length()-1)
      if (qInd isnt -1 and qInd < bInd) or (bInd is -1)
        content = content.substring(qInd+1)
        term = "\""
      else
        content = content.substring(bInd+1)
        term = "}"
      termInd = content.lastIndexOf(term)
      continue if termInd < 0
      content = content.substring(0, termInd)
      content = content.replace(/\s+/g," ")
      @properties.push({name: name, content: content})

  toString: ->
    ret = "@#{@type}{#{@key},\n"
    for property in @properties
      ret += "\t #{property.name} = {#{property.content}},\n"
    ret += "}"
