#!/bin/bash

rpm -qa --root $BUILDROOT | sort -h > $OUTPUTDIR/manifest.log

