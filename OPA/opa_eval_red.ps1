# Runs OPA and prints ONLY the strings inside the JSON "value" array, in red.
# Usage:
#   ./opa_eval_red.ps1 -Input "..\Terraform\plan.json" -Policy "deny_public_internet.rego" -Query "data.terraform.deny_public_internet.deny" -FailDefined

param(
  [Parameter(ValueFromRemainingArguments=$true)] [string[]]$ArgsAll
)

## Parse arguments in an OPA-compatible way: --input <file> --data <file> [--fail-defined] [--only-generic] 'query'
$Input = $null
$Policy = $null
$Query = $null
$FailDefined = $false
$OnlyGeneric = $false

$i = 0
while ($ArgsAll -and $i -lt $ArgsAll.Count) {
  $tok = [string]$ArgsAll[$i]
  switch -regex ($tok) {
    '^-{1,2}input$'        { if ($i+1 -lt $ArgsAll.Count) { $Input = [string]$ArgsAll[$i+1]; $i += 1 }; break }
    '^-{1,2}data$'         { if ($i+1 -lt $ArgsAll.Count) { $Policy = [string]$ArgsAll[$i+1]; $i += 1 }; break }
    '^-{1,2}fail-defined$' { $FailDefined = $true; break }
    '^-{1,2}only-generic$' { $OnlyGeneric = $true; break }
    '^-{1,2}format$'       { if ($i+1 -lt $ArgsAll.Count) { $null = $ArgsAll[$i+1]; $i += 1 }; break }
    '^-.*'                 { # Ignore other flags
                             break }
    default                { if (-not $Query) { $Query = $tok } break }
  }
  $i += 1
}

if (-not $Input -or -not $Policy -or -not $Query) {
  Write-Host "Usage (OPA-compatible):" -ForegroundColor Yellow
  Write-Host "  ./opa_eval_red.ps1 --input <plan.json> --data <policy.rego> [--fail-defined] 'query'" -ForegroundColor Yellow
  exit 2
}

$argsList = @('eval', '--input', $Input, '--data', $Policy)

if ($Pretty) { $argsList += @('--format','pretty') }
if ($FailDefined) { $argsList += '--fail-defined' }

$argsList += $Query


# Run OPA and capture output and exit code
$output = (& opa @argsList 2>&1) -join "`n"
$exit = $LASTEXITCODE

try {
  # Parse the JSON output
  $json = $output | ConvertFrom-Json

  # Collect all strings under result[*].expressions[*].value (array or scalar)
  $values = @()
  if ($null -ne $json.result) {
    foreach ($res in @($json.result)) {
      if ($null -ne $res.expressions) {
        foreach ($expr in @($res.expressions)) {
          if ($PSBoundParameters.ContainsKey('Pretty')) { continue } # pretty format isn't JSON; safeguard
          if ($null -ne $expr.value) {
            $values += @($expr.value)
          }
        }
      }
    }
  }

  # Print only the values (each on its own line, in red). If empty, print nothing.
  $toPrint = $values
  if ($OnlyGeneric) {
    $toPrint = @($values | Where-Object { $_ -is [string] -and $_.StartsWith('Resource ') })
  }

  foreach ($v in $toPrint) {
    Write-Host $v -ForegroundColor Red
  }
} catch {
  # If JSON parsing fails, print original output (best-effort fallback)
  Write-Host $output
}

exit $exit
