include ../before.mk


# Construction des images de base

IMAGES=carbon-builder graphite-api-builder

# Sous Makefiles

SUBMAKES=carbon graphite-api

carbon: carbon-builder
graphite-api: graphite-api-builder

# Includes
include ../docker.mk
include ../submake.mk
