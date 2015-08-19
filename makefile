root_dir = `pwd`
build_dir = $(root_dir)/build
build_output_dir = $(build_dir)/compiled_output
download_dir = $(build_dir)/downloads
distributions_dir = $(build_dir)/distributions

version = 1.0.1
version_extra =
arch = x86_64-unknown-linux-gnu

config_file = .config

.Phony: bootstraptoolchain build clean configuretoolchain createbuildirs fullclean dist version

export TC_PREFIX=$(arch)
export TC_ARCH_SUFFIX="$(versionExtra)-$(version)"
export TC_PREFIX_DIR=$(build_output_dir)
export TC_LOCAL_TARBALLS_DIR=$(download_dir)

build: configuretoolchain
	./ct-ng build

createbuildirs:
	mkdir -p $(download_dir)
	mkdir -p $(build_output_dir)
	mkdir -p $(distributions_dir)

bootstraptoolchain: createbuildirs
	./bootstrap

configuretoolchain: bootstraptoolchain
	./configure --enable-local --prefix=$(root_dir)

dist:
	tar cvzf $(distributions_dir)/crosstool-ng-$(arch)-$(version)$(version_extra).tar.gz $(build_output_dir)

clean:
	rm -rf $(build_output_dir)
	if [ -a ct-ng ]; then ./ct-ng distclean; fi

fullclean: clean
	rm .config
	rm config.status

version:
	@echo $(version)