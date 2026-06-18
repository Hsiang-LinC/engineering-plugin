#!/usr/bin/env bash

cat << 'EOF'
{
  "suppressOutput": true,
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": "Before browsing the web for any SWE documentation, try Context7 first: resolve the library/tool ID, query the docs, and only use web search if Context7 lacks the needed coverage."
  }
}
EOF

exit 0
