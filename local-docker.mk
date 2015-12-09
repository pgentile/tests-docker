
CLEAN_IMAGE=$(addprefix clean-,$(IMAGE))

all: $(IMAGE)
clean: $(CLEAN_IMAGE)

$(IMAGE):
	docker build -t pgentile/$@ .

$(CLEAN_IMAGE):
	-docker rmi pgentile/$(IMAGE)

.PHONY: $(IMAGES) $(CLEAN_IMAGE)
