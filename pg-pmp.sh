#!/bin/bash

output_dir="${1:-./pstacks/}"
mkdir -p "$output_dir"

pids=$(pgrep -f postgres)

if [ -z "$pids" ]; then
    echo "No postgres processes found"
    exit 1
fi

# Start all pstack commands in parallel to capture at nearly the same time
# echo "Capturing stacks for PIDs: $pids"
for pid in $pids
do
    output_file="$output_dir/pstack_${pid}.txt"
    if ps -p $pid > /dev/null 2>&1; then
        pstack $pid > "$output_file" 2>&1 &
    fi
done

# Wait for all background pstack commands to complete
wait

# Now process the results
combined_output="$output_dir/combined_pstack.txt"
> $combined_output

for pid in $pids
do
    output_file="$output_dir/pstack_${pid}.txt"
    if [ -f "$output_file" ] && [ -s "$output_file" ]; then
        cat $output_file | awk 'BEGIN { s = ""; } { if (s != "" ) { s = s "," $4} else { s = $4 } } END { print s }' >> "$combined_output"
    fi
done

echo ""
echo "Stack summary (count, stack trace):"
cat $combined_output | sort | uniq -c | sort -r -n -k 1,1
