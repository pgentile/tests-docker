IMAGES=consul

$(IMAGES):
	docker build -t ${USER}/$@ $@

.PHONY: $(IMAGES)
