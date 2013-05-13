TARGETS := src

all clean:
	for i in ${TARGETS}; do \
		${MAKE} -C $${i} $@ || exit 1; \
	done

.PHONY: all clean
