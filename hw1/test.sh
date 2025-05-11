#!/usr/bin/env bash
echo 'Hello' > out
echo 'World' > out
echo 'Kitty' >> out
read a < out
echo $a
(read a && echo $a) < out > out1
cd -h > out2
cd -h 2> out3
(ls && cd -h) &> out4
cd -h 2>&1 > out5
cd -h > out6 2>&1
