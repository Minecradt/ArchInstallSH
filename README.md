One liner:

curl "https://github.com/Minecradt/ArchInstallSH/raw/master/archinstall.sh" -o "a.sh"&&python3 -c "open('install.sh','w').write(''.join(open('a.sh','r').readlines()))"&&rm -rf a.sh&&bash install.sh
