#!/usr/bin/env python3

import os, sys, json
from flask import Flask
from flask import request
from flask_cors import CORS
import subprocess

dir = os.path.dirname(os.path.realpath(__file__))

string = 'some data'

app = Flask(__name__)
app.debug = True
CORS(app)

@app.route('/', methods=['GET'])
def hello():
  return 'Hello'

@app.route('/', methods=['POST'])
def processYaml():
  cmd = request.args.get('cmd')
  fmt = request.args.get('fmt', 'event')
  yaml = request.form.get('text')

  command = '/yaml/bin/' + cmd

  p = subprocess.Popen(
    command,
    stdin=subprocess.PIPE,
    stdout=subprocess.PIPE,
    stderr=subprocess.STDOUT,
  )
  (output, status) = p.communicate(input=yaml.encode())
  resp = {}
  if status:
    resp['error'] = output.decode()
  else:
    resp['output'] = output.decode()

  return json.dumps(resp)

if __name__ == "__main__":
  host = '0.0.0.0'

  if sys.argv[1] == 'https':
    port = '31337'
    ssl_context = 'adhoc'
  elif sys.argv[1] == 'http':
    port = '1337'
    ssl_context = None
  else:
    raise ValueError("Invalid argument '%s'" % sys.argv[1])

  app.run(
    ssl_context=ssl_context,
    host=host,
    port=port,
  )
