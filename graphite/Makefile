include ../before.mk


# Construction des images de base

IMAGES=graphite-api-builder go-carbon

# Sous Makefiles

SUBMAKES=graphite-api

graphite-api: graphite-api-builder

# Includes
include ../docker.mk
include ../submake.mk
