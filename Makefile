.PHONY: sync-changelog

sync-changelog:
	rsync -avP ./content/zh/docs/changelog/ ./content/en/docs/changelog
	find ./content/en/docs/changelog | grep .md$ | xargs \
		sed -r -i "s|相关代码仓库的 CHANGELOG|CHANGELOG of each release Version|g; \
			s|(.*) CHANGELOG 汇总，最近发布版本: (.*) , 时间: (.*)|\1 CHANGELOG Summary, most recent version: \2, time: \3|g; \
			s|发布时间|Release time:|g; \
			s|仓库地址|Repo|g"
