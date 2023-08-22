curl -q -LSsf "https://api.github.com/repos/ampache/ampache/releases/latest" | grep browser_download_url | sed 's|^.* ||g;s|"||g'
