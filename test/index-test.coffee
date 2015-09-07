chai            = require 'chai'
sinon           = require 'sinon'
sinonChai       = require 'sinon-chai'
should          = chai.should()
expect          = chai.expect
assert          = chai.assert
chai.use(sinonChai)

setImmediate    = setImmediate || process.nextTick

Task            = require 'task-registry'
TemplateEngine  = require '../src'
register        = TemplateEngine.register
aliases         = TemplateEngine.aliases

templateEngine  = Task 'TemplateEngine'

class TestTemplateEngine
  register TestTemplateEngine
  aliases TestTemplateEngine, 'test'

  constructor: -> return super
  _executeSync: sinon.spy (aOptions)->
    result = aOptions.template
    result = result.toString() if result
    if result
      for k, v of aOptions.data
        result = result.replace '${'+k+'}', v
    result

class Test1TemplateEngine
  register Test1TemplateEngine
  aliases Test1TemplateEngine, 'test1'

  constructor: -> return super
  _executeSync: sinon.spy (aOptions)->
    result = aOptions.template
    result = result.toString() if result
    if result
      for k, v of aOptions.data
        result = result.replace '${'+k+'}', v
    result

describe 'TemplateEngine', ->
  beforeEach ->
    TestTemplateEngine::_executeSync.reset()
    Test1TemplateEngine::_executeSync.reset()

  it 'should get the test template engine', ->
    result = templateEngine.get 'Test'
    expect(result).to.be.instanceOf TestTemplateEngine
    result = templateEngine.get 'test'
    expect(result).to.be.instanceOf TestTemplateEngine
    result = templateEngine.get 'Test1'
    expect(result).to.be.instanceOf Test1TemplateEngine
    result = templateEngine.get 'test1'
    expect(result).to.be.instanceOf Test1TemplateEngine

  describe 'toString', ->
    it 'should toString templateEngines', ->
      expect(templateEngine.toString()).to.be.equal '[TemplateEngines]'
    it 'should toString templateEngine', ->
      result = templateEngine.get 'Test'
      expect(result.toString()).to.be.equal 'Test'
  describe 'inspect', ->
    it 'should inspect templateEngines', ->
      expect(templateEngine.inspect()).to.be.equal '<TemplateEngines "Test","Test1">'
    it 'should inspect templateEngine', ->
      result = templateEngine.get 'Test'
      expect(result.inspect()).to.be.equal '<TemplateEngine "Test">'

  describe 'executeSync', ->
    it 'should render a template', ->
      result = templateEngine.executeSync
        template:'hi ${user}!'
        data:
          user: 'Mikey'
      expect(result).to.be.equal 'hi Mikey!'
      expect(TestTemplateEngine::_executeSync).to.be.calledOnce
      expect(Test1TemplateEngine::_executeSync).to.be.not.called

    it 'should render a template via specified engine name', ->
      result = templateEngine.executeSync
        template:'hi ${user}!'
        data:
          user: 'Mikey'
        engine: 'Test1'
      expect(result).to.be.equal 'hi Mikey!'
      expect(Test1TemplateEngine::_executeSync).to.be.calledOnce
      expect(TestTemplateEngine::_executeSync).to.be.not.called

    it 'should render a template via specified engine', ->
      result = templateEngine.executeSync
        template:'hi ${user}!'
        data:
          user: 'Mikey'
        engine:
          name: 'Test1'
          opt1: '1'
      expect(result).to.be.equal 'hi Mikey!'
      expect(Test1TemplateEngine::_executeSync).to.be.calledOnce
      expect(Test1TemplateEngine::_executeSync).to.be.calledWith
        template:'hi ${user}!'
        data:
          user: 'Mikey'
        opt1: '1'
      expect(TestTemplateEngine::_executeSync).to.be.not.called

  describe 'execute', ->
    it 'should render a template', (done)->
      templateEngine.execute
        template:'hi ${user}!'
        data:
          user: 'Mikey'
      , (err, result)->
        unless err
          expect(result).to.be.equal 'hi Mikey!'
          expect(TestTemplateEngine::_executeSync).to.be.calledOnce
          expect(Test1TemplateEngine::_executeSync).to.be.not.called
        done(err)

    it 'should render a template via specified engine name', (done)->
      templateEngine.execute
        template:'hi ${user}!'
        data:
          user: 'Mikey'
        engine: 'Test1'
      , (err, result)->
        unless err
          expect(result).to.be.equal 'hi Mikey!'
          expect(Test1TemplateEngine::_executeSync).to.be.calledOnce
          expect(TestTemplateEngine::_executeSync).to.be.not.called
        done(err)

    it 'should render a template via specified engine', (done)->
      templateEngine.execute
        template:'hi ${user}!'
        data:
          user: 'Mikey'
        engine:
          name: 'Test1'
          opt1: '1'
      , (err, result)->
        unless err
          expect(result).to.be.equal 'hi Mikey!'
          expect(Test1TemplateEngine::_executeSync).to.be.calledOnce
          expect(Test1TemplateEngine::_executeSync).to.be.calledWith
            template:'hi ${user}!'
            data:
              user: 'Mikey'
            opt1: '1'
          expect(TestTemplateEngine::_executeSync).to.be.not.called
        done(err)
