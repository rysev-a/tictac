App = require '../../../../app'

{h1, a, p, div, li} = React.DOM

LinkView = React.createClass
  getClassName: (link)->
    if link.get('active') then 'navbar-link active' else 'navbar-link'

  render:->
    li
      className: 'navbar-item'
      onClick: =>
        if @props.link.get('callback')
          @props.link.get('callback')()
          return false
        @props.link.setActive()
        App.router.navigate @props.link.get('url'), true
      a
        className: @getClassName(@props.link)
        @props.link.get('title')

NavigationView = React.createClass
  render:->
    div
      className: 'container'
      div
        className: 'navbar-list'
        @props.links.map (link)->
          React.createElement(LinkView, link: link, key: link.cid)


module.exports = NavigationView
