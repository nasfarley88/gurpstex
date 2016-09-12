#!/usr/bin/env python
from bottle import get, post, request # or route
from bottle import Bottle, run
from yattag import Doc

from random import randint, gauss
import dice
import re

def roll_dice(rolling='3d6'):
    # If the user writes in GURPS style (e.g 2d-1), replace with d6
    rolling = re.sub(r'd([^0-9]|$)', 'd6\1', rolling)
    return dice.roll(rolling)

def sum_dice(rolling='3d6'):
    return sum(roll_dice(rolling))

def dem_four_stats():
    total = 40
    retval = []
    for x in range(4):
        tmpstat = int(gauss(10,2))
        total -= tmpstat
        retval.append(tmpstat)

    while min(retval) < 8 or max(retval) > 15:
        retval = dem_four_stats()
    return retval


app = Bottle()

@app.get('/npccard')
def login():
    doc, tag, text = Doc().tagtext()

    # Form starts
    with tag('form', action='/npccard', method='post'):
        with tag('table'):
            # Name and accent
            for attr in ["name", "accent"]:
                with tag('tr'):
                    with tag('td'):
                        with tag('label'):
                            text('{}: '.format(attr.capitalize()))
                    with tag('td'):
                        doc.input(name=attr, type='text')
            # Core stats
            for attr, val in zip(["st", "dx", "iq", "ht"], dem_four_stats()):
                with tag('tr'):
                    with tag('td'):
                        with tag('label'):
                            text('{}: '.format(attr.upper()))
                    with tag('td'):
                        doc.input(name=attr, type='number', value=val)
            # Attack and attack value
            with tag('tr'):
                with tag('td'):
                    with tag('label'):
                        text('Primary attack value (to hit): ')
                with tag('td'):
                    doc.input(name="attack-to-hit", type='number', value=10)
            with tag('tr'):
                with tag('td'):
                    with tag('label'):
                        text('Primary attack damage (e.g. "2d-1"): ')
                with tag('td'):
                    doc.input(name="attack-dmg", type='text', value="1d+3")

        doc.stag('input', type='submit', value='Submit')

    return doc.getvalue()


@app.post('/npccard')
def do_login():

    stats = dict(name=None, accent=None, st=None)
    for i in request.forms.keys():
        stats[i] = request.forms[i]

    doc, tag, text = Doc().tagtext()

    with tag('table'):
        with tag('tr'):
            with tag('td'):
                text("Name: {}".format(request.forms.get("name")))
            with tag('td'):
                pass
            with tag('td'):
                text("Accent: {}".format(request.forms.get("accent")))
        for k in ["st", "dx", "iq", "ht", "attack-to-hit", "attack-dmg"]:
            with tag('tr'):
                v = request.forms[k]
                with tag('td'):
                    text("{}:".format(k.replace('-', ' ').capitalize()))
                with tag('td'):
                    text("{}".format(v))
                with tag('td'):
                    # If is a dice roll or single number
                    if re.match(r'\d(d|$)?', v):
                        text("{}".format([sum_dice() for x in range(20)]))
                    else:
                        pass


    return doc.getvalue()



@app.route('/hello')
def hello():
    return "Hello World!"

if __name__ == '__main__':
    run(app, host='0.0.0.0', port=8080)

