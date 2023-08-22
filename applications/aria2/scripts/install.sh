curl -q -LSsf https://api.github.com/repos/mayswind/AriaNg/releases/latest | grep 'browser_download_url' | grep '[0-9]\.zip' | sed 's|^.* ||g;s|"||g'
