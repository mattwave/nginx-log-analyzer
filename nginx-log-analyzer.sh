#!/bin/bash

# Check if a log file was provided as an argument
if [ -z "$1" ]; then
    echo "Usage: ./nginx-log-analyzer.sh <path_to_log_file>"
    exit 1
fi

LOG_FILE="$1"

# Check if the file exists
if [ ! -f "$LOG_FILE" ]; then
    echo "Error: File '$LOG_FILE' not found!"
    exit 1
fi

# --- Helper Function ---
print_header() {
    echo -e "\n========================================"
    echo -e "  $1"
    echo -e "========================================\n"
}

# --- 1. Top 5 IP Addresses ---
print_header "Top 5 IP Addresses with the Most Requests"
# $1 is the first space-separated field (IP address)
awk '{print $1}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -n 5 | awk '{print $1 " requests from " $2}'

# --- 2. Top 5 Most Requested Paths ---
print_header "Top 5 Most Requested Paths"
# $7 is the 7th space-separated field (the path in the request string)
awk '{print $7}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -n 5 | awk '{print $1 " requests to " $2}'

# --- 3. Top 5 Response Status Codes ---
print_header "Top 5 Response Status Codes"
# $9 is the 9th space-separated field (status code)
awk '{print $9}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -n 5 | awk '{print $1 " times for status " $2}'

# --- 4. Top 5 User Agents ---
print_header "Top 5 User Agents"
# Using double quotes as the delimiter (-F\" ), the user agent is the 6th field in a standard combined log
awk -F\" '{print $6}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -n 5 | awk '{$1=$1; print $0}'