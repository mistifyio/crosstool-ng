root_dir = $(shell pwd)

build_dir = $(root_dir)/target
build_output_dir = $(build_dir)/compiled_output
download_dir = $(HOME)/.toolchain/downloads
distributions_dir = $(build_dir)/distributions

version = $(shell cat .version)
arch = x86_64-unknown-linux-gnu
version_extra = base

config_file = .config
config_status_file = config.status
distribution = $(distributions_dir)/crosstool-ng-$(arch)-$(version)-$(version_extra).tar.gz

.Phony: build clean fullclean dist distclean version tagformat

# Needed for ct-ng build script
export TC_PREFIX=$(arch)
export TC_ARCH_SUFFIX=$(versionExtra)-$(version)
export TC_PREFIX_DIR=$(build_output_dir)
export TC_LOCAL_TARBALLS_DIR=$(download_dir)

all: build

$(config_file):;

$(config_status_file):;

$(download_dir):
	mkdir -p $(download_dir)

$(build_output_dir):
	mkdir -p $(build_output_dir)

$(distributions_dir):
	mkdir -p $(distributions_dir)

createbuildirs: | $(download_dir) $(build_output_dir) $(distributions_dir)

bootstraptoolchain.cache: $(config_file)
	./bootstrap
	touch bootstraptoolchain.cache

configuretoolchain.cache: bootstraptoolchain.cache $(config_status_file)
	./configure --enable-local --prefix=$(root_dir)
	touch configuretoolchain.cache

build: configuretoolchain.cache createbuildirs
	./ct-ng build

dist:
	tar cvzf $(distribution) $(build_output_dir)

distclean:
	-rm $(distributions_dir)/*

clean:
	-rm -rf $(build_output_dir)
	if [ -f ct-ng ]; then ./ct-ng distclean; fi;

fullclean: clean
	-rm $(config_status_file)

version:
	@echo $(version)

tagformat:
	@echo $(arch)-{new_version}-$(version_extra)