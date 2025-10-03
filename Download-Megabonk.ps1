# Define the GoFile page URL
$gofilePageUrl = "https://gofile.io/d/L38srC"

# Get the GoFile page content
$page = Invoke-WebRequest -Uri $gofilePageUrl

# Extract the actual file download link from the page content
# GoFile usually puts the direct download link in a JSON object in the page
$downloadUrl = ($page.Content | Select-String -Pattern '"link":"(https:[^"]+)"').Matches.Groups[1].Value

if (-not $downloadUrl) {
    Write-Host "Could not find the direct download link. Please check the page manually."
    exit 1
}

# Define output file name (change as needed)
$outputFile = "megabonk.zip"

# Download the file
Invoke-WebRequest -Uri $downloadUrl -OutFile $outputFile

Write-Host "Downloaded to $outputFile"