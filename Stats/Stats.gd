extends Node

export var isInfected: bool = false setget infection

signal infect

func infection(infected: bool):
    isInfected = infected
