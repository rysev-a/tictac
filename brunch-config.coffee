module.exports =
  paths:
    public: 'static'
  files:
    javascripts: joinTo: 'app.js'
    stylesheets: joinTo: 'app.css'
  plugins:
    babel: presets: ['es2015']

