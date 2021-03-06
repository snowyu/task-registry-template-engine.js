isObject        = require 'util-ex/lib/is/type/object'
isString        = require 'util-ex/lib/is/type/string'
extend          = require 'util-ex/lib/extend'
defineProperty  = require 'util-ex/lib/defineProperty'
Task            = require 'task-registry'
register        = Task.register
aliases         = Task.aliases
defineProperties= Task.defineProperties
getObjectKeys   = Object.keys

# collect all template engines
# the first registered engine is treated as the default engine.
# the derived class aOptions: should have template, data property.
#TODO: should abstract this to a common feature(CollectionTask?)
module.exports  = class TemplateEngineTask
  register TemplateEngineTask
  aliases TemplateEngineTask, 'TemplateEngines'

  constructor: (aName, aOptions)->
    result = super
    unless result? or @ instanceof TemplateEngineTask
      if isString(aName) and aName.lastIndexOf('TemplateEngine') is -1
        aName += 'TemplateEngine'
        result = super
    return result

  defineProperty @, 'defineProperties', defineProperties

  getDefault: (aOptions)->
    # get first engine as default engine if not result
    vEngine = null
    TemplateEngineTask.forEachClass (cls, name)->
      vEngine = name
      'brk'
    result = Task.get vEngine, aOptions if vEngine
    result
  get: (aName, aOptions)->
    if aName
      result = Task.get.call @, aName, aOptions
      unless result
        aName += 'TemplateEngine'
        result = Task.get.call @, aName, aOptions
    result = @getDefault(aOptions) unless result
    result
  _executeSync: (aOptions)->
    vEngineObj = aOptions.engine
    if isObject vEngineObj
      vEngine = @get vEngineObj.name
      vEngineObj = extend {}, vEngineObj, (key)-> key isnt 'name'
    else
      vEngine = @get vEngineObj
      vEngineObj = {}
    if vEngine
      vEngineObj.template = aOptions.template
      vEngineObj.data = aOptions.data
      result = vEngine.executeSync vEngineObj
    result

  getSimpleName = (aName)->
    i = aName.lastIndexOf '/'
    aName = aName.slice(i+1) if i != -1
    aName.replace 'TemplateEngine', ''

  _getTemplateEngineNames: ->
    result = [] #'[TemplateEngines'
    TemplateEngineTask.forEachClass (cls, name)->
      result.push getSimpleName cls.name
    result

  _inspect: ->
    if @Class is TemplateEngineTask
      result = @_getTemplateEngineNames().map (name)->'"' + name + '"'
      result = result.join ','
    else
      result = '"' + getSimpleName(@name) + '"'

  inspect: ->
    result = '<TemplateEngine'
    result += 's' if @Class is TemplateEngineTask
    result += ' ' + @_inspect() + '>'

  toString: ->
    if @Class is TemplateEngineTask
      result = '[TemplateEngines]'
    else
      result = getSimpleName @name
    result
