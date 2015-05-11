#!/bin/bash
cd /home/edward/alm_notifier/current
rbenv rehash
ruby hell/alm_control_expiring.rb
ruby hell/alm_control_holidays.rb
