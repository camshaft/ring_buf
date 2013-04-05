REBAR = ./rebar

default: compile

all: deps compile

compile:
	$(REBAR) compile

test/ring_buf_benchmark.beam: test/ring_buf_benchmark.erl
	erlc -o test test/ring_buf_benchmark.erl

bench: compile test/ring_buf_benchmark.beam
	./test/benchmark

deps:
	$(REBAR) get-deps

clean:
	$(REBAR) clean

distclean: clean 
	$(REBAR) delete-deps

test:
	$(REBAR) skip_deps=true eunit

docs: deps
	$(REBAR) skip_deps=true doc

dialyzer: compile
	@dialyzer -Wno_return -c ebin

.PHONY: all deps test
