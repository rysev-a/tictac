App = require '../../../../app'

{h1, a, p, div, form, label, input, select, option, form} = React.DOM

InputView = React.createClass
  getInitialState:->
    {model, field, title, type, error} = @props
    App.on('registration:setErrors', (errors)=>
      @.setState({errorText: errors[error]}))
    return {errorText: ''}

  getClassName:->
    if @.state.errorText then 'u-full-width error' else 'u-full-width'

  render:->
    {model, field, title, type, error} = @props

    div
      className: 'input-item'
      label
        className: null
        title
      input
        className: @getClassName()
        type: type
        onChange: (event)=>
          @setState(errorText: '')
          model.set(field, event.target.value)
      div
        className: 'error-message'
        @.state.errorText

RegistrationView = React.createClass
  render:->
    {user} = @props
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
            error: 'email'
          React.createElement InputView,
            type: 'password',
            model: user,
            field: 'password'
            title: 'password'
            error: 'password'
        div
          className: 'six columns'
          React.createElement InputView,
            type: 'text',
            model: user,
            field: 'login',
            title: 'login'
            error: 'login'
          React.createElement InputView,
            type: 'text',
            model: user,
            field: 'about'
            title: 'about you'
            error: 'about'
      a
        className: 'button button-primary submit-button'
        onClick: ()=> App.trigger('registration:start', user)
        'done!'

module.exports = RegistrationView
