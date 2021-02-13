.PHONY: clean environment

clean:
	rm -rf -f ~/Library/Developer/Xcode/DerivedData
	xcodebuild clean -workspace /iOS/App/App.xcodeproj -scheme App 

environment:
	brew install swiftlint || true
	brew install swiftformat || true
	brew install swiftgen || true

update_strings: #TODO: Improve this to get all Feature module names and iterate them all...
	cd iOS/Modules/Sources/Feature-Products/Configuration; swiftgen;
	cd iOS/Modules/Sources/CoreUI/Configuration; swiftgen;

start_server:
	cd product-reviews-docker-composer;  docker-compose up;