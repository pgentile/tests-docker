
CLEAN_SUBMAKES=$(addprefix clean-,$(SUBMAKES))

all: $(SUBMAKES)
clean: $(CLEAN_SUBMAKES)

$(SUBMAKES):
	$(MAKE) -C $@

$(CLEAN_SUBMAKES):
	name=$$(echo $@ | sed 's/^clean-//') && $(MAKE) -C $$name clean

.PHONY: $(SUBMAKES) $(CLEAN_SUBMAKES)
