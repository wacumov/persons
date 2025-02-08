.PHONY: auth ui-tests

auth:
	@companyDomain=$$(echo $(credentials) | cut -d ',' -f1); \
		token=$$(echo $(credentials) | cut -d ',' -f2); \
		echo "let (companyDomain, token) = (\"$$companyDomain\", \"$$token\")" > Packages/PipedriveAPI/Tests/PipedriveAPITests/Secrets.swift
	@swift Scripts/obfuscate.swift "$(credentials)" > Sources/Models/Secrets.swift

ui-tests:
	xcodebuild -scheme PersonsUITests -destination 'platform=iOS Simulator,name=iPhone 16' test