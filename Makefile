HUGO_VERSION = 0.83.1
IMAGE_VERSION=$(shell scripts/hash-files.sh Dockerfile | cut -c 1-12)
CONTAINER_IMAGE = registry.cn-beijing.aliyuncs.com/yunionio/docs-hugo:v$(HUGO_VERSION)-$(IMAGE_VERSION)
CONTAINER_RUN = docker run --rm --interactive --tty --volume $(CURDIR):/src
HOST := http://localhost:1313

.PHONY: setup

module-check:
	@git submodule status --recursive | awk '/^[+-]/ {printf "\033[31mWARNING\033[0m Submodule not initialized: \033[34m%s\033[0m\n",$$2}' 1>&2

setup:
	bash -x ./scripts/setup.sh

container-image:
	docker build . \
		--network=host \
		--tag $(CONTAINER_IMAGE) \
		--build-arg HUGO_VERSION=$(HUGO_VERSION)

container-build: setup
	$(CONTAINER_RUN) --read-only --mount type=tmpfs,destination=/tmp,tmpfs-mode=01777 $(CONTAINER_IMAGE) \
		sh -c "HOST=$(HOST) EXIT_AFTER_BUILD=true ./scripts/build.sh"

container-serve: setup
	$(CONTAINER_RUN) --read-only --mount type=tmpfs,destination=/tmp,tmpfs-mode=01777 -p 1313:1313 $(CONTAINER_IMAGE) hugo server --buildFuture --bind 0.0.0.0 --destination /tmp/hugo --cleanDestinationDir

sync-changelog:
	rsync -avP ./content/zh/docs/changelog/ ./content/en/docs/changelog
	find ./content/en/docs/changelog | grep .md$ | xargs \
		sed -r -i "s|相关代码仓库的 CHANGELOG|CHANGELOG of each release Version|g; \
			s|(.*) CHANGELOG 汇总，最近发布版本: (.*) , 时间: (.*)|\1 CHANGELOG Summary, most recent version: \2, time: \3|g; \
			s|发布时间|Release time:|g; \
			s|仓库地址|Repo|g"

local-serve:
	HOST=http://localhost:1313 EXIT_AFTER_BUILD=true ./scripts/build.sh
	cd public && python3 -m http.server 1313

test:
	HOST=http://localhost:1313 EXIT_AFTER_BUILD=true ./scripts/build.sh test
	cd public && python3 -m http.server 1313
