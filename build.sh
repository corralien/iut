#!/bin/bash

pandoc -t beamer -V theme:metropolis ansible.md -o ansible.pdf
