include ../tool/make/init.mk

ALL := \
    2009 \
    1.2 \
    1.2.0 \
    1.2.1 \
    1.2.2 \

ALL_CLEAN := $(ALL:%=%-CLEAN)

clean: $(ALL_CLEAN)

%-CLEAN: %
	@$(MAKE) --no-print-directory -C $< clean
