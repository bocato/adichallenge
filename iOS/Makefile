.PHONY: clean environment

clean:
	rm -rf -f ~/Library/Developer/Xcode/DerivedData
	xcodebuild clean -workspace /App/App.xcodeproj -scheme App 

environment:
	brew install swiftlint || true
	brew install swiftformat || true
	brew install swiftgen || true

update_strings: #TODO: Improve this to get all Feature module names and iterate them all...
	cd Modules/Sources/Feature-Products/Configuration; swiftgen;
	cd Modules/Sources/CoreUI/Configuration; swiftgen;