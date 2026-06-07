OPENSCAD := /Applications/OpenSCAD-2021.01.app/Contents/MacOS/OpenSCAD
MODELS   := $(shell find models -name '*.scad')
STLS     := $(patsubst models/%.scad,build/%.stl,$(MODELS))
THREEMFS := $(patsubst models/%.scad,build/%.3mf,$(MODELS))

.PHONY: all stl 3mf clean

all: stl 3mf

stl: $(STLS)

3mf: $(THREEMFS)

build/%.stl: models/%.scad | build
	@mkdir -p $(dir $@)
	$(OPENSCAD) -o $@ $<

build/%.3mf: models/%.scad | build
	@mkdir -p $(dir $@)
	$(OPENSCAD) -o $@ $<

build:
	mkdir -p build

clean:
	rm -rf build
