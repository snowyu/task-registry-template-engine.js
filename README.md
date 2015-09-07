## task-registry-template-engine [![npm](https://img.shields.io/npm/v/task-registry-template-engine.svg)](https://npmjs.org/package/task-registry-template-engine)

[![Build Status](https://img.shields.io/travis/snowyu/task-registry-template-engine.js/master.svg)](http://travis-ci.org/snowyu/task-registry-template-engine.js)
[![Code Climate](https://codeclimate.com/github/snowyu/task-registry-template-engine.js/badges/gpa.svg)](https://codeclimate.com/github/snowyu/task-registry-template-engine.js)
[![Test Coverage](https://codeclimate.com/github/snowyu/task-registry-template-engine.js/badges/coverage.svg)](https://codeclimate.com/github/snowyu/task-registry-template-engine.js/coverage)
[![downloads](https://img.shields.io/npm/dm/task-registry-template-engine.svg)](https://npmjs.org/package/task-registry-template-engine)
[![license](https://img.shields.io/npm/l/task-registry-template-engine.svg)](https://npmjs.org/package/task-registry-template-engine)


Collects the template engines and abstract template-engine task.

The template engine uses to render a document with specified configuration data.

The first registered template engine is the default template engine.

## Usage

```js
var Task = require('task-registry')
//register lodash template engine
require('task-registry-template-engine-lodash')

var templateEngine = Task 'TemplateEngine'


var result = templateEngine.executeSync({
  template: 'hello ${user}!'
  , data: {user: 'Mikey'}
  , engine: 'Lodash' //optional, defaults to the first registered template engine.
}) // the result is 'hello Mikey!'
```

### Develope a new template engine

```coffee
isFunction= require 'util-ex/lib/is/type/function'
isString  = require 'util-ex/lib/is/type/string'
Task      = require 'task-registry-template-engine'
register  = Task.register
aliases   = Task.aliases

class LodashTemplateEngine
  register LodashTemplateEngine

  defineProperties LodashTemplateEngine,
    escape: # The HTML "escape" delimiter.
      type: 'RegExp'
    evaluate: # The "evaluate" delimiter.
      type: 'RegExp'
    imports: # An object to import into the template as free variables.
      type: 'Object'
    interpolate: # The "interpolate" delimiter.
      type: 'RegExp'
    sourceURL: # The sourceURL of the template’s compiled source.
      type: 'String'
    variable: # The data object variable name.
      type: 'String'

  constructor: ->return super

  _executeSync: (aOptions)->
    vTemplate = aOptions.template
    vTemplate = _.template vTemplate, aOptions if isString vTemplate
    result = vTemplate aOptions.data if isFunction vTemplate
    result
```

## API

templateEngine.executeSync(aOptions)/templateEngine.execute(aOptions, done)

* arguments
  * `aOptions` *(Object)*:
    * `template` *(String)*: the template string
    * `data` *(Object)*: the data properties to replace.
    * `engine` *(String|Object)*: the template engine name if it's string.
      * `name` *(String)*: the template engine name
      * ...: the template engine's options
  * `done` *Function(error, result)*: the result callback function for async execute.
* returns *(String)*: the rendered result string.

## TODO


## License

MIT
