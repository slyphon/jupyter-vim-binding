#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

die() { echo "fatal: $*" >&2; exit 1; }

TEMP="$(mktemp -d -t TEMP.XXXXXXX)" || die "failed to make tmpdir"
cleanup() { [[ -n "${TEMP:-}" ]] && rm -rf "${TEMP}"; }
trap cleanup EXIT


TOPLEVEL=$(git rev-parse --show-toplevel)

cd "$TOPLEVEL"

git archive --prefix=jupyter-vim-binding/ --format HEAD |(cd $TEMP && tar -xf-)

cd $TEMP/jupyter-vim-binding

virtualenv testenv
source ./testenv/bin/activate

cat > "$TEMP/build-reqs.txt" <<EOS
bleach==3.1.0
certifi==2019.3.9
chardet==3.0.4
check-manifest==0.38
docutils==0.14
entrypoints==0.3
idna==2.8
keyring==19.0.1
pkginfo==1.5.0.1
Pygments==2.4.0
readme-renderer==24.0
requests==2.22.0
requests-toolbelt==0.9.1
six==1.12.0
toml==0.10.0
tqdm==4.32.1
twine==1.13.0
urllib3==1.25.2
webencodings==0.5.1
EOS

pip install --upgrade pip
pip install -r "$TEMP/build-reqs.txt"
python setup.py sdist bdist_wheel

cat > "$TEMP/jupyter-reqs.txt" <<EOS
appnope==0.1.0
attrs==19.1.0
backcall==0.1.0
bleach==3.1.0
decorator==4.4.0
defusedxml==0.6.0
entrypoints==0.3
ipykernel==5.1.1
ipython==7.5.0
ipython-genutils==0.2.0
ipywidgets==7.4.2
jedi==0.13.3
Jinja2==2.10.1
jsonschema==3.0.1
jupyter==1.0.0
jupyter-client==5.2.4
jupyter-console==6.0.0
jupyter-contrib-core==0.3.3
jupyter-contrib-nbextensions==0.5.1
jupyter-core==4.4.0
jupyter-highlight-selected-word==0.2.0
jupyter-latex-envs==1.4.6
jupyter-nbextensions-configurator==0.4.1
lxml==4.3.3
MarkupSafe==1.1.1
mistune==0.8.4
nbconvert==5.5.0
nbformat==4.4.0
notebook==5.7.8
pandocfilters==1.4.2
parso==0.4.0
pexpect==4.7.0
pickleshare==0.7.5
prometheus-client==0.6.0
prompt-toolkit==2.0.9
ptyprocess==0.6.0
Pygments==2.4.0
pyrsistent==0.15.2
python-dateutil==2.8.0
PyYAML==5.1
pyzmq==18.0.1
qtconsole==4.4.4
Send2Trash==1.5.0
six==1.12.0
slyphon-jupyter-vim-binding==0.1.0.dev2
terminado==0.8.2
testpath==0.4.2
tornado==6.0.2
traitlets==4.3.2
wcwidth==0.1.7
webencodings==0.5.1
widgetsnbextension==3.4.2
EOS

pip install -r "$TEMP/jupyter-reqs.txt"
pip install dist/slyphon-jupyter-vim-binding-*.tar.gz
jupyter nbextensions_configurator enable --sys-prefix
jupyter nbextension enable --py vim_binding --sys-prefix

