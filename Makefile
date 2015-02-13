librarian: ./bin/librarian-puppet
	./bin/librarian-puppet install

./bin/librarian-puppet: bundle

bundle:
	bundle install --path .bundle/vendor --binstubs

