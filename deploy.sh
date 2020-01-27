#! /usr/bin/env bash

function test(){
  echo "running tests..."
  pytest
}

function setup(){
  echo "installing dependencies..."
  python3 -m pip install --user --upgrade setuptools wheel

  echo "creating distribution files..."
  python3 setup.py sdist bdist_wheel

  echo "installing more dependencies..."
  python3 -m pip install --user --upgrade twine
}

function deploy_to_test_pypi(){
  version=$1
  echo "deploying to test pypi"
  python3 -m twine upload --repository-url https://test.pypi.org/legacy/ dist/*

  echo "validing deployment..."
  rm -rf test_env
  python3 -m venv test_env
  source ./test_env/bin/activate
  pip install -i https://test.pypi.org/simple/ hello-kjmerf==$version
  deactivate
  rm -rf test_env

  echo "deployment to test pypi succeeded!"
}

function deploy_to_pypi(){
  version=$1
  echo "deploying to pypi"
  twine upload dist/*

  echo "validing deployment..."
  rm -rf test_env
  python3 -m venv test_env
  source ./test_env/bin/activate
  pip install hello-kjmerf==$version
  deactivate
  rm -rf test_env

  echo "deployment to test pypi succeeded!"
}

function install(){

}

main(){
    test
    setup
    version=$(cat version.txt)
    deploy_to_test_pypi $version
    deploy_to_pypi $version
}

main
