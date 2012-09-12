---
layout: default
title: An Example Page Title
scripts:
 - //ajax.googleapis.com/ajax/libs/jquery/1.8.1/jquery.min.js
 - vendor/someLibrary/coreInclude.js
 - first/script.js
styles:
 - a/stylesheet.css
 - vendor/someLibrary/componentStyle.css
---
Three types of scripts:
 - External/CDN-hosted scripts: Declaring a script with a protocol or two leading slashes will simply inline the script as the `src` attribute of the script tag
 - Third-party library code: provided the third party code is a directory under a `vendor` directory, the `src` attribute will be modified to point to the correct item
 - Everything else: all other scripts are expected to be under the `assets` subdirectory of `source`.

 Two types of stylesheets:
 - Third-party library stylesheets: same rules as for scripts
 - Everything else: must also be in the `assets` subdirectory of the page `source`
