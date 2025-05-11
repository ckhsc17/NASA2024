#!/bin/bash

test(){
    a=$1
    a=$((a++))
    echo $a
}

:<<'END_COMMENT'
pattern='[0-9][[:alpha:]][0-9]'

mes=`diff $1 $2 | grep $pattern`
echo "mes: $mes"

matches=$(echo "$mes" | awk -F[acd] '{print $1}')

#test1=$(echo 

echo "matches: $matches"
echo "done"

a=1
b=1
echo "a: $a"
a=$((a+1))
echo "a: $a"

c=$((3/2))
echo "c: $c"
END_COMMENT

arr=()
arr+=$(test 2)
echo "arr: $arr"
arr+=$(test 3)
echo "arr: $arr"



d=$(test 2)
echo "d: $d"

echo "------"
test 2
