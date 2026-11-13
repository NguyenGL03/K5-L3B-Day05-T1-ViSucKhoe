$ErrorActionPreference = 'Stop'
$envFile = Join-Path $PSScriptRoot '.env'
if (-not (Test-Path -LiteralPath $envFile -PathType Leaf)) {
  throw 'Chưa có prototype/.env. Sao chép prototype/.env.example thành .env rồi điền CKEY_API_KEY.'
}
node "--env-file=$envFile" -e "if (!process.env.CKEY_API_KEY?.trim()) { console.error('Thiếu CKEY_API_KEY trong prototype/.env'); process.exit(1) }"
if ($LASTEXITCODE -ne 0) {
  throw 'Không thể khởi động: thiếu CKEY_API_KEY.'
}
node "--env-file=$envFile" (Join-Path $PSScriptRoot 'server.mjs')
