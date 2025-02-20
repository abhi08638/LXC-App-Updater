#!/bin/bash
fdroidcl clean

fdroidcl update

fdroidcl download io.homeassistant.companion.android.minimal

cp /root/.cache/fdroidcl/apks/*.apk ~/downloads

mv ~/downloads/*.apk ~/downloads/ha.apk
