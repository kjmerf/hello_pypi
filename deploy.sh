#! /usr/bin/env bash

set -e

function test(){
  echo "running tests..."
  pytest
}

function create_venv(){
  env=$1

  echo "creating virtual environment..."
  rm -rf $env
  python3 -m venv $env
  source ./$env/bin/activate

  echo "installing dependencies..."
  pip install wheel

  echo "removing previous distributions.."
  rm -rf dist

  echo "creating distribution files..."
  python3 setup.py sdist bdist_wheel

  echo "installing more dependencies..."
  pip install twine
}

function destroy_venv(){
  env=$1

  echo "destroying virtual environment..."
  deactivate
  rm -rf $env
}

function deploy_to_test_pypi(){
  create_venv test_pypi_venv

  echo "deploying to test pypi..."
  python3 -m twine upload --repository-url https://test.pypi.org/legacy/ dist/*

  destroy_venv test_pypi_venv
}

function deploy_to_pypi(){
  create_venv pypi_venv

  echo "deploying to pypi..."
  twine upload dist/*

  destroy_venv pypi_venv
}

main(){
    test
    deploy_to_test_pypi
    deploy_to_pypi
    echo "deployment to pypi succeeded!"
}

main
