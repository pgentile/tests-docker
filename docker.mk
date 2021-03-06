
CLEAN_IMAGES=$(addprefix clean-,$(IMAGES))

all: $(IMAGES)
clean: $(CLEAN_IMAGES)

$(IMAGES):
	docker build -t pgentile/$@ $@

$(CLEAN_IMAGES):
	-docker rmi pgentile/$(patsubst clean-%,%,$@)

.PHONY: $(IMAGES) $(CLEAN_IMAGES)
