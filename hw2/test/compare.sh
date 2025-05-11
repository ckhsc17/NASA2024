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
    local mes=(`diff -d -u $1 $2`)

    local line_a=$(wc -l < "$1")
    local mes=$2
    local pattern=$3
    local a=0; b=0; c=0;
    #local b=0
    
    local flag=0

    for line in "${mes[@]}"; do
        if [[ "$line" == "@@" ]]; then
            flag=$((flag + 1))
        fi
        if [[ $flag -ge 2 ]]; then
            if [[ "$line" == -* ]]; then
                a=$((a + 1))
            elif [[ "$line" == +* ]]; then
                b=$((b + 1))
            fi
        fi
    done
    
    c=$(($line_a - a))
    #echo "flag: $flag"
    #echo "(a,b,c): $a $b $c"
    
    # calculate x
    if [[ $a -gt $b ]]; then
        x=$(((100 * a) / (a + c)))
    else
        x=$(((100 * b) / (b + c)))
    fi

    echo $((x))
}

# Initialize variables with default values
compare_hidden=false
output_info=false
treat_symlinks=false
regex_bool=false
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
      regex_bool=true
      regex_exp="$OPTARG" #receive regular expression
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
if [[ "$recursive" = false ]] && ([[ "$compare_hidden" = true ]] || [[  "$regex_bool" = true ]] || [[ -n "$regex_exp" ]]); then
    usage #call usage function
    exit 1
fi
# Display information about compare.sh if -h is specified
if [[ "$output_info" = true ]]; then
    usage
    exit 1
fi
# Check symbolic link
if [[ "$treat_symlinks" = false ]] && ([[ -L $file_a ]] || [[ -L $file_b ]]); then
    usage
    exit 1
fi
# -n but no expression given
if [[ "$regex_bool" = true ]] && [[ -z "$regex_exp" ]]; then
    usage
    exit 1
fi

#line_a=$(wc -l < "$file_a")
#line_b=$(wc -l < "$file_b")

a=0; b=0; c=0 #刪除、插入、保留

pattern='[0-9][[:alpha:]][0-9]' #for grep expression

# Check if both files exist
if [[ "$recursive = false" ]] && [[ -f "$file_a" ]] && [[ -f "$file_b" ]]; then
  x=$(calculate_changes "$file_a" "$file_b") #self-defined function 
  echo "changed $x%"

elif [[ "$recursive" = false ]]; then
    usage
    exit 1
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
  
  arr1=()
  arr2=()

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

        filepath=$(echo "$line" | awk '{print $NF}' | sed 's/.*dir2\///')
        file_a=$(echo "$line" | awk '{print $((NF - 1))}')
        file_b=$(echo "$line" | awk '{print $NF}')

        x=$(calculate_changes "$file_a" "$file_b") #self-defined function

        arr+=$(echo "$filepath: changed $x%")
        echo "$filepath: changed $x%"
        #echo "file_a: $file_a"
        #echo "file_b: $file_b"

    elif [[ $line == Binary* ]]; then
        filepath=$(echo "$line" | awk '{print $((NF - 1))}' | sed 's/.*dir2\///')
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
elif [[  "$recursive" = true ]]; then #means $1 or $2 is not a directory
    #echo "died 266"
    usage #call usage function
    exit 1

fi
