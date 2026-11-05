#!/usr/bin/env bash
# After a git commit, check that any commit changing the site's content or code also
# updated its project memory (CLAUDE.md). If not, tell Claude to do it.
cd "${CLAUDE_PROJECT_DIR:-$(git rev-parse --show-toplevel)}" || exit 0
files=$(git show --name-only --pretty=format: HEAD 2>/dev/null) || exit 0
if grep -qE '^(people|events|static|tests|site)/|^build\.py$' <<<"$files" && ! grep -qx 'CLAUDE.md' <<<"$files"; then
  msg="The last commit changed the site but did not update the project memory. Update CLAUDE.md (people list, rules, and the change log) to reflect this commit, then commit it."
  jq -n --arg m "$msg" '{systemMessage: $m, hookSpecificOutput: {hookEventName: "PostToolUse", additionalContext: $m}}'
fi
exit 0
