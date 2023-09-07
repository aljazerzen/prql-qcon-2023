#! /usr/bin/env python
from pygments.lexer import RegexLexer
from pygments.token import *

class PRQLLexer(RegexLexer):
    name = 'PRQL'
    aliases = ['prql']
    filenames = ['*.prql']

    tokens = {
        'root': [
            (r'let|prql|case|func|module', Keyword),
            (r'from|derive|select|take|join|filter|sort|group|window|loop|append', Name.Function),
            (r'[fsr]?"(.|\\")*"', Literal.String),
            (r'[0-9]+(\\.[0-9]+)?', Literal.Number),
            (r'[a-zA-Z_][a-zA-Z_0-9]*:', Name.Decorator),
            (r'[a-zA-Z_][a-zA-Z_0-9]*', Name),
            (r'\s+', Whitespace),
            (r'#.*', Comment),
            (r'@[0-9\-]+', Literal.String),
            (r'[+\-*/%{}[\].><=(),|]+|(\?\?)', Punctuation),
        ]
    }

import argparse
import sys
import pygments.cmdline as _cmdline


def main(args):
    parser = argparse.ArgumentParser()
    parser.add_argument('-l', dest='lexer', type=str)
    opts, rest = parser.parse_known_args(args[1:])
    if opts.lexer == 'PRQL':
        args = [__file__, '-l', __file__ + ':PRQLLexer', '-x', *rest]
    _cmdline.main(args)

if __name__ == '__main__':
    main(sys.argv)