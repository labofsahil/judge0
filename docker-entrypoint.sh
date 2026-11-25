#!/bin/bash
sudo cron

# Report YJIT status at boot (informational; no-op when Ruby lacks YJIT).
if command -v ruby >/dev/null 2>&1; then
    ruby -e 'puts "YJIT: #{RubyVM::YJIT.enabled? ? "enabled" : "not available"}"' 2>/dev/null || true
fi

exec "$@"
