#!/bin/bash

test -f $HOME/.inputrc || export INPUTRC=/etc/inputrc
export LESS=-MM
test -f $HOME/.less || export LESSKEY=/etc/.less

