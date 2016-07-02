App = require '../../../../app'

{h1, a, p, div, form, label, input, select, option, form} = React.DOM

InputView = React.createClass

  render:->
    {model, field, title, type, error} = @props

    div
      className: 'input-item'
      label
        className: null
        title
      input
        className: 'u-full-width'
        type: type
        onChange: (event)=>
          model.set(field, event.target.value)


LoginView = React.createClass
  render:->
    {user} = @props
    form
      className: 'login-form'
      div
        className: 'row'
        div
          className: 'twelve columns'
          React.createElement InputView,
            type: 'email',
            model: user,
            field: 'email',
            title: 'email'
          React.createElement InputView,
            type: 'password',
            model: user,
            field: 'password'
            title: 'password'
      a
        className: 'button button-primary submit-button'
        onClick: ()=> App.trigger('login:start', user)
        'done!'

module.exports = LoginView
