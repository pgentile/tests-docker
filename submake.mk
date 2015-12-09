
CLEAN_SUBMAKES=$(addprefix clean-,$(SUBMAKES))

all: $(SUBMAKES)
clean: $(CLEAN_SUBMAKES)

$(SUBMAKES):
	$(MAKE) -C $@

$(CLEAN_SUBMAKES):
	$(MAKE) -C $(patsubst clean-%,%,$@) clean

.PHONY: $(SUBMAKES) $(CLEAN_SUBMAKES)
