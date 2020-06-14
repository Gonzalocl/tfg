#!/bin/bash


log_file="$1"
group_format_0='  <g>
    <use width="100" height="100" xlink:href="#model"/>
    <text x="36.387" y="29" style="font-size: 14px;">%s</text>
    <text x="36.385" y="46" style="font-size: 14px;">%s</text>
    <text x="36.388" y="58" style="font-size: 14px;">%s</text>
    <text x="36.385" y="90" style="font-size: 14px;">%s</text>
  </g>
'
group_format_1='  <g>
    <use width="100" height="100" xlink:href="#model"/>
    <text x="36.387" y="29" style="font-size: 14px;">%s</text>
    <text x="36.385" y="46" style="font-size: 14px;">%s</text>
    <text x="36.385" y="90" style="font-size: 14px;">%s</text>
  </g>
'

i=0
grep -v "Best" "$log_file" | grep -v "Step" | tr -s '\n ' | tr -d '%' | cut --complement -c 1 | while read l; do
  group_a="$(cut -d ':' -f 1 <<< $l)"
  group_b0="$(cut -d ':' -f 2 <<< $l | cut -d ' ' -f 1 | cut -d ',' -f 1,2 | tr ',' ' ')"
  group_b1="$(cut -d ':' -f 2 <<< $l | cut -d ' ' -f 1 | cut -d ',' -f 3,4 | tr ',' ' ')"
  percentaje="$(printf %.1f%% $(cut -d ' ' -f 2 <<< $l | tr '.' ',') | tr ',' '.')"
  if [[ i -lt 9 ]]; then
    printf "$group_format_0" "$group_a" "$group_b0" "$group_b1" "$percentaje"
  else
    printf "$group_format_1" "$group_a" "$group_b0" "$percentaje"
  fi
  ((i++))
done
