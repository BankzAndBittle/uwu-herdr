#!/bin/sh
# Self-check for hop.sh's target choice.
cd "$(dirname "$0")"
a() { printf '{"pane_id":"%s","agent_status":"%s","state_change_seq":%s,"focused":%s}' "$@"; }
list() { printf '{"result":{"agents":[%s]}}' "$1"; }
t() { got=$(list "$1" | ./hop.sh --pick); [ "$got" = "$2" ] && echo "ok   $3" || { echo "FAIL $3: got '$got' want '$2'"; exit 1; }; }

t "$(a p1 done 9 false),$(a p2 blocked 3 false)"                       p2 "blocked beats done"
t "$(a p1 blocked 3 false),$(a p2 blocked 7 false)"                    p2 "newest blocked first"
t "$(a p1 blocked 9 true),$(a p2 done 1 false)"                        p2 "skips focused agent"
t "$(a p1 working 9 false),$(a p2 idle 1 false)"                       ""  "nothing waiting"
