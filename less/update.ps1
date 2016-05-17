import-module au

$releases = 'http://guysalias.tk/misc/less/'

function global:au_SearchReplace {
    @{}
}

function global:au_BeforeUpdate {
    iwr $Latest.URL -OutFile less.7z
    7za x less.7z

    $lessdir = 'less-*-win*'
    pushd $lessdir
    cp less.exe, lesskey.exe, readme "$PSScriptRoot\tools" -Force
    "Source: http://guysalias.tk/misc/less" | Out-File "$PSScriptRoot\tools\source.txt"
    popd
    rm $lessdir -recurse -force
}

function global:au_GetLatest {
    $download_page = Invoke-WebRequest -Uri $releases

    $re    = 'less-.+win.+\.7z'
    $url   = $download_page.links | ? href -match $re | select -First 1 -expand href

    $version = ($url -split '-' | select -Index 1) / 100
    $url = $releases + $url

    $Latest = @{ URL = $url; Version = $version }
    return $Latest
}

update