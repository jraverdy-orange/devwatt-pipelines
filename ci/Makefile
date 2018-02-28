
TARGET?=dw
PIPELINES_LIST?=bosh-stemcell-upload
SETTINGS?=settings.yml
delete-team:
	fly -t $(TARGET) destroy-team --team-name devwatt --non-interactive
set-team:
	fly -t $(TARGET) login -n main ;
	fly -t $(TARGET) set-team --team-name devwatt --non-interactive \
	--basic-auth-username devwatt \
	--basic-auth-password devwatt
login:
	fly -t $(TARGET) login -n devwatt -u devwatt -p devwatt

pipeline:
	for PIPELINE in $(PIPELINES_LIST) ; do \
		fly -t $(TARGET) set-pipeline -p $$PIPELINE --config $$PIPELINE.yml --non-interactive -l $(SETTINGS) ; \
	done	

unpause:
	for PIPELINE in $(PIPELINES_LIST) ; do \
		fly -t $(TARGET) unpause-pipeline -p $$PIPELINE ; \
	done	

delete:
	for PIPELINE in $(PIPELINES_LIST) ; do \
		fly -t $(TARGET) dp -p $$PIPELINE --non-interactive ; \
	done

check:
	fly -t $(TARGET) check-resource --resource $(PIPELINE)/check-versions
