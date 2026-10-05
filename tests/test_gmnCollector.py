#
# tests for gmnCollector.py
# Copyright (C) 2018-2023 Mark McIntyre
#

from gmnCollector import scpconn


conn = scpconn('.', 'gmn.uwo.ca', 'analysis', '~/.ssh/gmnanalysis')

def test_getListOfStations():
    assert 'uk0006' in conn.getListOfStations()

def test_getFilteredStations():
    assert 'ua0001' in conn.getFilteredStations('ua')
