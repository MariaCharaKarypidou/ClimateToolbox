default: install

all: hooks install build


h help:
	@grep '^[a-z]' Makefile


.PHONY: hooks
hooks:
	cd .git/hooks && ln -s -f ../../hooks/pre-push pre-push

install:
	cargo install mdbook


s serve:
	mdbook serve
	
.MathJax {
  font-size: 120% !important;
}

build:
	mdbook build
