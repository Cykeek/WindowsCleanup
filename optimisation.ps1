param (
    [int]$delay = 100
)

# Function to set registry values
function Set-RegistryValue {
    param (
        [string]$path,
        [string]$name,
        [object]$value
    )
    Set-ItemProperty -Path $path -Name $name -Value $value
}

# Function to check if registry values are already set
function Check-RegistryValues {
    param (
        [string]$path,
        [string]$name,
        [object]$value
    )
    $currentValue = Get-ItemPropertyValue -Path $path -Name $name -ErrorAction SilentlyContinue
    if ($currentValue -eq $value) {
        return $true
    }
    else {
        return $false
    }
}

$regPathDesktop = "HKCU:\Control Panel\Desktop"
$regPathVisualFX = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects"
$regPathPerformance = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"

# Check if registry values are already set
$optimized = $true
$optimized = $optimized -and (Check-RegistryValues -path $regPathDesktop -name "MenuShowDelay" -value $delay)
$optimized = $optimized -and (Check-RegistryValues -path $regPathVisualFX -name "VisualFXSetting" -value 2)
$optimized = $optimized -and (Check-RegistryValues -path $regPathPerformance -name "TaskbarAnimations" -value 0)
$optimized = $optimized -and (Check-RegistryValues -path $regPathPerformance -name "ListviewAlphaSelect" -value 0)
$optimized = $optimized -and (Check-RegistryValues -path $regPathPerformance -name "ComboBoxAnimation" -value 0)
$optimized = $optimized -and (Check-RegistryValues -path $regPathPerformance -name "CursorShadow" -value 0)
$optimized = $optimized -and (Check-RegistryValues -path $regPathPerformance -name "DropShadow" -value 0)
$optimized = $optimized -and (Check-RegistryValues -path $regPathPerformance -name "MenuAnimation" -value 0)
$optimized = $optimized -and (Check-RegistryValues -path $regPathPerformance -name "SelectionFade" -value 0)
$optimized = $optimized -and (Check-RegistryValues -path $regPathPerformance -name "TooltipAnimation" -value 0)
$optimized = $optimized -and (Check-RegistryValues -path $regPathPerformance -name "FadeStartMenu" -value 0)
$optimized = $optimized -and (Check-RegistryValues -path $regPathPerformance -name "SmoothScroll" -value 0)
$optimized = $optimized -and (Check-RegistryValues -path $regPathPerformance -name "EnablePeek" -value 0)

# If PC is already optimized, display message and exit
if ($optimized) {
    Write-Host "Your PC is already optimized."
    exit
}

# If PC is not optimized, execute optimizations
# Set MenuShowDelay to speed up menu animations
Set-RegistryValue -path $regPathDesktop -name "MenuShowDelay" -value $delay

# Disable unnecessary visual effects for performance boost
Set-RegistryValue -path $regPathVisualFX -name "VisualFXSetting" -value 2  # Custom settings

# Customize the visual effects settings to disable specific animations
Set-RegistryValue -path $regPathPerformance -name "TaskbarAnimations" -value 0
Set-RegistryValue -path $regPathPerformance -name "ListviewAlphaSelect" -value 0
Set-RegistryValue -path $regPathPerformance -name "ComboBoxAnimation" -value 0
Set-RegistryValue -path $regPathPerformance -name "CursorShadow" -value 0
Set-RegistryValue -path $regPathPerformance -name "DropShadow" -value 0
Set-RegistryValue -path $regPathPerformance -name "MenuAnimation" -value 0
Set-RegistryValue -path $regPathPerformance -name "SelectionFade" -value 0
Set-RegistryValue -path $regPathPerformance -name "TooltipAnimation" -value 0
Set-RegistryValue -path $regPathPerformance -name "FadeStartMenu" -value 0
Set-RegistryValue -path $regPathPerformance -name "SmoothScroll" -value 0
Set-RegistryValue -path $regPathPerformance -name "EnablePeek" -value 0

Write-Host "Your PC has successfully been Optimized. Reboot is recommended."
