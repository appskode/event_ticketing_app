#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

if ! command -v caddy >/dev/null 2>&1; then
	echo "Caddy is required for local HTTPS."
	echo "Install: brew install caddy"
	exit 1
fi

echo "Starting Laravel on http://127.0.0.1:8001 (internal)..."
# Suppress PHP 8.5 PDO deprecation noise in CLI (API responses are already clean via public/index.php)
php -d error_reporting="E_ALL & ~E_DEPRECATED & ~E_USER_DEPRECATED" artisan serve --host=127.0.0.1 --port=8001 &
PHP_PID=$!

cleanup() {
	kill "$PHP_PID" 2>/dev/null || true
}
trap cleanup EXIT INT TERM

echo "Starting HTTPS proxy on https://127.0.0.1:8000"
echo "API base URL: https://127.0.0.1:8000/api"
caddy run --config Caddyfile.dev
