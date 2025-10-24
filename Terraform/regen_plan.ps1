param(
    [string]$PlanFile = "tfplan.bin",
    [string]$JsonFile = "plan.json"
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

Write-Host "[regen_plan] Generating Terraform plan -> $PlanFile" -ForegroundColor Cyan
terraform plan -out $PlanFile | Out-Host

if (!(Test-Path -LiteralPath $PlanFile)) {
    throw "Plan file not found: $PlanFile"
}

Write-Host "[regen_plan] Exporting JSON from '$PlanFile' -> $JsonFile" -ForegroundColor Cyan
terraform show -json $PlanFile > $JsonFile

if (!(Test-Path -LiteralPath $JsonFile)) {
    throw "JSON export failed: $JsonFile"
}

$planInfo = Get-Item -LiteralPath $PlanFile
$jsonInfo = Get-Item -LiteralPath $JsonFile
Write-Host ("[regen_plan] Done. Plan: {0}  Updated: {1}" -f $planInfo.FullName, $planInfo.LastWriteTime) -ForegroundColor Green
Write-Host ("[regen_plan] JSON: {0}  Updated: {1}" -f $jsonInfo.FullName, $jsonInfo.LastWriteTime) -ForegroundColor Green
