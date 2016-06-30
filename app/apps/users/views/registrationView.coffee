App = require '../../../../app'

{h1, a, p, div, form, label, input, select, option, form} = React.DOM

InputView = React.createClass
  render:->
    {model, field, title, type} = @props
    div
      className: null
      label
        className: null
        title
      input
        className: 'u-full-width'
        type: type
        onChange: (event)->
          model.set(field, event.target.value)

RegistrationView = React.createClass

  render:->
    user = @props.user
    form
      className: 'registration-form'
      div
        className: 'row'
        div
          className: 'six columns'
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
        div
          className: 'six columns'
          React.createElement InputView,
            type: 'text',
            model: user,
            field: 'login',
            title: 'login'
          React.createElement InputView,
            type: 'text',
            model: user,
            field: 'about'
            title: 'about you'

      a
        className: 'button button-primary'
        onClick: ()=>
          App.trigger('start:registration', user)
        'done!'



module.exports = RegistrationView
