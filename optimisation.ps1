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

$regPathDesktop = "HKCU:\Control Panel\Desktop"
$regPathVisualFX = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects"
$regPathPerformance = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"

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

Write-Host "Windows animations and visual effects have been optimized for better performance."
Write-Host "Please restart your computer for changes to take effect."
