#!/bin/bash
cd /home/edward/alm_notifier/current
rbenv rehash
ruby hell/alm_control_expiring_stop.rb
ruby hell/alm_control_holidays_stop.rb
