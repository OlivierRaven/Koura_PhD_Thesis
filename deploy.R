# deploy.R - post-render script: prevents GitHub Pages from running Jekyll over
# docs/, which would otherwise silently ignore underscore-prefixed folders
# (_freeze, site_libs, etc.) that Quarto generates.

system("powershell -Command \"New-Item -Force 'docs\\.nojekyll' -ItemType File | Out-Null\"")

cat("Deploy complete - docs folder updated\n")
