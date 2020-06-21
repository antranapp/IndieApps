#! /bin/zsh

swiftformat --header ignore **/Package.swift
swiftformat --exclude **/Package.swift .
