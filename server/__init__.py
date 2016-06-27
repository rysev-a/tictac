from flask import Flask, render_template

app = Flask(__name__)
app.jinja_env.add_extension('pyjade.ext.jinja.PyJadeExtension')
app.secret_key = 'A0Zr98j/3yX R~XHH!jmN]LWX/,?RT'

app.static_folder='../static'
app.debug = True

from .admin import admin
from .api import api
from .authorization import login_manager

@app.route('/')
def index():
    return render_template('index.jade')
