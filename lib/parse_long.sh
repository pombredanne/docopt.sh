#!/usr/bin/env bash

parse_long() {
  token=${argv[0]}
  long=${token%%=*}
  value=${token#*=}
  argv=("${argv[@]:1}")
  [[ $token == --* ]] || assert_fail
  if [[ $token = *=* ]]; then
    eq='='
  else
    eq=''
    value=false
  fi
  local i=0
  local similar=()
  local similar_idx=false
  for o in "${options_long[@]}"; do
    if [[ $o == "$long" ]]; then
      similar+=("$long")
      [[ $similar_idx == false ]] && similar_idx=$i
    fi
    ((i++))
  done
  if [[ ${#similar[@]} -eq 0 ]]; then
    for o in "${options_long[@]}"; do
      if [[ $o == $long* ]]; then
        similar+=("$long")
        [[ $similar_idx == false ]] && similar_idx=$i
      fi
      ((i++))
    done
  fi
  if [[ ${#similar[@]} -gt 1 ]]; then
    die "%s is not a unique prefix: %s?" "$long" "${similar[*]}"
  elif [[ ${#similar[@]} -lt 1 ]]; then
    if [[ $eq == '=' ]]; then
      argcount=1
    else
      argcount=0
    fi
    similar_idx=${#options_short[@]}
    if [[ argcount -eq 0 ]]; then
      value=true
    fi
    options_short+=('')
    options_long+=("$long")
    options_argcount+=("$argcount")
  else
    if [[ ${options_argcount[$similar_idx]} -eq 0 ]]; then
      if [[ $value != false ]]; then
        die "%s must not have an argument" "$long"
      fi
    else
      if [[ $value == false ]]; then
        if [[ ${#argv[@]} -eq 0 || ${argv[0]} == '--' ]]; then
          die "%s requires argument" "$long"
        fi
        value=${argv[0]}
        argv=("${argv[@]:1}")
      fi
    fi
    if [[ $value == false ]]; then
      value=true
    fi
  fi
  parsed_params+=("$similar_idx")
  parsed_values+=("$value")
}
