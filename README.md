# LXC-App-Updater
Set up a debian LXC to update apps on android devices locally over ADB using Fdroid


For reference I use 5 Sonoff NS Panel 120's in my home as HA Dashboards. These devices essentially run AOSP 8.0 and can run most android apps. The problem is that these devices will never get any security updates so they pose a security risk to your network.

SCOPE:

This guide is meant to restrict internet access on these devices to reduce the attack vector. It was created for the NS Panel Pro but it should work with any android tablet that has access to ADB. I will NOT be covering how to get the NS Panel Pro into the stock android launcher (see the below guides for that).

Script files can be found on my GitHub https://github.com/abhi08638/LXC-App-Updater/tree/main

Requirements

    ADB

    Some basic knowledge of networking

    A server for hosting and running the scripts

    Chrony add-on in Home Assistant

        A downside of blocking internet access to the tablet is that the clocks can get messed up. We will provide the tablets with an internal NTP server to sync the clocks instead

    Mosquitto Broker Add-on in Home Assistant

        This will be used to track the status of updates for the devices

Abbreviations/Terms

    ha.internal

        dns rewrite of my home assistant IP address

        I prefer not using the IP address just so if you need to change the IP of HA or even your subnet then you dont need to change these settings again

    NSP

        Short for NS Panel Pro

    All Path files are just references, use your own paths to your files

Prepping NSP

Follow this guide

    https://github.com/seaky/nspanel_pro_tools_apk?tab=readme-ov-file#device-rooting-and-sideload

        I also like to go into the settings and set up the navigation bar

    https://blakadder.com/nspanel-pro-secrets/

        Turn off start up sound

        Upgrade TTS Voice

            Useful for sending TTS notifications to the device to make it play messages

        Debloat Apps

            Commands listed below

            https://github.com/abhi08638/LXC-App-Updater/blob/main/Sonoff%20NS%20Panel%20Pro%20Commands

Firewall Rules (Opnsense)
r/homeassistant - nsp_switches is an alias for the group of NSP devices with static ip address reservations
nsp_switches is an alias for the group of NSP devices with static ip address reservations

Prepping HA

We want to be able to track if an update was successful or not, so why not track it within home assistant itself using MQTT?

    Create an MQTT login for the LXC under the configuration tab of the Mosquitto Broker addon in HA

r/homeassistant - This will be used by the LXC to authenticate to the MQTT server
This will be used by the LXC to authenticate to the MQTT server

    Create an MQTT sensor in your configuration.yaml to track the sensor

        I created 1 sensor to track all my devices but you can create 1 sensor for each device if you wish

        https://github.com/abhi08638/LXC-App-Updater/blob/main/configuration.yaml

Prepping Server

You can use any linux server/computer you want but I am using a debian LXC in proxmox so my commands will be specific to debian.

    https://community-scripts.github.io/ProxmoxVE/scripts?id=debian

    Install the fdroidcl package on your system

        https://packages.debian.org/buster/fdroidcl

    Install MQTT Broker

        sudo apt install mosquitto mosquitto-clients

    Create directories in root

        mkdir scripts

        mkdir downloads

        Create files in scripts folder

            nano adb-ips.index

            nano download-apps.sh

            nano install-apps.sh

    Add your scripts to Cron for the frequency you want

        crontab -e

            0 11 1,15 * * ~/scripts/install-apps.sh

Test it out an celebrate if all goes well!
