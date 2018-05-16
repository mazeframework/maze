PREFIX=/usr/local
INSTALL_DIR=$(PREFIX)/bin
MAZE_SYSTEM=$(INSTALL_DIR)/maze

OUT_DIR=$(shell pwd)/bin
MAZE=$(OUT_DIR)/maze
MAZE_SOURCES=$(shell find src/ -type f -name '*.cr')

all: build

build: lib $(MAZE)

lib:
	@shards install --production

$(MAZE): $(MAZE_SOURCES) | $(OUT_DIR)
	@echo "Building maze in $@"
	@crystal build -o $@ src/maze/cli.cr -p --no-debug

$(OUT_DIR) $(INSTALL_DIR):
	 @mkdir -p $@

run:
	$(MAZE)

install: build | $(INSTALL_DIR)
	@rm -f $(MAZE_SYSTEM)
	@cp $(MAZE) $(MAZE_SYSTEM)

link: build | $(INSTALL_DIR)
	@echo "Symlinking $(MAZE) to $(MAZE_SYSTEM)"
	@ln -s $(MAZE) $(MAZE_SYSTEM)

force_link: build | $(INSTALL_DIR)
	@echo "Symlinking $(MAZE) to $(MAZE_SYSTEM)"
	@ln -sf $(MAZE) $(MAZE_SYSTEM)

clean:
	rm -rf $(MAZE)

distclean:
	rm -rf $(MAZE) .crystal .shards libs lib
