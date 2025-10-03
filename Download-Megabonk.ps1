# Define the GoFile page URL
$gofilePageUrl = "https://gofile.io/d/L38srC"

Write-Host "Fetching GoFile page..."
$page = Invoke-WebRequest -Uri $gofilePageUrl

Write-Host "Extracting direct download link..."
$downloadUrl = ($page.Content | Select-String -Pattern '"link":"(https:[^"]+)"').Matches.Groups[1].Value

if (-not $downloadUrl) {
    Write-Host "Could not find the direct download link. Please check the page manually."
    exit 1
}

Write-Host "Found download link: $downloadUrl"

# Define output file name (change as needed)
$outputFile = "megabonk.zip"

Write-Host "Starting download..."

# Setup progress bar parameters
$webClient = New-Object System.Net.WebClient

$webClient.DownloadProgressChanged += {
    param($sender, $e)
    Write-Progress -Activity "Downloading megabonk.zip" -Status "$($e.ProgressPercentage)% Complete" -PercentComplete $e.ProgressPercentage
}

$webClient.DownloadFileCompleted += {
    Write-Host "`nDownload completed! File saved as $outputFile"
}

$webClient.DownloadFileAsync($downloadUrl, $outputFile)

# Wait for download to complete
while ($webClient.IsBusy) {
    Start-Sleep -Milliseconds 200
}
