from flask import Flask, render_template
app = Flask(__name__)

@app.route("/")
#above is the first page, a "route"
#def hello():
#    return "Hello World!"

#    v function name here
def index():
    title = "Homepage"
    return render_template("index.html", title=title)

@app.route("/about")
def about():
    title = "About"
    return render_template("about.html",title=title)

@app.route("/contact")
def contact():
    title = "Contact"
    return render_template("contact.html",title=title)


#to serve do FLASK_APP=firstFlask.py flask run

#sidenote: to get server to update live need to turn on debug mode
#command is 'export FLASK_ENV=development'
