#tests/posts.coffee
assert = require 'assert'

suite 'Posts', ->
    test 'in the server', (done, server) ->
        server.eval ->
            Posts.insert {title: 'hello title'}
            docs = Posts.find().fetch()
            emit 'docs', docs

        server.once 'docs', (docs) ->
            assert.equal docs.length, 1
            done()
    
    test 'using both client and the server', (done, server, client) ->
        server.eval( ->
            Posts.find().observe 
                added: (post) ->
                    emit 'post', post
        ).once 'post', (post) ->
            assert.equal post.title, 'hello title'
            done()
    

        client.eval () ->
            Posts.insert {title: 'hello title'}