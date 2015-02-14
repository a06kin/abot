Select      = require( "soupselect" ).select
HTMLParser  = require "htmlparser"


module.exports = (robot) ->
  robot.hear /bash/i, (msg) ->
    robot.http("http://bash.org/?random1")
    #robot.http("http://bash.org/?3974")
    .get() (err, res, body) ->
      return response_handler "Sorry, something went wrong" if err

      selector = ".qt"
      html_handler  = new HTMLParser.DefaultHandler((()->), ignoreWhitespace: true )
      html_parser   = new HTMLParser.Parser html_handler

      html_parser.parseComplete body

      quote = Select( html_handler.dom, selector )
      all = ""
      for q in quote[0].children
        all += q.raw
      msg.send beautify all

beautify = (text)->
  replacements = [
    [/&nbsp;/g, ' ']
    [/br \//g, '']
    [/&lt;/g, '<']
    [/&gt;/g, '>']
    ['/&quot;/g', '\"']
    ['/&#039;/g', '\'' ]
  ]

  for r in replacements
    text = text.replace r[0], r[1]
  return text
