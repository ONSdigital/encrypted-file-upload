#!/bin/bash -eux

pushd encrypted-file-upload
    make test
popd
