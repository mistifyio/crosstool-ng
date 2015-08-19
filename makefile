root_dir = $(shell pwd)

build_dir = $(root_dir)/build
build_output_dir = $(build_dir)/compiled_output
download_dir = $(build_dir)/downloads
distributions_dir = $(build_dir)/distributions

version = 1.0.1
version_extra =
arch = x86_64-unknown-linux-gnu

config_file = .config
distribution = $(distributions_dir)/crosstool-ng-$(arch)-$(version)$(version_extra).tar.gz

.Phony: bootstraptoolchain build clean configuretoolchain fullclean dist distclean version

export TC_PREFIX=$(arch)
export TC_ARCH_SUFFIX=$(versionExtra)-$(version)
export TC_PREFIX_DIR=$(build_output_dir)
export TC_LOCAL_TARBALLS_DIR=$(download_dir)

$(config_file):;

config.status:;

build: configuretoolchain
	./ct-ng build

$(download_dir):
	mkdir -p $(download_dir)

$(build_output_dir):
	mkdir -p $(build_output_dir)

$(distributions_dir):
	mkdir -p $(distributions_dir)

createbuildirs: | $(download_dir) $(build_output_dir) $(distributions_dir)

bootstraptoolchain: $(config_file)
	./bootstrap

configuretoolchain: bootstraptoolchain config.status
	./configure --enable-local --prefix=$(root_dir)

dist:
	tar cvzf $(distribution) $(build_output_dir)

distclean:
	-rm $(distribution)

clean:
	rm -rf $(build_output_dir)
	if [ -f ct-ng ]; then ./ct-ng distclean; fi;

fullclean: clean
	rm $(config_file)
	-rm config.status

version:
	@echo $(version)