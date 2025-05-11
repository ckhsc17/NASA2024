#!/bin/bash

# Function to display usage information
usage() {
  echo "usage: ./compare.sh [OPTION] <PATH A> <PATH B>"
  echo "options:"
  echo "-a: compare hidden files instead of ignoring them"
  echo "-h: output information about compare.sh"
  echo "-l: treat symlinks as files instead of ignoring them"
  echo "-n <EXP>: compare only files whose paths follow the REGEX <EXP>"
  echo "-r: compare directories recursively"
  exit 1
}

calculate_changes() {
    local line_a=$(wc -l < "$1")
    local mes=$2
    local pattern=$3
    local a=0
    local b=0
    
    #echo "mes: $mes"

    local matches=$(echo "$mes" | grep "$pattern")
    #echo "matches[1]: ${matches[0]}"

    for match in $matches; do
        # calculate (a,b,c)
        #echo "matches[0]: $match"

        if [[ $match == *c* ]]; then
            change_info1=$(echo $match | awk -F[c] '{print $1}') #a
            change_info2=$(echo $match | awk -F[c] '{print $2}') #b

            # calculate a (delete line)
            a=$((a + $(calculate_change $change_info1)))

            # calculate b (insert line)
            b=$((b + $(calculate_change $change_info2)))

        elif [[ $match == *d* ]]; then
            del_info=$(echo $match | awk -F[d] '{print $1}') #a

            # calculate a (delete line)
            a=$((a + $(calculate_change $del_info)))

        elif [[ $match == *a* ]]; then
            add_info=$(echo $match | awk -F[a] '{print $1}') #b

            # calculate b (insert line)
            b=$((b + $(calculate_change $add_info)))
        fi

        local c=$((line_a - a))
        local x=0

        # calculate x
        if [[ $a -gt $b ]]; then
            x=$(((100 * a) / (a + c)))
        else
            x=$(((100 * b) / (b + c)))
        fi
    done
    
    echo $((x))
    #echo "(a,b,c): $a $b $c"

}

calculate_change() {
    local info=$1

    # calculate change (a or b)
    # [[ ${#info} -gt 1 ]]有瑕疵（如果行數有二位數以上就無效
    if [[ $info == "*," ]]; then
        local tmp1=$(echo $info | awk -F[,] '{print $1}')
        local tmp2=$(echo $info | awk -F[,] '{print $2}')
        echo $((tmp2 - tmp1 + 1)) #+1 or not? diff output parsing
    else
        echo 1
    fi
}

# Initialize variables with default values
compare_hidden=false
output_info=false
treat_symlinks=false
regex_exp=""
recursive=false

# Parse command-line options
while getopts ":ahln:r" opt; do
  case $opt in
    a)
      compare_hidden=true
      ;;
    h)
      output_info=true
      ;;
    l)
      treat_symlinks=true
      ;;
    n)
      regex_exp="$OPTARG" #receive
      #recursive=true
      ;;
    r)
      recursive=true
      ;;
    \?) #not listed options
      #echo "Invalid option: -$OPTARG"
      usage
      exit 1
      ;;
  esac
done

# Shift the processed options
# <PATH A>、<PATH B> 需出現在所有 [OPTION] 的後面
shift $((OPTIND - 1))

file_a="$1"
file_b="$2"

# Problem1: Check for invalid combinations of options
#
# Check if there are enough arguments and that the files exist
if [[ $# -ne 2 ]]; then
  usage
  exit 1
fi

# Check if -a and -n comes with -r option
if [ "$recursive" = false ] && ([ "$compare_hidden" = true ] || [ -n "$regex_exp" ]); then
  usage #call usage function
  exit 1
fi

# Display information about compare.sh if -h is specified
if [[ "$output_info" = true ]]; then
  usage
  exit 1
fi

# Check symbolic link
#if [[ "$treat_symlinks" = false ]] && [[ -L $file_a ]]

#line_a=$(wc -l < "$file_a")
#line_b=$(wc -l < "$file_b")

a=0; b=0; c=0 #刪除、插入、保留

pattern='[0-9][[:alpha:]][0-9]' #for grep expression

# Check if both files exist
if [[ -f "$file_a" ]] && [[ -f "$file_b" ]]; then
  #echo "Error: One or both files do not exist."
  #exit 1
  #echo "arg1 and arg2 are files"

  mes=`diff -d $file_a $file_b`
  x=$(calculate_changes "$file_a" "$mes" "$pattern") #self-defined function 
  echo "changed $x%"
fi

# Perform the comparison based on the configured options
# Add your comparison logic here...


# Example: Use diff command for recursive directory comparison
if [[ "$recursive" = true ]] && [[ -d "$1" ]] && [[ -d "$2" ]]; then
  #檢查是否存在
  #echo "arg1 and arg2 are directories"
  #排除隱藏檔案（預設會找到）
  #use find to filter out hidden files and link files
  #如果有超多種option的組合那要寫一大堆條件判斷？
  #也可 diff -rq 再去算change percentage
  
  arr=()

  if [[ "$compare_hidden" = true ]] && [[ "$treat_symlinks" = true ]]; then
      #echo "here -a -l"
      diff_info=`diff -d -r "$1" "$2"`
  elif [[ "$treat_symlinks" = true ]]; then
      #echo "here -l"
      diff_info=`diff -d -r --exclude='.*' "$1" "$2"`
  elif  [[ "$compare_hidden" = true ]]; then
      #echo "here -a"
      diff_info=`diff -d  -r --exclude='$(type -l)' "$1" "$2"`
  else
      #echo "here"
      diff_info=`diff -d  -r --exclude='.*' --exclude='$(type -l)' "$1" "$2"`
  fi
  

  #other cases: read diff_info line by line
  #IFS=$' \t\n' by default
  echo "$diff_info" | while IFS= read -r line; do
    
    #check whether -n option is specified
    # ${#regex_exp} -gt 0 
    if [[ -n $regex_exp ]]; then
        if [[ ! $line =~ $regex_exp ]]; then
          continue #if doesn't satisfy condition then skip
        fi
    fi

    #echo "line: $line"
    if [[ $line == diff* ]]; then

        filepath=$(echo "$line" | awk '{print $NF}' | grep *dir2/)
        file_a=$(echo "$line" | awk '{print $((NF - 1))}')
        file_b=$(echo "$line" | awk '{print $NF}')

        mes=`diff -d $file_a $file_b`
        x=$(calculate_changes "$file_a" "$mes" "$pattern") #self-defined function

        arr+=$(echo "$filepath: changed $x%")
        echo "$filepath: changed $x%"
        #echo "file_a: $file_a"
        #echo "file_b: $file_b"

    elif [[ $line == Binary* ]]; then
        filepath=$(echo "$line" | awk '{print $((NF - 1))}' | xargs basename)
        arr+=$(echo "$filepath: changed 100%")
        echo "$filepath: changed 100%"

    elif [[ $line == Only* ]]; then
        name=$(echo "$line" | awk '{print $3}')
        filepath=$(echo "$line" | awk '{print $NF}')

        if [[ $name == "$1:" ]]; then
            arr+=$(echo "delete $filepath")
            echo "delete $filepath"
            
        elif [[ $name == "$2:" ]]; then
            arr+=$(echo "create $filepath")
            echo "create $filepath"
        fi
    fi
  done

#sort and output


#&& ([ "$compare_hidden" = true ] || [ "${#regex_exp}" -gt 0 ])
elif [[  "$recursive" = true ]]; then
  usage #call usage function

fi
