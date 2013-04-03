{dispatch_impl} = require 'libprotocol'
{info, warn, error, debug} = dispatch_impl 'ILogger', 'IHelper'

_isNaN = (v) -> v isnt v

module.exports =
    protocols:
        definitions:
            IHelper: [
                ['len',     ['array']]
                ['add',     ['vector']]
                ['drop',    ['items_vec', 'cur_item']]
                ['swap',    ['items_vec', 'cur_item']]
                ['inc',     ['val']]
                ['dec',     ['val']]
                ['->->->',  ['a']]
                ['say',     ['msgs', 'more'], {vargs: true}]
                ['info',    ['msgs', 'more'], {vargs: true}]
                ['warn',    ['msgs', 'more'], {vargs: true}]
                ['error',   ['msgs', 'more'], {vargs: true}]
                ['debug',   ['msgs', 'more'], {vargs: true}]

                ['not',     ['a']]
                ['stop!',   []]
                ['stop?',   ['patrn', 'val']]
                ['wait',    ['timeout'], {async: true}]

                ['random',  []]

                ['push-to-google', ['vec']]

                ['###',     ['blk', 'args']]
                ['wrap',    ['tpl', 'pattern', 'value']]

                ['true',    []]
                ['false',   []]

            ]

        implementations:
            IHelper: (node) ->
                true: -> true

                false: -> false

                wrap: (t, p, v) -> t.replace p, v

                '###': (block, args) -> args

                'push-to-google': (p) ->
                    debug 'push-to-google', p
                    push_to_google p...

                random: -> Math.random()

                len: (array) -> array.length or 0

                wait: (timeout, cont) ->
                    debug "waiting #{timeout}ms"
                    setTimeout(
                        ->
                            debug "waiting done"
                            cont()

                        timeout
                    )

                not: (a) -> !a

                "stop!": -> null

                "stop?": (p, v) -> if p is v then null else v

                add: (vec) ->
                    vec.reduce (a, b) -> (parseInt a, 10) + (parseInt b, 10)

                drop: (items, item) ->
                    item_is_in_items = if _isNaN item
                        !!(items.filter (i) -> _isNaN i).length
                    else
                        item in items

                    if item_is_in_items then null else item

                swap: ([from, to], item) ->
                    if ((_isNaN item) and (_isNaN from)) or (item is from)
                        to
                    else
                        item

                '->->->': (a) ->
                    debug "[->->->]", a
                    a

                info: info

                error: error

                warn: warn

                debug: (a...) -> debug a...

                say: info

                inc: (v) -> parseInt(v, 10) + 1

                dec: (v) -> parseInt(v, 10) - 1
