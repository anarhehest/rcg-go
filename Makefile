#
#
#

all: go-project

image: clean
	./scripts/build-image-simple.sh	

go-project: clean
	pushd src && go build && popd

clean:
	rm -f src/rcs-go
	rm -rf build
