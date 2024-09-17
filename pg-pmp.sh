#!/bin/bash

output_dir="${1:-./pstacks/}"
mkdir -p "$output_dir"

pids=$(pgrep -f postgres)

combined_output="$output_dir/combined_pstack.txt"
> $combined_output
for pid in $pids
do
    output_file="$output_dir/pstack_${pid}.txt"

    if ps -p $pid > /dev/null; then
        pstack $pid > "$output_file"
        cat $output_file | awk 'BEGIN { s = ""; } { if (s != "" ) { s = s "," $4} else { s = $4 } } END { print s }' >> "$combined_output"
    else
        echo "PID $pid is no longer valid."
    fi
done

cat $combined_output | sort | uniq -c | sort -r -n -k 1,1
