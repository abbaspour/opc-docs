api_id=bqj1xq2eed
outfile=repository.yaml

target: $(outfile)

%.yaml:
	aws apigateway --profile opal get-export --rest-api-id $(api_id) --stage-name stg --export-type oas30 --parameters extensions='authorizers' --accepts 'application/yaml' $@
	gsed -e 's/+}:/}:/' -i $@

%.json:
	aws apigateway --profile opal get-export --rest-api-id $(api_id) --stage-name stg --export-type oas30 --parameters extensions='authorizers' --accepts 'application/json' $@
	gsed -e 's/+}" :/}" :/' -i $@

clean:
	rm -f $(outfile)

reexport:
	make clean
	make

lint:
	openapi lint $(outfile)

preview:
	openapi preview-docs -p 8888 website/api.yaml

build:
	openapi bundle -o website/api.yaml

.PHONEY: clean
